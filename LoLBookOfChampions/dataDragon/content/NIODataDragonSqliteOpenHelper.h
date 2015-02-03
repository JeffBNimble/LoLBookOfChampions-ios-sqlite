//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOSqliteOpenHelper.h"


@interface NIODataDragonSqliteOpenHelper : NIOSqliteOpenHelper
-(instancetype)initWithName:(NSString *)name withVersion:(NSInteger)version;
@end