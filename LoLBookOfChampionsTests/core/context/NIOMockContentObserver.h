//
// Created by Jeff Roberts on 2/27/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentObserver.h"


@interface NIOMockContentObserver : NSObject<NIOContentObserver>
@property (strong, nonatomic) dispatch_queue_t completionQueue;
@property (assign, nonatomic) BOOL didReceiveUriUpdateNotification;
@end