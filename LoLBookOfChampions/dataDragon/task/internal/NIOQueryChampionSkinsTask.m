//
// NIOQueryChampionSkinsTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryChampionSkinsTask.h"
#import "NIODataDragonContract.h"


@implementation NIOQueryChampionSkinsTask
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super initWithDatabase:database];
	if ( self ) {
		self.table = [ChampionSkin DB_TABLE];
	}

	return self;
}

-(BFTask *)runAsync {
	return [self asQueryResult:[self executeQuery]];
}

@end