//
// NIODefaultSQLStatementBuilder / LoLBookOfChampions
//
// Created by Jeff Roberts on 6/3/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODefaultSQLStatementBuilder.h"

#define PROJECTION_ALL		@"*"

@implementation NIODefaultSQLStatementBuilder
-(instancetype)init {
	self = [super init];

	return self;
}

-(NSString *)buildDeleteStatementWithTable:(NSString *)tableName withSelection:(NSString *)selection {
	NSMutableString *sqlStatement = [NSMutableString new];
	[sqlStatement appendString:DELETE];
	[sqlStatement appendString:FROM];
	[sqlStatement appendString:tableName];

	if ( selection && selection.length ) {
		[sqlStatement appendString:WHERE];
		[sqlStatement appendString:selection];
	}

	return sqlStatement;
}

-(NSString *)buildInsertStatementWithTable:(NSString *)tableName
						   withColumnNames:(NSArray *)columnNames
						useNamedParameters:(BOOL)useNamedParameters {

	NSMutableString *sqlStatement = [NSMutableString new];
	[sqlStatement appendString:INSERT_INTO];
	[sqlStatement appendString:tableName];
	[sqlStatement appendString:@" ("];
	[sqlStatement appendString:[columnNames componentsJoinedByString:@","]];
	[sqlStatement appendString:@") VALUES ("];

	NSString *comma = @"";
	for ( NSString *columnName in columnNames ) {
		[sqlStatement appendString:comma];
		if ( useNamedParameters ) {
			[sqlStatement appendString:@":"];
			[sqlStatement appendString:columnName];
		} else {
			[sqlStatement appendString:@"?"];
		}

		comma = @",";
	}

	[sqlStatement appendString:@")"];

	return sqlStatement;
}

-(NSString *)buildSelectStatementWithTable:(NSString *)tableName
							withProjection:(NSArray *)projection
							 withSelection:(NSString *)selection
							   withGroupBy:(NSString *)groupBy
								withHaving:(NSString *)having
								  withSort:(NSString *)sort {
	NSMutableString *sqlStatement = [NSMutableString new];
	[sqlStatement appendString:SELECT];
	[sqlStatement appendString:[self createProjection:projection]];
	[sqlStatement appendString:FROM];
	[sqlStatement appendString:tableName];

	if ( selection && selection.length ) {
		[sqlStatement appendString:WHERE];
		[sqlStatement appendString:selection];
	}

	if ( groupBy && groupBy.length ) {
		[sqlStatement appendString:GROUP_BY];
		[sqlStatement appendString:groupBy];
	}

	if ( having && having.length ) {
		[sqlStatement appendString:HAVING];
		[sqlStatement appendString:having];
	}

	if ( sort && sort.length ) {
		[sqlStatement appendString:ORDER_BY];
		[sqlStatement appendString:sort];
	}

	return sqlStatement;
}

-(NSString *)buildUpdateStatementWithTable:(NSString *)tableName
					withUpdatedColumnNames:(NSArray *)columnNames
							 withSelection:(NSString *)selection {
	NSMutableString *sqlStatement = [NSMutableString new];
	[sqlStatement appendString:UPDATE];
	[sqlStatement appendString:tableName];
	[sqlStatement appendString:SET];

	NSString *comma = @"";
	for ( NSString *columnName in columnNames ) {
		[sqlStatement appendString:comma];
		[sqlStatement appendString:columnName];
		[sqlStatement appendString:@" = ?"];

		comma = @",";
	}

	if ( selection && selection.length ) {
		[sqlStatement appendString:WHERE];
		[sqlStatement appendString:selection];
	}

	return sqlStatement;
}

-(NSString *)createProjection:(NSArray *)projection {
	return projection && projection.count ? [projection componentsJoinedByString:@","] : PROJECTION_ALL;
}


@end