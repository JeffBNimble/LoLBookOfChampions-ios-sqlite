//
// NIODataDragonSyncService / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <Bolts/Bolts.h>
#import "NIODataDragonSyncService.h"
#import "NIOGetRealmTask.h"
#import "NIOContentProvider.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"
#import "NIOTaskFactory.h"
#import "NIOClearLocalDataDragonDataTask.h"
#import "NIOInsertDataDragonRealmTask.h"
#import "NIOGetChampionStaticDataTask.h"
#import "NIOInsertDataDragonChampionDataTask.h"

@interface NIODataDragonSyncService ()
@property (strong, nonatomic) NSString *dataDragonCDN;
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@property (strong, nonatomic) NSString *localDataDragonVersion;
@property (retain, nonatomic) dispatch_queue_t taskExecutionQueue;
@property (strong, nonatomic) BFExecutor *taskExecutor;
@property (strong, nonatomic) id<NIOTaskFactory> taskFactory;
@end

@implementation NIODataDragonSyncService
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
					   withTaskFactory:(id<NIOTaskFactory>)taskFactory {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
		self.taskFactory = taskFactory;
		self.taskExecutionQueue = dispatch_queue_create(object_getClassName(self), DISPATCH_QUEUE_SERIAL);
		self.taskExecutor = [BFExecutor executorWithDispatchQueue:self.taskExecutionQueue];
	}

	return self;
}

-(BFTask *)getChampionStaticData {
	return [[self.taskFactory createTaskWithType:[NIOGetChampionStaticDataTask class]] runAsync];
}

-(NSString *)getLocalDataDragonVersion:(FMResultSet *)cursor {
	NSString *localDataDragonVersion;
	if ( [cursor next] ) {
		localDataDragonVersion = [cursor stringForColumn:[RealmColumns COL_REALM_VERSION]];
	} else {
		DDLogInfo(@"No local Data Dragon version found");
		localDataDragonVersion = [@(NSNotFound) stringValue];
	}

	[cursor close];

	return localDataDragonVersion;
}

-(BFTask *)insertChampionStaticDataWithRemoteChampionData:(NSDictionary *)championResponse {
	NIOInsertDataDragonChampionDataTask *insertChampionDataTask = [self.taskFactory createTaskWithType:[NIOInsertDataDragonChampionDataTask class]];
	insertChampionDataTask.remoteDataDragonChampionData = championResponse;
	insertChampionDataTask.dataDragonCDN = [NSURL URLWithString:self.dataDragonCDN];
	insertChampionDataTask.dataDragonRealmVersion = self.localDataDragonVersion;

	return [insertChampionDataTask runAsync];
}

-(BFTask *)insertRealmWithRemoteRealmData:(NSDictionary *)realmResponse {
	NSString *remoteDataDragonVersion = realmResponse[@"v"];
	DDLogInfo(@"Found remote data dragon version %@", remoteDataDragonVersion);
	self.localDataDragonVersion = remoteDataDragonVersion;
	self.dataDragonCDN = realmResponse[@"cdn"];

	NIOInsertDataDragonRealmTask *insertDataDragonRealmTask = [self.taskFactory createTaskWithType:[NIOInsertDataDragonRealmTask class]];
	insertDataDragonRealmTask.remoteDataDragonRealmData = realmResponse;
	return [insertDataDragonRealmTask runAsync];
}

-(void)resync {
	DDLogInfo(@"Resyncing remote data dragon data with local database");

	[[[[[[BFTask taskFromExecutor:self.taskExecutor withBlock:^id {
		return [[self.taskFactory createTaskWithType:[NIOClearLocalDataDragonDataTask class]] runAsync];
	}] continueWithExecutor:self.taskExecutor withBlock:^id(BFTask *task) {
		if ( task.error ) {
			DDLogError(@"An error occurred attempting to delete the local data dragon data: %@", task.error);
			return nil;
		}

		return [[self.taskFactory createTaskWithType:[NIOGetRealmTask class]] runAsync];
	}] continueWithExecutor:self.taskExecutor withBlock:^id(BFTask *task) {
		if ( task.error ) {
			DDLogError(@"An error occurred attempting to retrieve the remote data dragon realm: %@", task.error);
			return nil;
		}

		return [self insertRealmWithRemoteRealmData:task.result];
	}] continueWithExecutor:self.taskExecutor withBlock:^id(BFTask *task) {
		return [self getChampionStaticData];
	}] continueWithExecutor:self.taskExecutor withBlock:^id(BFTask *task) {
		return task.error ? task : [self insertChampionStaticDataWithRemoteChampionData:task.result];
	}] continueWithExecutor:self.taskExecutor withBlock:^id(BFTask *task) {
		if ( task.error ) {
			DDLogError(@"An error occurred attempting to resync the remote data dragon data with the local database: %@", task.error);
		} else {
			DDLogInfo(@"Resync of remote data dragon data with the local database has completed successfully");
		}
		return nil;
	}];
}

-(void)sync {
	self.localDataDragonVersion = nil;

	[BFTask taskFromExecutor:self.taskExecutor withBlock:^id {
		[[[[self.contentResolver queryWithURL:[Realm URI]
							   withProjection:@[[RealmColumns COL_REALM_VERSION]]
								withSelection:nil
							withSelectionArgs:nil
								  withGroupBy:nil
								   withHaving:nil
									 withSort:nil]
				continueWithBlock:^id(BFTask *task) {
					if ( task.error ) {
						DDLogError(@"An error occurred retrieving the local data dragon realm info: %@", task.error);
						return [BFTask taskWithError:task.error];
					} else {
						return [BFTask taskWithResult:[self getLocalDataDragonVersion:task.result]];
					}
				}] continueWithBlock:^id(BFTask *task) {
					if ( task.error ) {
						return task;
					} else {
						NSString *localDataDragonVersion = task.result;
						if ( [[@(NSNotFound) stringValue] isEqualToString:localDataDragonVersion] ) {
							[self resync];
							return [BFTask taskWithError:[NSError errorWithDomain:@"datadragon.content"
																			 code:1
																		 userInfo:nil]];
						}

						DDLogInfo(@"Found local data dragon version %@", localDataDragonVersion);
						self.localDataDragonVersion = localDataDragonVersion;
						return [[self.taskFactory createTaskWithType:[NIOGetRealmTask class]] runAsync];
					}
				}] continueWithExecutor:self.taskExecutor withSuccessBlock:^id(BFTask *task) {
					NSDictionary *remoteDataDragonRealmData = task.result;
					NSString *remoteDataDragonVersion = remoteDataDragonRealmData[@"v"];
					DDLogInfo(@"Found remote data dragon version %@", remoteDataDragonVersion);

					if ( [self.localDataDragonVersion isEqualToString:remoteDataDragonVersion] ) {
						DDLogInfo(@"Local data dragon version is the latest available");
					} else {
						[self resync];
					}

					return nil;
				}];
		return nil;
	}];
}

@end