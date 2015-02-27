//
// NIOMockContentObserver / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/27/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOMockContentObserver.h"


@implementation NIOMockContentObserver
-(void)onUpdate:(NSURL *)contentUri {
	self.completionQueue = dispatch_get_current_queue();
	self.didReceiveUriUpdateNotification = true;
}

@end