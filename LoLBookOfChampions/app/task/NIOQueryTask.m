//
// NIOQueryTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/21/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryTask.h"
#import "NIOContentResolver.h"

@interface NIOQueryTask ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@end

@implementation NIOQueryTask

-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
                 withExecutionExecutor:(BFExecutor *)executionExecutor
                withCompletionExecutor:(BFExecutor *)completionExecutor {
	self = [super initWithExecutionExecutor:executionExecutor
                     withCompletionExecutor:completionExecutor];
	if ( self ) {
		self.contentResolver = contentResolver;
	}

	return self;
}

-(BFTask *)run {
    __block __weak NIOQueryTask *weakSelf = self;
    return [[BFTask taskFromExecutor:self.executionExecutor withBlock:^id {
        NSError *error;
        id<NIOCursor> cursor = [weakSelf.contentResolver queryWithURI:weakSelf.uri
                                                       withProjection:weakSelf.projection
                                                        withSelection:weakSelf.selection
                                                    withSelectionArgs:weakSelf.selectionArgs
                                                          withGroupBy:weakSelf.groupBy
                                                           withHaving:weakSelf.having
                                                             withSort:weakSelf.sort
                                                            withError:&error];
        return error ? [BFTask taskWithError:error] : [BFTask taskWithResult:cursor];
    }] continueWithExecutor:weakSelf.completionExecutor withBlock:^id(BFTask *task) {
        return task;
    }];
}

@end