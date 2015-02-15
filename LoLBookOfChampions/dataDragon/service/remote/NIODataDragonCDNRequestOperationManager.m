//
// NIODataDragonCDNRequestOperationManager / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODataDragonCDNRequestOperationManager.h"


@implementation NIODataDragonCDNRequestOperationManager
-(instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
			   completionQueue:(dispatch_queue_t)completionQueue {
	self = [super initWithSessionConfiguration:sessionConfiguration];
	if ( self ) {
		self.completionQueue = completionQueue;
	}

	return self;
}
@end