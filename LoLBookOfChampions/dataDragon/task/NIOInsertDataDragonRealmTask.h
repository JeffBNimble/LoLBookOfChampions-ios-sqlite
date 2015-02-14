//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"

@class NIOContentResolver;


@interface NIOInsertDataDragonRealmTask : NSObject<NIOTask>
@property (strong, nonatomic) NSDictionary *remoteDataDragonRealmData;

-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver;
@end