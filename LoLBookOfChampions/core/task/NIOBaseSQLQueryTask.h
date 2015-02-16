//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOBaseSQLTask.h"
#import <Bolts/Bolts.h>

@protocol NIOCursor;

@interface NIOBaseSQLQueryTask : NIOBaseSQLTask
@property (strong, nonatomic) NSString *groupBy;
@property (strong, nonatomic) NSString *having;
@property (strong, nonatomic) NSArray *projection;
@property (strong, nonatomic) NSString *sort;

-(instancetype)initWithDatabase:(FMDatabase *)database NS_DESIGNATED_INITIALIZER;

-(BFTask *)asQueryResult:(FMResultSet *)queryResultSet;
-(FMResultSet *)executeQuery;

@end