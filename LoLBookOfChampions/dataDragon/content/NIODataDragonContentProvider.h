//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import <Foundation/Foundation.h>
#import "ContentProvider.h"


@interface NIODataDragonContentProvider : NSObject<ContentProvider>
-(instancetype)initWithDatabase:(FMDatabase *)database;
@end