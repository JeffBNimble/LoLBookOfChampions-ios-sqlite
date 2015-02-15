//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>


@interface NIODataDragonCDNRequestOperationManager : AFHTTPSessionManager
-(instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
							completionQueue:(dispatch_queue_t)completionQueue;
@end