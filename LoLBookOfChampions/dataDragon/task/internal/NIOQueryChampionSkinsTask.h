//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOBaseSQLQueryTask.h"
#import "NIOTask.h"


@interface NIOQueryChampionSkinsTask : NIOBaseSQLQueryTask <NIOTask>
-(instancetype)initWithDatabase:(FMDatabase *)database;
@end