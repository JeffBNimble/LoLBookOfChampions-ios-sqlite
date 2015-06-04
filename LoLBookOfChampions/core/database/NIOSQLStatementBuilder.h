//
// Created by Jeff Roberts on 6/3/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SELECT				@"SELECT "
#define COUNT				@"count(*)"
#define DELETE				@"DELETE "
#define FROM				@" FROM "
#define GROUP_BY			@" GROUP BY "
#define HAVING				@" HAVING "
#define INSERT_INTO			@"INSERT INTO "
#define ORDER_BY			@" ORDER BY "
#define SET					@" SET "
#define UPDATE				@"UPDATE "
#define WHERE				@" WHERE "

@protocol NIOSQLStatementBuilder <NSObject>
-(NSString *)buildDeleteStatementWithTable:(NSString *)tableName
							 withSelection:(NSString *)selection;

-(NSString *)buildInsertStatementWithTable:(NSString *)tableName
						   withColumnNames:(NSArray *)columnNames
						useNamedParameters:(BOOL)useNamedParameters;

-(NSString *)buildSelectStatementWithTable:(NSString *)tableName
							withProjection:(NSArray *)projection
							 withSelection:(NSString *)selection
							   withGroupBy:(NSString *)groupBy
								withHaving:(NSString *)having
								  withSort:(NSString *)sort;

-(NSString *)buildUpdateStatementWithTable:(NSString *)tableName
					withUpdatedColumnNames:(NSArray *)columnNames
							 withSelection:(NSString *)selection;


@end