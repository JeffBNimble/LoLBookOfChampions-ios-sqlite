//
// NIOQueryChampionsTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryChampionsTask.h"
#import "NIODataDragonContract.h"


@implementation NIOQueryChampionsTask
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super initWithDatabase:database];
	if ( self ) {
		self.table = [Champion DB_TABLE];
	}

	return self;
}

-(BFTask *)runAsync {
	return [self asQueryResult:[self executeQuery]];
}

@end