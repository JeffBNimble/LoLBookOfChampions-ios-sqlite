//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"
#import "NIOAsyncTask.h"

@class NIOContentResolver;


@interface NIOInsertDataDragonChampionDataTask : NIOAsyncTask<NIOTask>
@property (strong, nonatomic) NSURL *dataDragonCDN;
@property (strong, nonatomic) NSString *dataDragonRealmVersion;
@property (strong, nonatomic) NSDictionary *remoteDataDragonChampionData;

-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
                 withExecutionExecutor:(BFExecutor *)executionExecutor
                withCompletionExecutor:(BFExecutor *)completionExecutor;
@end