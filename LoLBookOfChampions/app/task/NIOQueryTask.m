//
// NIOQueryTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/21/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOQueryTask.h"
#import "NIOContentResolver.h"

@interface NIOQueryTask ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@end

@implementation NIOQueryTask

-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
	}

	return self;
}

-(BFTask *)runAsync {
	return [self.contentResolver queryWithURI:self.uri
							   withProjection:self.projection
								withSelection:self.selection
							withSelectionArgs:self.selectionArgs
								  withGroupBy:self.groupBy
								   withHaving:self.having
									 withSort:self.sort	];
}

@end