//
// Created by Jeff Roberts on 2/11/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentProvider.h"

@class NIOContentResolver;

@interface NIOBaseContentProvider : NSObject<NIOContentProvider>
@property (strong, nonatomic) NIOContentResolver *contentResolver;

-(instancetype)init NS_DESIGNATED_INITIALIZER;
-(void)onCreate;
@end