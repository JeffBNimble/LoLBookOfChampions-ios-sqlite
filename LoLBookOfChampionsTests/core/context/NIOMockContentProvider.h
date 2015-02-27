//
// Created by Jeff Roberts on 2/26/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentProvider.h"
#import "NIOBaseContentProvider.h"


@interface NIOMockContentProvider : NIOBaseContentProvider
@property (strong, nonatomic) NSError *failWithError;
@property (strong, nonatomic) dispatch_queue_t executionQueue;
@end