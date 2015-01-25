//
//  AppDelegate.h
//  LoLBookOfChampions
//
//  Created by Jeff Roberts on 1/19/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIODataDragonSyncService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NIODataDragonSyncService *dataDragonSyncService;


@end

