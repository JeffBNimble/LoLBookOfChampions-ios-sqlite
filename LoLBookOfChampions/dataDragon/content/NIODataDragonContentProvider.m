//
// NIODataDragonContentProvider / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODataDragonContentProvider.h"
#import "NIODataDragonSqliteOpenHelper.h"
#import "NIOUriMatcher.h"
#import "NIODataDragonContract.h"
#import "NIOTaskFactory.h"
#import "NIOQueryRealmsTask.h"
#import "NIODeleteRealmsTask.h"
#import "NIOInsertRealmTask.h"
#import <Bolts/Bolts.h>

#define REALM_URI			1
#define	CHAMPION_URI		2

@interface NIODataDragonContentProvider ()
@property (strong, nonatomic) NIODataDragonSqliteOpenHelper *databaseHelper;
@property (assign, nonatomic) NSInteger databaseVersion;
@property (strong, nonatomic) id<NIOTaskFactory> taskFactory;
@property (strong, nonatomic) NIOUriMatcher *urlMatcher;
@end

@implementation NIODataDragonContentProvider
-(instancetype)initWithTaskFactory:(id<NIOTaskFactory>)taskFactory
			  withSqliteOpenHelper:(NIODataDragonSqliteOpenHelper *)sqliteOpenHelper {
	self = [super init];
	if ( self ) {
		self.taskFactory = taskFactory;
		self.databaseHelper = sqliteOpenHelper;
    }

	return self;
}

-(BFTask *)deleteRealmWithSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	NIODeleteRealmsTask *deleteRealmsTask = [self.taskFactory createTaskWithType:[NIODeleteRealmsTask class]];
	deleteRealmsTask.selection = selection;
	deleteRealmsTask.selectionArgs = selectionArgs;
	return [deleteRealmsTask runAsync];
}

-(NSInteger)deleteWithURL:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error {
	BFTask *promise;
	NSInteger matchedURI = [self.urlMatcher match:uri];
	switch (matchedURI) {
		case REALM_URI:
			promise = [self deleteRealmWithSelection:selection withSelectionArgs:selectionArgs];
			break;

		default:
			promise = [BFTask taskWithError:[NSError errorWithDomain:@"content.provider.datadragon"
																code:99
															userInfo:nil]];
			DDLogError(@"Unmatched URI %@", [uri absoluteString]);
	}

	[promise waitUntilFinished];

	if ( promise.error ) {
		*error = promise.error;
		return -1;
	} else {
		return [((NSNumber *) promise.result) integerValue];
	}
}

-(BFTask *)insertRealmWithValues:(NSDictionary *)values {
	NIOInsertRealmTask *insertRealmTask = [self.taskFactory createTaskWithType:[NIOInsertRealmTask class]];
	insertRealmTask.values = values;
	return [insertRealmTask runAsync];
}

-(NSURL *)insertWithURL:(NSURL *)uri
			 withValues:(NSDictionary *)values
			  withError:(NSError **)error {
	BFTask *promise;
	NSInteger matchedURI = [self.urlMatcher match:uri];
	switch (matchedURI) {
		case REALM_URI:
			promise = [self insertRealmWithValues:values];
			break;

		default:
			promise = [BFTask taskWithError:[NSError errorWithDomain:@"content.provider.datadragon"
																code:99
															userInfo:nil]];
			DDLogError(@"Unmatched URI %@", [uri absoluteString]);
	}

	[promise waitUntilFinished];

	if ( promise.error ) {
		*error = promise.error;
		return nil;
	} else {
		return uri;
	}
}

-(void)onCreate {
	[super onCreate];

	self.urlMatcher = [[NIOUriMatcher alloc] initWith:NO_MATCH];
	[self.urlMatcher addURL:[Realm URI] withMatchCode:REALM_URI];
	[self.urlMatcher addURL:[Champion URI] withMatchCode:CHAMPION_URI];
}

-(FMResultSet *)queryWithURL:(NSURL *)uri
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort
				   withError:(NSError **)error {

	BFTask *promise;
	NSInteger matchedURI = [self.urlMatcher match:uri];
	switch (matchedURI) {
		case REALM_URI:
			promise = [self queryRealmWithProjection:projection
									   withSelection:selection
								   withSelectionArgs:selectionArgs
										 withGroupBy:groupBy
										  withHaving:having
											withSort:sort];
			break;

		default:
			promise = [BFTask taskWithError:[NSError errorWithDomain:@"content.provider.datadragon"
																code:99
															userInfo:nil]];
			DDLogError(@"Unmatched URI %@", [uri absoluteString]);
	}

	[promise waitUntilFinished];

	if ( promise.error ) {
		*error = promise.error;
		return nil;
	} else {
		return promise.result;
	}
}

-(BFTask *)queryRealmWithProjection:(NSArray *)projection
					  withSelection:(NSString *)selection
				  withSelectionArgs:(NSArray *)selectionArgs
						withGroupBy:(NSString *)groupBy
						 withHaving:(NSString *)having
						   withSort:(NSString *)sort {
	NIOQueryRealmsTask *queryTask = [self.taskFactory createTaskWithType:[NIOQueryRealmsTask class]];
	queryTask.projection = projection;
	queryTask.selection = selection;
	queryTask.selectionArgs = selectionArgs;
	queryTask.groupBy = groupBy;
	queryTask.having = having;
	queryTask.sort = sort;

	return [queryTask runAsync];
}

-(NSInteger)updateWithURL:(NSURL *)url
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error {
	return 27;
}

@end