//
// NIOBaseContentProvider / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/11/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOBaseContentProvider.h"
#import "NIOContentResolver.h"
#import "NIOTaskFactory.h"

@implementation NIOBaseContentProvider
-(instancetype)init {
	self = [super init];
	if ( self ) {
	}

	return self;
}

-(NSInteger)deleteWithURI:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error {
	return 0;
}

-(NSURL *)insertWithURI:(NSURL *)uri
			 withValues:(NSDictionary *)values
			  withError:(NSError **)error {
	return nil;
}

-(void)onCreate {

}

-(id<NIOCursor>)queryWithURI:(NSURL *)uri
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort
				   withError:(NSError **)error {
	return nil;
}

-(NSInteger)updateWithURI:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error {
	return 0;
}

@end