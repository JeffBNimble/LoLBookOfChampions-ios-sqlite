//
//  NIOChampionCollectionViewController.h
//  LoLBookOfChampions
//
//  Created by Jeff Roberts on 1/19/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIOContentObserver.h"

@class NIOContentResolver;

@interface NIOChampionCollectionViewController : UIViewController<UICollectionViewDelegate,
		UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NIOContentObserver, UINavigationControllerDelegate>
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@property (strong, nonatomic) UIDevice *currentDevice;
@property (strong, nonatomic) NSBundle *mainBundle;
@end

