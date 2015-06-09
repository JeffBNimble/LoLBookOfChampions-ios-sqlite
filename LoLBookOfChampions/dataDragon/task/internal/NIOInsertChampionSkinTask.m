//
// NIOInsertChampionSkinTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOInsertChampionSkinTask.h"
#import "NIODataDragonContract.h"


@implementation NIOInsertChampionSkinTask
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder {
	self = [super initWithDatabase:database withSQLStatementBuilder:statementBuilder];
	if ( self ) {
		self.table = [ChampionSkin DB_TABLE];
	}

	return self;
}

-(BFTask *)run {
	return [self asUpdateResult:[self executeInsert]];
}

@end