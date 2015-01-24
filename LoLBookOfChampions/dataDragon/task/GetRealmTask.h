//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@class NIOLoLApiRequestOperationManager;


@interface GetRealmTask : NSObject
-(instancetype)initWithHTTPRequestOperationManager:(NIOLoLApiRequestOperationManager *)apiRequestOperationManager;
-(BFTask *)runAsync;
@end