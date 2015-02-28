//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NO_MATCH			-1

#define ALPHA_WILDCARD		@"*"
#define NUMERIC_WILDCARD	@"#"

@interface NIOUriMatcher : NSObject
-(instancetype)initWith:(NSInteger)root;
-(BOOL)addURI:(NSURL *)uri withMatchCode:(NSInteger)code;
-(NSInteger)match:(NSURL *)url;
@end