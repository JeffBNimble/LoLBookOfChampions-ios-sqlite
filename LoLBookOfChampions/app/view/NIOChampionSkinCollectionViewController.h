//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NIOContentResolver;

@interface NIOChampionSkinCollectionViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>
@property (assign, nonatomic) NSUInteger championId;
@property (strong, nonatomic) NSString *championName;
@property (strong, nonatomic) NSString *championTitle;
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@end