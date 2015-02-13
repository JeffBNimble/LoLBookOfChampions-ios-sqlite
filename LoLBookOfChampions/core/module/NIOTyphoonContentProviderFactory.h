//
// Created by Jeff Roberts on 2/13/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOBaseComponentFactory.h"


@interface NIOTyphoonContentProviderFactory : NIOBaseComponentFactory <NIOContentProviderFactory>
- (instancetype)initWithFactory:(TyphoonComponentFactory *)factory NS_DESIGNATED_INITIALIZER;
@end