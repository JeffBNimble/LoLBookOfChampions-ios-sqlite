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

@interface NIODataDragonSyncService ()
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

-(NSString *)getLocalDataDragonVersion:(FMResultSet *)cursor {
	NSString *localDataDragonVersion;
	if ( [cursor next] ) {
		localDataDragonVersion = [cursor stringForColumn:[RealmColumns COL_REALM_VERSION]];
		DDLogInfo(@"Found local Data Dragon version %@", localDataDragonVersion);
	} else {
		DDLogInfo(@"No local Data Dragon version found");
		localDataDragonVersion = [@(NSNotFound) stringValue];
	}

	[cursor close];

	return localDataDragonVersion;
}

-(void)resync {
	[[[BFTask taskFromExecutor:self.taskExecutor withBlock:^id {
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

		NSDictionary *realmResponse = task.result;
		NSString *remoteDataDragonVersion = realmResponse[@"v"];
		DDLogInfo(@"Found remote data dragon version %@", remoteDataDragonVersion);

		NIOInsertDataDragonRealmTask *insertDataDragonRealmTask = [self.taskFactory createTaskWithType:[NIOInsertDataDragonRealmTask class]];
		insertDataDragonRealmTask.remoteDataDragonRealmData = realmResponse;
		return [insertDataDragonRealmTask runAsync];
	}];
}

-(void)sync {
	self.localDataDragonVersion = nil;

	[BFTask taskFromExecutor:self.taskExecutor withBlock:^id {
		[[[self.contentResolver queryWithURL:[Realm URI]
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
			if ( !task.error ) {
				NSString *localDataDragonVersion = task.result;
				if ( [[@(NSNotFound) stringValue] isEqualToString:localDataDragonVersion] ) {
					[self resync];
					return nil;
				}

				DDLogInfo(@"Found local data dragon version %@", localDataDragonVersion);
				self.localDataDragonVersion = localDataDragonVersion;
				return [[self.taskFactory createTaskWithType:[NIOGetRealmTask class]] runAsync];
			}
			return nil;
		}];
		return nil;
	}];
}

@end