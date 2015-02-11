//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GetRealmTask;
@class NIOContentResolver;


@interface NIODataDragonSyncService : NSObject
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
					  withGetRealmTask:(GetRealmTask *)getRealmTask;
-(void)resync;
-(void)sync;
@end