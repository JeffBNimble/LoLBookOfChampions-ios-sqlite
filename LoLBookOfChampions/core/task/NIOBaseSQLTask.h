//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import <Bolts/Bolts.h>

#define SELECT				@"SELECT "
#define DELETE				@"DELETE "
#define FROM				@" FROM "
#define GROUP_BY			@" GROUP BY "
#define HAVING				@" HAVING "
#define INSERT_INTO			@"INSERT INTO "
#define ORDER_BY			@" ORDER BY "
#define SET					@" SET "
#define UPDATE				@"UPDATE "
#define WHERE				@" WHERE "

@interface NIOBaseSQLTask : NSObject
@property (strong, nonatomic, readonly) FMDatabase *database;
@property (strong, nonatomic) NSString *selection;
@property (strong, nonatomic) NSArray *selectionArgs;
@property (strong, nonatomic) NSString *table;
@property (strong, nonatomic) NSDictionary *values;

-(instancetype)initWithDatabase:(FMDatabase *)database NS_DESIGNATED_INITIALIZER;

-(BFTask *)asUpdateResult:(NSInteger)rowsUpdated;
-(NSInteger)executeDelete;
-(NSInteger)executeInsert;
@end