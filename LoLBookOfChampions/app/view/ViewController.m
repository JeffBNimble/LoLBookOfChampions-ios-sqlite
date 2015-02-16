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
#import "NIOContentResolver.h"
#import "NIOGetChampionStaticDataTask.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.activityIndicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
