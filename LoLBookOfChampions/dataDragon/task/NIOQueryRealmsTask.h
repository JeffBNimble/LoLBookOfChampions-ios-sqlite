//
// Created by Jeff Roberts on 2/13/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "NIOTask.h"


@interface NIOQueryRealmsTask : NSObject<NIOTask>
-(instancetype)initWithDatabase:(FMDatabase *)database;
@end