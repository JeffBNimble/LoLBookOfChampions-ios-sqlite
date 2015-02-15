//
// NIOGetChampionStaticDataTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOGetChampionStaticDataTask.h"
#import "NIOLoLApiRequestOperationManager.h"
#import "LoLApiConstants.h"

#define GET_CHAMPION_PATH_FORMAT	@"/api/lol/static-data/%@/%@/champion"

@interface NIOGetChampionStaticDataTask ()
@property (strong, nonatomic) NIOLoLApiRequestOperationManager *apiRequestOperationManager;
@end

@implementation NIOGetChampionStaticDataTask
-(instancetype)initWithHTTPRequestOperationManager:(NIOLoLApiRequestOperationManager *)apiRequestOperationManager {
	self = [super init];
	if ( self ) {
		self.apiRequestOperationManager = apiRequestOperationManager;
	}

	return self;
}

-(BFTask *)runAsync {
	BFTaskCompletionSource *promise = [BFTaskCompletionSource taskCompletionSource];

	[self.apiRequestOperationManager GET:[NSString stringWithFormat:GET_CHAMPION_PATH_FORMAT, PLACEHOLDER_REGION, PLACEHOLDER_API_VERSION]
							  parameters:@{@"champData":@"blurb,image,skins"}
								 success:^(NSURLSessionDataTask *sessionDataTask, id responseObject) {
									 [promise setResult:responseObject];
								 }
								 failure:^(NSURLSessionDataTask *sessionDataTask, NSError *error) {
									 [promise setError:error];
								 }];

	return promise.task;
}

@end