//
// Created by Jeff Roberts on 2/21/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOTask.h"

@class NIOContentResolver;


@interface NIOQueryTask : NSObject<NIOTask>
@property (strong, nonatomic) NSString *groupBy;
@property (strong, nonatomic) NSString *having;
@property (strong, nonatomic) NSArray *projection;
@property (strong, nonatomic) NSString *selection;
@property (strong, nonatomic) NSArray *selectionArgs;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSURL *uri;

-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver;
@end