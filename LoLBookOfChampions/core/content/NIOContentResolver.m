//
// NIOContentResolver / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/3/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOContentResolver.h"

@interface NIOContentResolver()
@property (strong, nonatomic) NSMutableDictionary *activeContentProviderRegistry;
@property (strong, nonatomic) NSString *contentAuthorityBase;
@property (strong, nonatomic) NSDictionary *contentRegistrations;
@end

@implementation NIOContentResolver
- (instancetype)initWithContentAuthorityBase:(NSString *)contentAuthorityBase withRegistrations:(NSDictionary *)registrations {
    self = [super init];
    if ( self ) {
        self.contentAuthorityBase = contentAuthorityBase;
        self.contentRegistrations = registrations;
        self.activeContentProviderRegistry = [NSMutableDictionary new];
        [self initialize];
    }

    return self;
}

-(void)initialize {
    [self initializeRegistrations];
}

-(void)initializeRegistrations {
    for ( NSString *contentProviderContentBase in self.contentRegistrations.allKeys ) {
        NSString *newKey = [NSString stringWithFormat:@"content://%@/%@", self.contentAuthorityBase, contentProviderContentBase];
        [self.activeContentProviderRegistry setObject:[NSNull null] forKey:newKey];
    }
}

@end