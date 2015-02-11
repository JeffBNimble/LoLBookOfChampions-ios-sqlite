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
        self.activeContentProviderRegistry[newKey] = [NSNull null];
    }
}

-(id <NIOContentProvider>)getContentProviderForAuthorityURL:(NSURL *)authorityUrl {
	return nil;
}

-(void)notifyChange:(NSURL *)contentUrl {

}

-(void)registerContentObserverWithContentURL:(NSURL *)contentUrl
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id <NIOContentObserver>)contentObserver {

}

-(void)registerContentProviderWithAuthorityURL:(NSURL *)authorityUrl
						   withContentProvider:(id <NIOContentProvider>)contentProvider {

}

-(void)unregisterContentObserver:(id <NIOContentObserver>)contentObserver {

}

-(void)unregisterContentProvider:(id <NIOContentProvider>)contentProvider {

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