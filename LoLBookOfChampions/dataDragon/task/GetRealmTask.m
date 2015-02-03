//
// GetRealmTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "AFHTTPRequestOperation.h"
#import <Bolts/BFTask.h>
#import <Bolts/BFTaskCompletionSource.h>
#import "GetRealmTask.h"
#import "LoLApiConstants.h"
#import "NIOLoLApiRequestOperationManager.h"

#define GET_REALM_PATH_FORMAT	@"/api/lol/static-data/%@/%@/realm"

@interface GetRealmTask ()
@property (strong, nonatomic) NIOLoLApiRequestOperationManager *apiRequestOperationManager;
@end

@implementation GetRealmTask
-(instancetype)initWithHTTPRequestOperationManager:(NIOLoLApiRequestOperationManager *)apiRequestOperationManager {
	self = [super init];
	if ( self ) {
		self.apiRequestOperationManager = apiRequestOperationManager;
	}

	return self;
}

-(BFTask *)runAsync {

	BFTaskCompletionSource *future = [BFTaskCompletionSource taskCompletionSource];

	[self.apiRequestOperationManager GET:[NSString stringWithFormat:GET_REALM_PATH_FORMAT, PLACEHOLDER_REGION, PLACEHOLDER_API_VERSION]
							  parameters:nil
								 success:^(NSURLSessionDataTask *sessionDataTask, id responseObject) {
									 [future setResult:responseObject];
								 }
								 failure:^(NSURLSessionDataTask *sessionDataTask, NSError *error) {
									 [future setError:error];
								 }];

	return future.task;
}

@end