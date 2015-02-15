//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"

@class NIOLoLApiRequestOperationManager;


@interface NIOGetChampionStaticDataTask : NSObject<NIOTask>
-(instancetype)initWithHTTPRequestOperationManager:(NIOLoLApiRequestOperationManager *)apiRequestOperationManager;
@end