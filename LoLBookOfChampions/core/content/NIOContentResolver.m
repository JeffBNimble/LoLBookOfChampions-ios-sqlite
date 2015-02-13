//
// NIOContentResolver / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/3/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOContentResolver.h"
#import "NIOBaseContentProvider.h"
#import "NIOCoreComponents.h"

#define CONTENT_AUTHORITY(REGISTRATION_PATH)	[NSString stringWithFormat:@"content://%@.%@", self.contentAuthorityBase, REGISTRATION_PATH]

@interface NIOContentResolver()
@property (strong, nonatomic) NSMutableDictionary *activeContentProviderRegistry;
@property (strong, nonatomic) NSString *contentAuthorityBase;
@property (strong, nonatomic) id<NIOContentProviderFactory> contentProviderFactory;
@property (strong, nonatomic) NSDictionary *contentRegistrations;
@end

@implementation NIOContentResolver
- (instancetype)initWithContentProviderFactory:(id<NIOContentProviderFactory>)factory
					  withContentAuthorityBase:(NSString *)contentAuthorityBase
							 withRegistrations:(NSDictionary *)registrations {
    self = [super init];
    if ( self ) {
		self.contentProviderFactory = factory;
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
	// Replace the registrations by generating absolute content URL strings
	NSMutableDictionary *newRegistrations = [NSMutableDictionary new];
    for ( NSString *registrationPath in self.contentRegistrations.allKeys ) {
        NSString *newKey = CONTENT_AUTHORITY(registrationPath);
        newRegistrations[newKey] = self.contentRegistrations[registrationPath];
    }

	self.contentRegistrations = newRegistrations;
}

-(id <NIOContentProvider>)getContentProviderForContentURL:(NSURL *)contentURL {
	NSString *contentAuthority = [self getContentAuthorityForContentURL:contentURL];
	id<NIOContentProvider> activeContentProvider = self.activeContentProviderRegistry[contentAuthority];
	if ( activeContentProvider == nil ) {
		NSString *className = self.contentRegistrations[contentAuthority];
		Class contentProviderClass = className ? NSClassFromString(className) : nil;
		activeContentProvider = contentProviderClass ? [self.contentProviderFactory createContentProviderWithType:contentProviderClass] : nil;
		if ( activeContentProvider ) {
			((NIOBaseContentProvider *)activeContentProvider).contentResolver = self;
			[((NIOBaseContentProvider *) activeContentProvider) onCreate];
			self.activeContentProviderRegistry[contentAuthority] = activeContentProvider;
		}
	}

	return activeContentProvider;
}

-(NSString *)getContentAuthorityForContentURL:(NSURL *)contentURL {
	__weak __block NSString *contentURLString = [contentURL absoluteString];
	NSArray *registrationURLs = [self.contentRegistrations allKeys];
	NSIndexSet *indexSet = [registrationURLs indexesOfObjectsPassingTest:^BOOL(NSString *urlString, NSUInteger idx, BOOL *stop) {
		if ( [contentURLString hasPrefix:urlString] ) {
			*stop = YES;
			return YES;
		}

		return NO;
	}];

	return indexSet.count > 0 ? registrationURLs[indexSet.firstIndex] : nil;
}

-(void)notifyChange:(NSURL *)contentUrl {

}

-(void)registerContentObserverWithContentURL:(NSURL *)contentUrl
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id <NIOContentObserver>)contentObserver {

}

-(void)unregisterContentObserver:(id <NIOContentObserver>)contentObserver {

}

-(NSInteger)deleteWithURL:(NSURL *)url withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return [[self getContentProviderForContentURL:url]
			deleteWithURL:url
			withSelection:selection
		withSelectionArgs:selectionArgs];
}

-(NSURL *)insertWithURL:(NSURL *)url withValues:(NSDictionary *)values {
	return [[self getContentProviderForContentURL:url]
			insertWithURL:url
			   withValues:values];
}

-(FMResultSet *)queryWithURL:(NSURL *)url
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort {
	return [[self getContentProviderForContentURL:url]
			queryWithURL:url
		  withProjection:projection
		   withSelection:selection
	   withSelectionArgs:selectionArgs
			 withGroupBy:groupBy
			  withHaving:having
				withSort:sort];
}

-(NSInteger)updateWithURL:(NSURL *)url withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return [[self getContentProviderForContentURL:url]
			updateWithURL:url
			withSelection:selection
		withSelectionArgs:selectionArgs];
}


@end