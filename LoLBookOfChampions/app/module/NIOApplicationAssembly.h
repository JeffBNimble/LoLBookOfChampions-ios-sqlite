//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>

@class NIOCoreComponents;
@class AppDelegate;


@interface NIOApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) NIOCoreComponents *coreComponents;

-(AppDelegate *)appDelegate;
@end