//
// NIOBaseSQLTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOBaseSQLTask.h"
#import "NIOSQLStatementBuilder.h"
#import "NIOSqliteCursor.h"

@interface NIOBaseSQLTask ()
@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) id<NIOSQLStatementBuilder>statementBuilder;
@end

@implementation NIOBaseSQLTask
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder {
	self = [super init];
	if ( self ) {
		self.database = database;
		self.statementBuilder = statementBuilder;
	}

	return self;
}

-(BFTask *)asQueryResult:(FMResultSet *)queryResultSet {
	FMResultSet *countResultSet = [self executeCountQuery];
	int rowCount = 0;
	if ( countResultSet ) {
		if ( [countResultSet next] ) {
			rowCount = [countResultSet intForColumnIndex:0];
		}
		[countResultSet close];
	}

	return [self asQueryResult:queryResultSet withRowCount:(uint)rowCount];
}

-(BFTask *)asQueryResult:(FMResultSet *)queryResultSet withRowCount:(uint)rowCount {
	return queryResultSet ?
		   [BFTask taskWithResult:[[NIOSqliteCursor alloc] initWithResultSet:queryResultSet withRowCount:rowCount]] :
		   [BFTask taskWithError:self.database.lastError];
}

-(BFTask *)asUpdateResult:(NSInteger)rowsUpdated {
	return self.database.lastErrorCode > 0 ?
		   [BFTask taskWithError:self.database.lastError] :
		   [BFTask taskWithResult:@(self.database.changes)];
}

-(FMResultSet *)executeCountQuery {
	return [self executeQueryWithProjection:@[COUNT]];
}

-(NSInteger)executeDelete {
	NSString *sqlStatement = [self.statementBuilder buildDeleteStatementWithTable:self.table
																	withSelection:self.selection];

	if ( self.selectionArgs && self.selectionArgs.count ) {
		[self.database executeUpdate:sqlStatement withArgumentsInArray:self.selectionArgs];
	} else {
		[self.database executeUpdate:sqlStatement];
	}

	return self.database.changes;
}

-(NSInteger)executeInsert {
	NSString *sqlStatement = [self.statementBuilder buildInsertStatementWithTable:self.table
																  withColumnNames:self.values.allKeys
															   useNamedParameters:YES];

	[self.database executeUpdate:sqlStatement withParameterDictionary:self.values];

	return self.database.changes;
}

-(FMResultSet *)executeQuery {
	return [self executeQueryWithProjection:self.projection];
}


-(FMResultSet *)executeQueryWithProjection:(NSArray *)projection {
	NSString *sqlStatement = [self.statementBuilder buildSelectStatementWithTable:self.table
																   withProjection:projection
																	withSelection:self.selection
																	  withGroupBy:self.groupBy
																	   withHaving:self.having
																		 withSort:self.sort];

	return self.selectionArgs ?
		   [self.database executeQuery:sqlStatement withArgumentsInArray:self.selectionArgs] :
		   [self.database executeQuery:sqlStatement];
}

-(NSInteger)executeUpdate {
	NSString *sqlStatement = [self.statementBuilder buildUpdateStatementWithTable:self.table
														   withUpdatedColumnNames:self.values.allKeys
																	withSelection:self.selection];

	NSMutableArray *parameters = [NSMutableArray new];

	// Add all SET values to an array in the order of the keys
	for (NSString *columnName in self.values.allKeys) {
		[parameters addObject:self.values[columnName]];
	}

	// Append all selectionArgs
	if (self.selectionArgs && self.selectionArgs.count) {
		[parameters addObjectsFromArray:self.selectionArgs];
	}

	[self.database executeUpdate:sqlStatement withArgumentsInArray:parameters];

	return self.database.changes;
}


@end