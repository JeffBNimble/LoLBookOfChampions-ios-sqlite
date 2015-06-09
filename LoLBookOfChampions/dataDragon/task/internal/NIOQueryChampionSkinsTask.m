//
// NIOQueryChampionSkinsTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryChampionSkinsTask.h"
#import "NIODataDragonContract.h"
#import "NIOSQLStatementBuilder.h"


@implementation NIOQueryChampionSkinsTask
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder {
	self = [super initWithDatabase:database withSQLStatementBuilder:statementBuilder];
	if ( self ) {
		self.table = [ChampionSkin DB_TABLE];
	}

	return self;
}

-(BFTask *)run {
	return [self asQueryResult:[self executeQuery]];
}

@end