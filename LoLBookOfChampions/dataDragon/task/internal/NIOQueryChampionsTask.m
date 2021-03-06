//
// NIOQueryChampionsTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryChampionsTask.h"
#import "NIODataDragonContract.h"
#import "NIOSQLStatementBuilder.h"


@implementation NIOQueryChampionsTask
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id <NIOSQLStatementBuilder>)statementBuilder {
	self = [super initWithDatabase:database withSQLStatementBuilder:statementBuilder];
	if ( self ) {
		self.table = [Champion DB_TABLE];
	}

	return self;
}

-(BFTask *)run {
	return [self asQueryResult:[self executeQuery]];
}

@end