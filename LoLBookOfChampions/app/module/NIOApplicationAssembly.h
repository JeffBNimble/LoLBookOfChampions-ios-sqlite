//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>
#import <UIKit/UIKit.h>

@class NIODataDragonComponents;
@class AppDelegate;
@class ViewController;
@class NIOCoreComponents;


@interface NIOApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) NIOCoreComponents *coreComponents;
@property (nonatomic, strong, readonly) NIODataDragonComponents *dataDragonComponents;

-(AppDelegate *)appDelegate;
-(UIWindow *)mainWindow;
-(ViewController *)viewController;

@end