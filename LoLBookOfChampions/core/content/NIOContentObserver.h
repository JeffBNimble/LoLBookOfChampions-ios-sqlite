//
// Created by Jeff Roberts on 2/3/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NIOContentObserver <NSObject>
-(void)onUpdate:(NSURL *)contentUri;
@end