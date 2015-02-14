//
// NIODataDragonSyncService / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <Bolts/Bolts.h>
#import "NIODataDragonSyncService.h"
#import "GetRealmTask.h"
#import "NIOContentProvider.h"
#import "NIOContentResolver.h"
#import "DataDragonContract.h"
#import "NIOTaskFactory.h"

@interface NIODataDragonSyncService ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@property (retain, nonatomic) dispatch_queue_t dispatchQueue;
@property (strong, nonatomic) id<NIOTaskFactory> taskFactory;
@property (strong, nonatomic) BFExecutor *taskExecutor;
@end

@implementation NIODataDragonSyncService
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
					   withTaskFactory:(id<NIOTaskFactory>)taskFactory {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
		self.taskFactory = taskFactory;
		self.dispatchQueue = dispatch_queue_create(object_getClassName(self), DISPATCH_QUEUE_SERIAL);
		self.taskExecutor = [BFExecutor executorWithDispatchQueue:self.dispatchQueue];
	}

	return self;

}

-(void)sync {
//	[self.contentResolver queryWithURL:[Realm URI]
//						withProjection:nil
//						 withSelection:nil
//					 withSelectionArgs:nil
//						   withGroupBy:nil
//							withHaving:nil
//							  withSort:nil];

	dispatch_async(self.dispatchQueue, ^{
		[[[self.contentResolver updateWithURL:[Realm URI]
								withSelection:nil
							withSelectionArgs:nil]
				continueWithBlock:^id(BFTask *task) {
					DDLogInfo(@"Updated %@ realms", task.result);
					return [self.contentResolver queryWithURL:[Champion URI]
											   withProjection:nil
												withSelection:nil
											withSelectionArgs:nil
												  withGroupBy:nil
												   withHaving:nil
													 withSort:nil];
				}]
				continueWithBlock:^id(BFTask *task) {
					if ( task.error ) {
						DDLogError(@"BOOM!!!! %d", task.error.code);
					}
 					return nil;
				}];
	});


}

@end