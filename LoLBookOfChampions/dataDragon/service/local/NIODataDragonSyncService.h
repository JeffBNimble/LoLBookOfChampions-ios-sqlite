//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NIOContentResolver;
@protocol NIOTaskFactory;

@interface NIODataDragonSyncService : NSObject
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
					   withTaskFactory:(id <NIOTaskFactory>)taskFactory;
-(void)resync;
-(void)sync;
@end