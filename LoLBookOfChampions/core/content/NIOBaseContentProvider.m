//
// NIOBaseContentProvider / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/11/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOBaseContentProvider.h"
#import "NIOContentResolver.h"

@implementation NIOBaseContentProvider
-(instancetype)init {
	self = [super init];
	if ( self ) {
	}

	return self;
}

-(NSInteger)deleteWithURL:(NSURL *)url withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return 0;
}

-(NSURL *)insertWithURL:(NSURL *)url withValues:(NSDictionary *)values {
	return nil;
}

-(void)onCreate {

}

-(FMResultSet *)queryWithURL:(NSURL *)url
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort {
	return nil;
}

-(NSInteger)updateWithURL:(NSURL *)url withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return 0;
}

@end