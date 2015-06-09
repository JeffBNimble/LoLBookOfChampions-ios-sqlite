//
// NIOClearLocalDataDragonDataTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOClearLocalDataDragonDataTask.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"

@interface NIOClearLocalDataDragonDataTask ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@property (strong, nonatomic) NSURLCache *sharedURLCache;
@end

@implementation NIOClearLocalDataDragonDataTask
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
                    withSharedURLCache:(NSURLCache *)sharedURLCache
                 withExecutionExecutor:(BFExecutor *)executionExecutor
                withCompletionExecutor:(BFExecutor *)completionExecutor {
	self = [super initWithExecutionExecutor:executionExecutor withCompletionExecutor:completionExecutor];
	if ( self ) {
		self.contentResolver = contentResolver;
		self.sharedURLCache = sharedURLCache;
	}

	return self;
}

-(BFTask *)run {
    __block NSError *error;
    __block NSInteger deleteCount;
    __block __weak NIOClearLocalDataDragonDataTask *weakSelf = self;
	return [[[[[BFTask taskFromExecutor:[BFExecutor immediateExecutor] withBlock:^id{
            [weakSelf.sharedURLCache removeAllCachedResponses];
            return [BFTask taskWithResult:nil];
        }] continueWithExecutor:weakSelf.executionExecutor withBlock:^id(BFTask *task) {
            DDLogVerbose(@"Deleting Data Dragon realm");
            deleteCount = [weakSelf.contentResolver deleteWithURI:[Realm URI]
                                                    withSelection:nil
                                                withSelectionArgs:nil
                                                        withError:&error];
            return error ? [BFTask taskWithError:error] : [BFTask taskWithResult:@(deleteCount)];
        }] continueWithExecutor:weakSelf.executionExecutor withBlock:^id(BFTask *task) {
            if (task.error || task.exception) return task;
            
            DDLogVerbose(@"Deleting Data Dragon champion data");
            deleteCount = [weakSelf.contentResolver deleteWithURI:[Champion URI]
                                                    withSelection:nil
                                                withSelectionArgs:nil
                                                        withError:&error];
            return error ? [BFTask taskWithError:error] : [BFTask taskWithResult:@(deleteCount)];
        }] continueWithExecutor:weakSelf.executionExecutor withBlock:^id(BFTask *task) {
            if (task.error || task.exception) return task;
            
            DDLogVerbose(@"Deleting Data Dragon champion skin data");
            deleteCount = [weakSelf.contentResolver deleteWithURI:[ChampionSkin URI]
                                                    withSelection:nil
                                                withSelectionArgs:nil
                                                        withError:&error];
            return error ? [BFTask taskWithError:error] : [BFTask taskWithResult:@(deleteCount)];
        }] continueWithExecutor:weakSelf.completionExecutor withBlock:^id(BFTask *task) {
            return task;
        }];
}

@end