//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>
#import "NIOTask.h"
#import "NIOAsyncTask.h"

@class NIOContentResolver;


@interface NIOClearLocalDataDragonDataTask : NIOAsyncTask<NIOTask>
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
                    withSharedURLCache:(NSURLCache *)urlCache
                 withExecutionExecutor:(BFExecutor *)executionExecutor
                withCompletionExecutor:(BFExecutor *)completionExecutor;
@end