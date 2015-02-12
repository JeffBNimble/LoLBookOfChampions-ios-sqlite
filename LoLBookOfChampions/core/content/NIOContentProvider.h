//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <FMDB/FMDB.h>
#import <Foundation/Foundation.h>

@protocol NIOContentProvider <NSObject>
-(NSInteger)deleteWithURL:(NSURL *)url
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs;
-(NSURL *)insertWithURL:(NSURL *)url
			  withValues:(NSDictionary *)values;
-(FMResultSet *)queryWithURL:(NSURL *)url
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort;
-(NSInteger)updateWithURL:(NSURL *)url
			withSelection:(NSString *)selection
		withSelectionArgs:(NSArray *)selectionArgs;
@end