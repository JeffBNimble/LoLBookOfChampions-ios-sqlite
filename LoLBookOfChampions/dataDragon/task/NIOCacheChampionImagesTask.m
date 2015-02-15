//
// NIOCacheChampionImagesTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOCacheChampionImagesTask.h"
#import <AFNetworking/AFNetworking.h>

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
	NSMutableArray *tasks = [[NSMutableArray alloc] initWithCapacity:self.cacheableImageURLs.count];

	int requestCount = 0;
	for ( NSString *urlString in self.cacheableImageURLs ) {
		requestCount++;
		if ( requestCount % 400 == 0) {
			[NSThread sleepForTimeInterval:5];
		}
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
	};

	return [BFTask taskForCompletionOfAllTasks:tasks];
}

@end