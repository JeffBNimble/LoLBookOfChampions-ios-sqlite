//
// NIOBaseSQLTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOBaseSQLTask.h"

@interface NIOBaseSQLTask ()
@property (strong, nonatomic) FMDatabase *database;
@end

@implementation NIOBaseSQLTask
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super init];
	if ( self ) {
		self.database = database;
	}

	return self;
}

@end