//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import <Foundation/Foundation.h>


@interface NIOLoLApiRequestOperationManager : AFHTTPSessionManager
-(instancetype)initWithBaseURL:(NSURL *)baseUrl
		  sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
			   completionQueue:(dispatch_queue_t)completionQueue
						apiKey:(NSString *)apiKey
						region:(NSString *)region
					apiVersion:(NSString *)apiVersion;

@end