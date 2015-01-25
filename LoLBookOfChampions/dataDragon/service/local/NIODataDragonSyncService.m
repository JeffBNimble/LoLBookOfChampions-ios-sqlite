//
// NIODataDragonSyncService / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <Bolts/BFExecutor.h>
#import "NIODataDragonSyncService.h"
#import "GetRealmTask.h"
#import "ContentProvider.h"

@interface NIODataDragonSyncService ()
@property (strong, nonatomic) id<ContentProvider> contentProvider;
@property (retain, nonatomic) dispatch_queue_t dispatchQueue;
@property (strong, nonatomic) GetRealmTask *getRealmTask;
@property (strong, nonatomic) BFExecutor *taskExcecutor;
@end

@implementation NIODataDragonSyncService
-(instancetype)initWithContentProvider:(id<ContentProvider>)contentProvider
					  withGetRealmTask:(GetRealmTask *)getRealmTask {
	self = [super init];
	if ( self ) {
		self.contentProvider = contentProvider;
		self.getRealmTask = getRealmTask;
		self.dispatchQueue = dispatch_queue_create(object_getClassName(self), DISPATCH_QUEUE_SERIAL);
		self.taskExcecutor = [BFExecutor executorWithDispatchQueue:self.dispatchQueue];
	}

	return self;

}

-(void)sync {

}

@end