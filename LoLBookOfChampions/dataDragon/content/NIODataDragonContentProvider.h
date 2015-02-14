//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentProvider.h"
#import "NIOBaseContentProvider.h"

@class NIOContentResolver;
@protocol NIOTaskFactory;
@class NIODataDragonSqliteOpenHelper;


@interface NIODataDragonContentProvider : NIOBaseContentProvider
-(instancetype)initWithTaskFactory:(id<NIOTaskFactory>)taskFactory
			  withSqliteOpenHelper:(NIODataDragonSqliteOpenHelper *)sqliteOpenHelper NS_DESIGNATED_INITIALIZER;
@end