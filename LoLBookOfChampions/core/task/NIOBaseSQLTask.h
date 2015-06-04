//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import <Bolts/Bolts.h>

@protocol NIOSQLStatementBuilder;

@interface NIOBaseSQLTask : NSObject
@property (strong, nonatomic, readonly) FMDatabase *database;
@property (strong, nonatomic) NSString *groupBy;
@property (strong, nonatomic) NSString *having;
@property (strong, nonatomic) NSArray *projection;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *selection;
@property (strong, nonatomic) NSArray *selectionArgs;
@property (strong, nonatomic) NSString *table;
@property (strong, nonatomic) NSDictionary *values;

-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder NS_DESIGNATED_INITIALIZER;

-(BFTask *)asQueryResult:(FMResultSet *)queryResultSet;
-(BFTask *)asUpdateResult:(NSInteger)rowsUpdated;
-(NSInteger)executeDelete;
-(NSInteger)executeInsert;
-(FMResultSet *)executeQuery;
-(NSInteger)executeUpdate;
@end