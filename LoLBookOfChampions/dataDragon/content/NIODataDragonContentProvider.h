//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentProvider.h"


@interface NIODataDragonContentProvider : NSObject<NIOContentProvider>
-(instancetype)initWithDatabaseName:(NSString *)databaseName withVersion:(NSInteger)version;
@end