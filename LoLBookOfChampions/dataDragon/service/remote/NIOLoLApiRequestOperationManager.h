//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <Foundation/Foundation.h>


@interface NIOLoLApiRequestOperationManager : AFHTTPRequestOperationManager
-(instancetype)initWithBaseURL:(NSURL *)baseUrl
						apiKey:(NSString *)apiKey
						region:(NSString *)region
					apiVersion:(NSString *)apiVersion;

@end