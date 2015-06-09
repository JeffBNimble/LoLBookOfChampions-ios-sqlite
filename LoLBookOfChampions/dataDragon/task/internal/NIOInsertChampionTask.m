//
// NIOInsertChampionTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOInsertChampionTask.h"
#import "NIODataDragonContract.h"


@implementation NIOInsertChampionTask
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder {
	self = [super initWithDatabase:database withSQLStatementBuilder:statementBuilder];
	if ( self ) {
		self.table = [Champion DB_TABLE];
	}

	return self;
}

-(BFTask *)run {
	return [self asUpdateResult:[self executeInsert]];
}

@end