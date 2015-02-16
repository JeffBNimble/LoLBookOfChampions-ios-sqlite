//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "NIOCursor.h"


@interface NIOSqliteCursor : NSObject<NIOCursor>
-(instancetype)initWithResultSet:(FMResultSet *)resultSet withRowCount:(NSUInteger)rowCount NS_DESIGNATED_INITIALIZER;
@end