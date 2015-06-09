//
//  NIOAsyncTask.m
//  LoLBookOfChampions
//
//  Created by NimbleNoggin.io on 6/8/15.
//  Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import "NIOAsyncTask.h"
@interface NIOAsyncTask()
@property (strong, nonatomic) BFExecutor *completionExecutor;
@property (strong, nonatomic) BFExecutor *executionExecutor;
@end

@implementation NIOAsyncTask
-(instancetype)initWithExecutionExecutor:(BFExecutor *)executionExecutor
                  withCompletionExecutor:(BFExecutor *)completionExecutor {
    self = [super init];
    if (self) {
        self.executionExecutor = executionExecutor;
        self.completionExecutor = completionExecutor;
    }
    
    return self;
}
@end
