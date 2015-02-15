//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"
#import <AFNetworking/AFHTTPSessionManager.h>



@interface NIOCacheChampionImagesTask : NSObject<NIOTask>
@property (strong, nonatomic) NSArray *cacheableImageURLs;

-(instancetype)initWithRequestOperationManager:(AFHTTPSessionManager *)httpSessionManager;
@end