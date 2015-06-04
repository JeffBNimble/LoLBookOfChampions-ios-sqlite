//
// NIODeleteChampionSkinTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODeleteChampionSkinTask.h"
#import "NIODataDragonContract.h"


@implementation NIODeleteChampionSkinTask
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder {
	self = [super initWithDatabase:database withSQLStatementBuilder:statementBuilder];
	if ( self ) {
		self.table = [ChampionSkin DB_TABLE];
	}

	return self;
}

-(BFTask *)runAsync {
	return [self asUpdateResult:[self executeDelete]];
}

@end