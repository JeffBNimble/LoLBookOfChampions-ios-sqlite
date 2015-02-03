//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NO_MATCH	-1

@interface NIOUriMatcher : NSObject
-(instancetype)initWith:(NSInteger)root;
-(NSInteger)match:(NSURL *)url;
@end