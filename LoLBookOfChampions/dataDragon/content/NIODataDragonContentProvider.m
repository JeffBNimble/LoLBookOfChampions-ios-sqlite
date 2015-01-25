//
// NIODataDragonContentProvider / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODataDragonContentProvider.h"

@interface NIODataDragonContentProvider ()
@property (strong, nonatomic) FMDatabase *database;
@end

@implementation NIODataDragonContentProvider
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super init];
	if ( self ) {
		self.database = database;
	}

	return self;
}

-(NSInteger)deleteWithUri:(NSURL *)uri withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return 0;
}

-(NSURL *)insertWithUri:(NSURL *)uri withValues:(NSDictionary *)values {
	return nil;
}

-(FMResultSet *)queryWithUri:(NSURL *)uri
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort {
	return nil;
}

-(NSInteger)updateWithUri:(NSURL *)uri withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return 0;
}

@end