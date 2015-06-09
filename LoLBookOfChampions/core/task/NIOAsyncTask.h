//
//  NIOAsyncTask.h
//  LoLBookOfChampions
//
//  Created by NimbleNoggin.io on 6/8/15.
//  Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@interface NIOAsyncTask : NSObject

@property (strong, nonatomic, readonly) BFExecutor *completionExecutor;
@property (strong, nonatomic, readonly) BFExecutor *executionExecutor;

-(instancetype)initWithExecutionExecutor:(BFExecutor *)executionExecutor
                  withCompletionExecutor:(BFExecutor *)completionExecutor;
@end
