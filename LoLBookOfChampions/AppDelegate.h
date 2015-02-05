//
//  AppDelegate.h
//  LoLBookOfChampions
//
//  Created by Jeff Roberts on 1/19/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIODataDragonSyncService;
@class NIOContentResolver;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) NIOContentResolver *contentResolver;
@property (strong, nonatomic) NIODataDragonSyncService *dataDragonSyncService;
@property (strong, nonatomic) NSNotificationCenter *notificationCenter;
@property (strong, nonatomic) UIWindow *window;


@end

