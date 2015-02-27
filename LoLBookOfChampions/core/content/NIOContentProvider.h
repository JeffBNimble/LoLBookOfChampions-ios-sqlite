//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <Foundation/Foundation.h>

@protocol NIOCursor;

@protocol NIOContentProvider <NSObject>

-(NSInteger)deleteWithURI:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error;

-(NSURL *)insertWithURI:(NSURL *)uri
			 withValues:(NSDictionary *)values
			  withError:(NSError **)error;

-(id<NIOCursor>)queryWithURI:(NSURL *)uri
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort
				   withError:(NSError **)error;

-(NSInteger)updateWithURI:(NSURL *)uri
               withValues:(NSDictionary *)values
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs
				withError:(NSError **)error;
@end