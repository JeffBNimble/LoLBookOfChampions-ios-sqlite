//
// NIOMockContentProvider / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/26/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOMockContentProvider.h"


@implementation NIOMockContentProvider
-(NSInteger)deleteWithURI:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error {
	self.executionQueue = dispatch_get_current_queue();
	if ( self.failWithError ) {
		*error = self.failWithError;
		return 0;
	} else {
		return [super deleteWithURI:uri withSelection:selection withSelectionArgs:selectionArgs withError:error];
	}
}

-(NSURL *)insertWithURI:(NSURL *)uri withValues:(NSDictionary *)values withError:(NSError **)error {
	self.executionQueue = dispatch_get_current_queue();
	if ( self.failWithError ) {
		*error = self.failWithError;
		return nil;
	} else {
		return [super insertWithURI:uri withValues:values withError:error];
	}
}

-(id <NIOCursor>)queryWithURI:(NSURL *)uri
			   withProjection:(NSArray *)projection
				withSelection:(NSString *)selection
			withSelectionArgs:(NSArray *)selectionArgs
				  withGroupBy:(NSString *)groupBy
				   withHaving:(NSString *)having
					 withSort:(NSString *)sort
					withError:(NSError **)error {
	self.executionQueue = dispatch_get_current_queue();
	if ( self.failWithError ) {
		*error = self.failWithError;
		return nil;
	} else {
		return [super queryWithURI:uri
					withProjection:projection
					 withSelection:selection
				 withSelectionArgs:selectionArgs
					   withGroupBy:groupBy
						withHaving:having
						  withSort:sort
						 withError:error];
	}
}

-(NSInteger)updateWithURI:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error {
	self.executionQueue = dispatch_get_current_queue();
	if ( self.failWithError ) {
		*error = self.failWithError;
		return 0;
	} else {
		return [super updateWithURI:uri withSelection:selection withSelectionArgs:selectionArgs withError:error];
	}
}

@end