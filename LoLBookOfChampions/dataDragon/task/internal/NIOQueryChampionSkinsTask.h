//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOBaseSQLTask.h"
#import "NIOTask.h"

@protocol NIOSQLStatementBuilder;


@interface NIOQueryChampionSkinsTask : NIOBaseSQLTask <NIOTask>
-(instancetype)initWithDatabase:(FMDatabase *)database
		withSQLStatementBuilder:(id<NIOSQLStatementBuilder>)statementBuilder;
@end