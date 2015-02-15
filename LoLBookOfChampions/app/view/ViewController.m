//
//  ViewController.m
//  LoLBookOfChampions
//
//  Created by Jeff Roberts on 1/19/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Bolts/BFTask.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "NIOGetRealmTask.h"
#import "ViewController.h"
#import "NIOGetChampionStaticDataTask.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[self.getChampionStaticDataTask runAsync] continueWithBlock:^id(BFTask *task) {
        if ( task.error ) {
            DDLogError(@"An error occurred: %@", task.error.description);
        } else {
            DDLogVerbose(@"%@", task.result);
        }

        return nil;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
