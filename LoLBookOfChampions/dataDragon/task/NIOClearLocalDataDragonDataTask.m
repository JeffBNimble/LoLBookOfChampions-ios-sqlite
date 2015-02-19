//
// NIOClearLocalDataDragonDataTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOClearLocalDataDragonDataTask.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"

@interface NIOClearLocalDataDragonDataTask ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@property (strong, nonatomic) NSURLCache *sharedURLCache;
@end

@implementation NIOClearLocalDataDragonDataTask
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver withSharedURLCache:(NSURLCache *)sharedURLCache {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
		self.sharedURLCache = sharedURLCache;
	}

	return self;
}

-(BFTask *)runAsync {
	DDLogVerbose(@"Clearing the disk cache");
	[self.sharedURLCache removeAllCachedResponses];

	DDLogVerbose(@"Deleting Data Dragon realm");
	return [[[self.contentResolver deleteWithURI:[Realm URI]
								   withSelection:nil
							   withSelectionArgs:nil]
			continueWithBlock:^id(BFTask *task) {
				DDLogVerbose(@"Deleting Data Dragon champion data");
				return [self.contentResolver deleteWithURI:[Champion URI]
											 withSelection:nil
										 withSelectionArgs:nil];
			}]
			continueWithBlock:^id(BFTask *task) {
				DDLogVerbose(@"Deleting Data Dragon champion skin data");
				return [self.contentResolver deleteWithURI:[ChampionSkin URI]
											 withSelection:nil
										 withSelectionArgs:nil];
			}];
}

@end