//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <FMDB/FMDB.h>
#import <Foundation/Foundation.h>

@protocol ContentProvider <NSObject>
-(NSInteger)deleteWithUri:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs;
-(NSURL *)insertWithUri:(NSURL *)uri
			  withValues:(NSDictionary *)values;
-(FMResultSet *)queryWithUri:(NSURL *)uri
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort;
-(NSInteger)updateWithUri:(NSURL *)uri
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs;
@end