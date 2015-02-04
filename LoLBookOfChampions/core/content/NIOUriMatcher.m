//
// NIOUriMatcher / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOUriMatcher.h"

@interface NIOUriMatcher ()
@property (nonatomic, strong) NSMutableDictionary *matchTree;
@end

@implementation NIOUriMatcher
-(instancetype)initWith:(NSInteger)root {
	self = [super init];
	if ( self ) {
		self.matchTree = [NSMutableDictionary new];
		self.matchTree[@""] = @(root);
	}

	return self;
}

-(void)addURL:(NSURL *)url withMatchCode:(NSInteger)code {
	NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
												resolvingAgainstBaseURL:NO];
	NSString *scheme = urlComponents.scheme;
	NSString *host = urlComponents.host;
	NSString *path = urlComponents.path;
	NSArray *pathComponents = path ? [path pathComponents] : @[];
	NSMutableArray *allComponents = [@[scheme, host, path] mutableCopy];
	[allComponents addObjectsFromArray:pathComponents];

	id node = self.matchTree;
	for ( NSString *urlComponent in allComponents ) {
		node = [self appendURLComponent:(NSString *)urlComponent withNode:node];
	}

	if ( node && [node isMemberOfClass:[NSMutableDictionary class]]) {
		NSMutableDictionary *terminalNode = (NSMutableDictionary *)node;
	}
}

@end