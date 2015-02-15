//
//  ViewController.h
//  LoLBookOfChampions
//
//  Created by Jeff Roberts on 1/19/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIOGetChampionStaticDataTask;

@interface ViewController : UIViewController
@property (strong, nonatomic) NIOGetChampionStaticDataTask *getChampionStaticDataTask;

@end

