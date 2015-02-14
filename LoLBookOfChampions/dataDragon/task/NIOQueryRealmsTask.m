//
// NIOQueryRealmsTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/13/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryRealmsTask.h"

@interface NIOQueryRealmsTask ()
@property (strong, nonatomic) FMDatabase *database;
@end

@implementation NIOQueryRealmsTask
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super init];
	if ( self ) {
		self.database = database;
	}

	return self;
}

-(BFTask *)runAsync {
	FMResultSet *resultSet = [self.database executeQuery:@"select count(*) as row_count from realm"];
	return [BFTask taskWithResult:resultSet];
}

@end