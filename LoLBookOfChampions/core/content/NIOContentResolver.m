//
// NIOContentResolver / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/3/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOContentResolver.h"
#import "NIOBaseContentProvider.h"
#import "NIOContentProviderFactory.h"
#import "NIOContentObserver.h"
#import <Bolts/Bolts.h>

#define CONTENT_AUTHORITY(REGISTRATION_PATH)    [NSString stringWithFormat:@"content://%@.%@", self.contentAuthorityBase, REGISTRATION_PATH]

@interface ContentObserverRegistration : NSObject
@property (strong, nonatomic) id<NIOContentObserver>contentObserver;
@property (strong, nonatomic) NSURL *contentURI;
@property (assign, nonatomic) BOOL notifyForDescendents;

-(instancetype)init;
@end

@implementation ContentObserverRegistration
-(instancetype)init {
	self = [super init];
	if ( self ) {}
	return self;
}

-(BOOL)isEqual:(id)other {
	if ( other == self )
		return YES;
	if ( !other || ![[other class] isEqual:[self class]] )
		return NO;

	ContentObserverRegistration *otherRegistration = (ContentObserverRegistration *)other;
	return [self.contentURI isEqual:otherRegistration.contentURI];
}

@end


@interface NIOContentResolver ()
@property (strong, nonatomic) NSMutableDictionary *activeContentProviderRegistry;
@property (strong, nonatomic) NSString *contentAuthorityBase;
@property (strong, nonatomic) NSMutableDictionary *contentObservers;
@property (strong, nonatomic) id <NIOContentProviderFactory> contentProviderFactory;
@property (strong, nonatomic) NSDictionary *contentRegistrations;
@end

@implementation NIOContentResolver
-(instancetype)initWithContentProviderFactory:(id <NIOContentProviderFactory>)factory
					 withContentAuthorityBase:(NSString *)contentAuthorityBase
							withRegistrations:(NSDictionary *)registrations {
	self = [super init];
	if ( self ) {
		self.contentProviderFactory = factory;
		self.contentAuthorityBase = contentAuthorityBase;
		self.contentRegistrations = registrations;
		self.activeContentProviderRegistry = [NSMutableDictionary new];
		self.contentObservers = [NSMutableDictionary new];
		[self initialize];
	}

	return self;
}

-(NSError *)createNoContentProviderErrorWithUri:(NSURL *)uri {
	NSString *localizedDescription = [NSString stringWithFormat:@"No matching content provider is registered for content uri %@", [uri absoluteString]];
	NSError *error = [NSError errorWithDomain:[uri absoluteString]
										 code:1
									 userInfo:@{NSLocalizedDescriptionKey:localizedDescription}];

	return error;
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

-(id <NIOContentProvider>)getContentProviderForContentURI:(NSURL *)contentURI {
	NSString *contentAuthority = [self getContentAuthorityForContentURI:contentURI];
	id <NIOContentProvider> activeContentProvider = self.activeContentProviderRegistry[contentAuthority];
	if ( activeContentProvider == nil ) {
		NSString *className = self.contentRegistrations[contentAuthority];
		Class contentProviderClass = className ? NSClassFromString(className) : nil;
		activeContentProvider = contentProviderClass ?
								[self.contentProviderFactory createContentProviderWithType:contentProviderClass] :
								nil;
		if ( activeContentProvider ) {
			((NIOBaseContentProvider *) activeContentProvider).contentResolver = self;
			[((NIOBaseContentProvider *) activeContentProvider) onCreate];
			self.activeContentProviderRegistry[contentAuthority] = activeContentProvider;
		}
	}

	return activeContentProvider;
}

-(NSString *)getContentAuthorityForContentURI:(NSURL *)contentURI {
	__weak __block NSString *contentURIString = [contentURI absoluteString];
	NSArray *registrationURIs = [self.contentRegistrations allKeys];
	NSIndexSet *indexSet = [registrationURIs indexesOfObjectsPassingTest:^BOOL(NSString *urlString, NSUInteger idx, BOOL *stop) {
		if ( [contentURIString hasPrefix:urlString] ) {
			*stop = YES;
			return YES;
		}

		return NO;
	}];

	return indexSet.count > 0 ? registrationURIs[indexSet.firstIndex] : nil;
}

-(void)notifyChange:(NSURL *)contentURI {
	NSString *contentURIString = [contentURI absoluteString];
    for ( NSString *key in self.contentObservers.allKeys ) {
        NSArray *registrations = self.contentObservers[key];

        for ( ContentObserverRegistration *registration in registrations ) {
            BOOL shouldNotify = [[registration.contentURI absoluteString] isEqual:contentURIString] ||
                    (registration.notifyForDescendents && [contentURIString hasPrefix:[registration.contentURI absoluteString]]);
            if ( shouldNotify ) {
                [registration.contentObserver onUpdate:contentURI];
            }
        }
    }
}

-(void)registerContentObserverWithContentURI:(NSURL *)contentUri
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id <NIOContentObserver>)contentObserver {
	NSString *key = NSStringFromClass([contentObserver class]);
	NSMutableArray *registrations = self.contentObservers[key];
	if ( !registrations ) {
		registrations = [NSMutableArray new];
		self.contentObservers[key] = registrations;
	}

	ContentObserverRegistration *registration = [ContentObserverRegistration new];
	registration.contentObserver = contentObserver;
	registration.contentURI = contentUri;
	registration.notifyForDescendents = notifyForDescendents;

	if ( ![registrations containsObject:registration] ) {
		[registrations addObject:registration];
	}
}

-(void)unregisterContentObserver:(id <NIOContentObserver>)contentObserver {
	NSString *key = NSStringFromClass([contentObserver class]);
	[self.contentObservers removeObjectForKey:key];
}

-(NSInteger)deleteWithURI:(NSURL *)uri
           withSelection:(NSString *)selection
       withSelectionArgs:(NSArray *)selectionArgs
               withError:(NSError **)error {
	id<NIOContentProvider> contentProvider = [self getContentProviderForContentURI:uri];
    if (!contentProvider) {
        *error = [self createNoContentProviderErrorWithUri:uri];
        return 0;
    }
		
    return [contentProvider deleteWithURI:uri
                            withSelection:selection
                        withSelectionArgs:selectionArgs
                                withError:error];
}

-(NSURL *)insertWithURI:(NSURL *)uri
             withValues:(NSDictionary *)values
              withError:(NSError **)error {
    id<NIOContentProvider> contentProvider = [self getContentProviderForContentURI:uri];
    if (!contentProvider) {
        *error = [self createNoContentProviderErrorWithUri:uri];
        return nil;
    }
    
    return [contentProvider insertWithURI:uri
                               withValues:values
                                withError:error];
}

-(id<NIOCursor>)queryWithURI:(NSURL *)uri
		 withProjection:(NSArray *)projection
		  withSelection:(NSString *)selection
	  withSelectionArgs:(NSArray *)selectionArgs
			withGroupBy:(NSString *)groupBy
			 withHaving:(NSString *)having
			   withSort:(NSString *)sort
              withError:(NSError **)error {

    id<NIOContentProvider> contentProvider = [self getContentProviderForContentURI:uri];
    if (!contentProvider) {
        *error = [self createNoContentProviderErrorWithUri:uri];
        return nil;
    }
    
    return [contentProvider queryWithURI:uri
                          withProjection:projection
                           withSelection:selection
                       withSelectionArgs:selectionArgs
                             withGroupBy:groupBy
                              withHaving:having
                                withSort:sort
                               withError:error];
}

-(NSInteger)updateWithURI:(NSURL *)uri
               withValues:(NSDictionary *)values
            withSelection:(NSString *)selection
        withSelectionArgs:(NSArray *)selectionArgs
                withError:(NSError **)error {
    id<NIOContentProvider> contentProvider = [self getContentProviderForContentURI:uri];
    if (!contentProvider) {
        *error = [self createNoContentProviderErrorWithUri:uri];
        return 0;
    }
        return [contentProvider updateWithURI:uri
                                   withValues:values
                                withSelection:selection
                            withSelectionArgs:selectionArgs
                                    withError:error];
}

@end