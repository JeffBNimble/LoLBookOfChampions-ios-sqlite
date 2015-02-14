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
@end

@implementation NIOClearLocalDataDragonDataTask
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
	}

	return self;
}

-(BFTask *)runAsync {
	DDLogVerbose(@"Deleting Data Dragon realms");
	BFTask *deleteTask = [self.contentResolver deleteWithURL:[Realm URI]
											   withSelection:nil
										   withSelectionArgs:nil];
	return deleteTask;
}

@end