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
#import "NIODeleteRealmTask.h"
#import "NIOInsertRealmTask.h"
#import "NIODeleteChampionSkinTask.h"
#import "NIODeleteChampionTask.h"
#import "NIOInsertChampionTask.h"
#import "NIOInsertChampionSkinTask.h"
#import "NIOQueryChampionsTask.h"
#import "NIOQueryChampionSkinsTask.h"
#import <Bolts/Bolts.h>

#define REALM_URI			1
#define	CHAMPIONS_URI		2
#define	CHAMPION_SKINS_URI	3

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

-(BFTask *)deleteChampionWithSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	NIODeleteChampionTask *deleteChampionTask = [self.taskFactory createTaskWithType:[NIODeleteChampionTask class]];
	deleteChampionTask.selection = selection;
	deleteChampionTask.selectionArgs = selectionArgs;
	return [deleteChampionTask runAsync];
}

-(BFTask *)deleteChampionSkinWithSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	NIODeleteChampionSkinTask *deleteChampionSkinTask = [self.taskFactory createTaskWithType:[NIODeleteChampionSkinTask class]];
	deleteChampionSkinTask.selection = selection;
	deleteChampionSkinTask.selectionArgs = selectionArgs;
	return [deleteChampionSkinTask runAsync];
}

-(BFTask *)deleteRealmWithSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	NIODeleteRealmTask *deleteRealmsTask = [self.taskFactory createTaskWithType:[NIODeleteRealmTask class]];
	deleteRealmsTask.selection = selection;
	deleteRealmsTask.selectionArgs = selectionArgs;
	return [deleteRealmsTask runAsync];
}

-(NSInteger)deleteWithURI:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error {
	BFTask *promise;
	NSInteger matchedURI = [self.urlMatcher match:uri];
	switch (matchedURI) {
		case REALM_URI:
			promise = [self deleteRealmWithSelection:selection withSelectionArgs:selectionArgs];
			break;

		case CHAMPIONS_URI:
			promise = [self deleteChampionWithSelection:selection withSelectionArgs:selectionArgs];
			break;

		case CHAMPION_SKINS_URI:
			promise = [self deleteChampionSkinWithSelection:selection withSelectionArgs:selectionArgs];
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

-(BFTask *)insertChampionWithValues:(NSDictionary *)values {
	NIOInsertChampionTask *insertChampionTask = [self.taskFactory createTaskWithType:[NIOInsertChampionTask class]];
	insertChampionTask.values = values;
	return [insertChampionTask runAsync];
}

-(BFTask *)insertChampionSkinWithValues:(NSDictionary *)values {
	NIOInsertChampionSkinTask *insertChampionSkinTask = [self.taskFactory createTaskWithType:[NIOInsertChampionSkinTask class]];
	insertChampionSkinTask.values = values;
	return [insertChampionSkinTask runAsync];
}

-(BFTask *)insertRealmWithValues:(NSDictionary *)values {
	NIOInsertRealmTask *insertRealmTask = [self.taskFactory createTaskWithType:[NIOInsertRealmTask class]];
	insertRealmTask.values = values;
	return [insertRealmTask runAsync];
}

-(NSURL *)insertWithURI:(NSURL *)uri
			 withValues:(NSDictionary *)values
			  withError:(NSError **)error {
	BFTask *promise;
	NSInteger matchedURI = [self.urlMatcher match:uri];
	switch (matchedURI) {
		case REALM_URI:
			promise = [self insertRealmWithValues:values];
			break;

		case CHAMPIONS_URI:
			promise = [self insertChampionWithValues:values];
			break;

		case CHAMPION_SKINS_URI:
			promise = [self insertChampionSkinWithValues:values];
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
	[self.urlMatcher addURL:[Champion URI] withMatchCode:CHAMPIONS_URI];
	[self.urlMatcher addURL:[ChampionSkin URI] withMatchCode:CHAMPION_SKINS_URI];
}

-(id<NIOCursor>)queryWithURI:(NSURL *)uri
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

		case CHAMPIONS_URI:
			promise = [self queryChampionsWithProjection:projection
										   withSelection:selection
									   withSelectionArgs:selectionArgs
											 withGroupBy:groupBy
											  withHaving:having
												withSort:sort];
			break;

		case CHAMPION_SKINS_URI:
			promise = [self queryChampionSkinsWithProjection:projection
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

-(BFTask *)queryChampionsWithProjection:(NSArray *)projection
					  withSelection:(NSString *)selection
				  withSelectionArgs:(NSArray *)selectionArgs
						withGroupBy:(NSString *)groupBy
						 withHaving:(NSString *)having
						   withSort:(NSString *)sort {
	NIOQueryChampionsTask *queryTask = [self.taskFactory createTaskWithType:[NIOQueryChampionsTask class]];
	queryTask.projection = projection;
	queryTask.selection = selection;
	queryTask.selectionArgs = selectionArgs;
	queryTask.groupBy = groupBy;
	queryTask.having = having;
	queryTask.sort = sort;

	return [queryTask runAsync];
}

-(BFTask *)queryChampionSkinsWithProjection:(NSArray *)projection
						  withSelection:(NSString *)selection
					  withSelectionArgs:(NSArray *)selectionArgs
							withGroupBy:(NSString *)groupBy
							 withHaving:(NSString *)having
							   withSort:(NSString *)sort {
	NIOQueryChampionSkinsTask *queryTask = [self.taskFactory createTaskWithType:[NIOQueryChampionSkinsTask class]];
	queryTask.projection = projection;
	queryTask.selection = selection;
	queryTask.selectionArgs = selectionArgs;
	queryTask.groupBy = groupBy;
	queryTask.having = having;
	queryTask.sort = sort;

	return [queryTask runAsync];
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

@end