//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"

@class BFTask;
@class NIOLoLApiRequestOperationManager;


@interface GetRealmTask : NSObject<NIOTask>
-(instancetype)initWithHTTPRequestOperationManager:(NIOLoLApiRequestOperationManager *)apiRequestOperationManager;
@end