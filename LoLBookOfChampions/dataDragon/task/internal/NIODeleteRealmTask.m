//
// NIODeleteRealmTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <Bolts/Bolts.h>
#import "NIODeleteRealmTask.h"
#import "NIODataDragonContract.h"


@implementation NIODeleteRealmTask
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super initWithDatabase:database];
	if ( self ) {
		self.table = [Realm DB_TABLE];
	}
	return self;
}

-(BFTask *)runAsync {
	return [self asUpdateResult:self.executeDelete];
}


@end