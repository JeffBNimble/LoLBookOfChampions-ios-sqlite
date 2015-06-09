//
// Created by Jeff Roberts on 2/13/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>


@protocol NIOTask <NSObject>
-(BFTask *)run;
@end