//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>
#import <UIKit/UIKit.h>
#import "NIOCoreComponents.h"

@class NIODataDragonComponents;
@class AppDelegate;
@class NIOChampionCollectionViewController;
@class NIOCoreComponents;
@protocol NIOContentProvider;
@class NIOChampionSkinCollectionViewController;

@interface NIOApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) NIOCoreComponents *coreComponents;
@property (nonatomic, strong, readonly) NIODataDragonComponents *dataDragonComponents;

-(AppDelegate *)appDelegate;
-(NIOChampionCollectionViewController *)championViewController;
-(NIOChampionSkinCollectionViewController *)championSkinViewController;
-(UIWindow *)mainWindow;

@end