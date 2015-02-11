//
// NIOBaseContentProvider / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/11/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOBaseContentProvider.h"
#import "NIOContentResolver.h"

@interface NIOBaseContentProvider ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@end

@implementation NIOBaseContentProvider
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
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