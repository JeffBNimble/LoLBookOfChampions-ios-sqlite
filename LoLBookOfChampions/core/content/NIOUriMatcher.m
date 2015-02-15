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
	NSMutableArray *allComponents = [@[scheme, host] mutableCopy];
	[allComponents addObjectsFromArray:pathComponents];

	NSMutableDictionary *node = self.matchTree;
	for ( NSString *urlComponent in allComponents ) {
        if ( [urlComponent isEqualToString:@"/"] ) continue;
		node = [self appendURLComponent:urlComponent withNode:node];
	}

	if ( node ) {
        node[@""] = @(code);
	}
}

-(NSMutableDictionary *)appendURLComponent:(NSString *)urlComponent withNode:(NSMutableDictionary *)node {
    NSMutableDictionary *childNode = node[urlComponent];
    if ( !childNode ) {
        childNode = [NSMutableDictionary new];
        node[urlComponent] = childNode;
    }
    return childNode;
}

- (NSMutableDictionary *)getMatchingNode:(NSString *)urlComponent withNode:(NSDictionary *)node {
    NSMutableDictionary *matchingNode =  (NSMutableDictionary *)node[urlComponent];
    if ( matchingNode ) return matchingNode;

    return node[@"*"];
}

- (NSInteger)match:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    NSString *scheme = urlComponents.scheme;
    NSString *host = urlComponents.host;
    NSString *path = urlComponents.path;
    NSArray *pathComponents = path ? [path pathComponents] : @[];
    NSMutableArray *allComponents = [@[scheme, host] mutableCopy];
    [allComponents addObjectsFromArray:pathComponents];

    NSDictionary *node = self.matchTree;

    for ( NSString *urlComponent in allComponents ) {
        if ( [urlComponent isEqualToString:@"/"] ) continue;
        node = [self getMatchingNode:urlComponent withNode:node];
    }

    return node ? [(NSNumber *) node[@""] integerValue] : NO_MATCH;
}


@end