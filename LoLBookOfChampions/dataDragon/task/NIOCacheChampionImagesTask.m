//
// NIOCacheChampionImagesTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOCacheChampionImagesTask.h"
#import <AFNetworking/AFNetworking.h>

#define IMAGES_PER_BATCH		25

@interface NIOCacheChampionImagesTask ()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation NIOCacheChampionImagesTask
-(instancetype)initWithRequestOperationManager:(AFHTTPSessionManager *)httpSessionManager {
	self = [super init];
	if ( self ) {
		self.sessionManager = httpSessionManager;
		httpSessionManager.responseSerializer = [AFImageResponseSerializer serializer];
	}

	return self;
}

-(BFTask *)runAsync {
	DDLogVerbose(@"Caching %d champion, loading and splash images", self.cacheableImageURLs.count);
	BFTask *promise;
	NSMutableArray *tasks = [[NSMutableArray alloc] initWithCapacity:IMAGES_PER_BATCH];
	int batchCount = (int) self.cacheableImageURLs.count / IMAGES_PER_BATCH;
	batchCount = batchCount % IMAGES_PER_BATCH > 0 ? batchCount + 1 : batchCount;
	int cachedCountThisBatch = 0, cachedCountTotal = 0;

	for ( NSString *urlString in self.cacheableImageURLs ) {
		DDLogVerbose(@"Caching image for %@", urlString);
		__block BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
		BFTask *cacheTask = completionSource.task;
		[tasks addObject:cacheTask];
		[self.sessionManager GET:urlString
					  parameters:nil
						 success:^(NSURLSessionDataTask *task, id responseObject) {
							 [completionSource setResult:nil];
						 }
						 failure:^(NSURLSessionDataTask *task, NSError *error) {
							[completionSource setError:error];
						 }];
		cachedCountThisBatch++;
		cachedCountTotal++;

		if ( cachedCountThisBatch == IMAGES_PER_BATCH || cachedCountTotal == self.cacheableImageURLs.count ) {
			promise = [BFTask taskForCompletionOfAllTasks:tasks];
			[promise waitUntilFinished];
			[tasks removeAllObjects];
			batchCount++;
			cachedCountThisBatch = 0;
		}

	};
	DDLogVerbose(@"Cached %d champion, loading and splash images", cachedCountTotal);

	return promise;
}

@end