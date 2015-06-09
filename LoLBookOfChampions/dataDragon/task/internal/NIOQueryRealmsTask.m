//
// NIOQueryRealmsTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/13/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryRealmsTask.h"
#import "NIODataDragonContract.h"

@implementation NIOQueryRealmsTask
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder {
	self = [super initWithDatabase:database withSQLStatementBuilder:statementBuilder];
	if ( self ) {
		self.table = [Realm DB_TABLE];
	}

	return self;
}

-(BFTask *)run {
	return [self asQueryResult:[self executeQuery]];
}

@end