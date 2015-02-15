//
// NIODeleteChampionTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODeleteChampionTask.h"
#import "NIODataDragonContract.h"


@implementation NIODeleteChampionTask
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super initWithDatabase:database];
	if ( self ) {
		self.table = [Champion DB_TABLE];
	}

	return self;
}

-(BFTask *)runAsync {
	return [self asUpdateResult:[self executeDelete]];
}

@end