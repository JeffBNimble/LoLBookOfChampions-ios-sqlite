//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"

@class NIOContentResolver;


@interface NIOClearLocalDataDragonDataTask : NSObject<NIOTask>
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver withSharedURLCache:(NSURLCache *)urlCache;
@end