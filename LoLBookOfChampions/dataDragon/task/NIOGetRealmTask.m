//
// NIOGetRealmTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "AFHTTPRequestOperation.h"
#import <Bolts/BFTask.h>
#import <Bolts/BFTaskCompletionSource.h>
#import "NIOGetRealmTask.h"
#import "LoLApiConstants.h"
#import "NIOLoLApiRequestOperationManager.h"

#define GET_REALM_PATH_FORMAT	@"/api/lol/static-data/%@/%@/realm"

@interface NIOGetRealmTask ()
@property (strong, nonatomic) NIOLoLApiRequestOperationManager *apiRequestOperationManager;
@end

@implementation NIOGetRealmTask
-(instancetype)initWithHTTPRequestOperationManager:(NIOLoLApiRequestOperationManager *)apiRequestOperationManager {
	self = [super init];
	if ( self ) {
		self.apiRequestOperationManager = apiRequestOperationManager;
	}

	return self;
}

-(BFTask *)run {

	BFTaskCompletionSource *promise = [BFTaskCompletionSource taskCompletionSource];

	[self.apiRequestOperationManager GET:[NSString stringWithFormat:GET_REALM_PATH_FORMAT, PLACEHOLDER_REGION, PLACEHOLDER_API_VERSION]
							  parameters:nil
								 success:^(NSURLSessionDataTask *sessionDataTask, id responseObject) {
									 [promise setResult:responseObject];
								 }
								 failure:^(NSURLSessionDataTask *sessionDataTask, NSError *error) {
									 [promise setError:error];
								 }];

	return promise.task;
}

@end