//
// Created by Jeff Roberts on 2/3/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentProvider.h"

@protocol NIOContentObserver;
@protocol NIOContentProviderFactory;


@interface NIOContentResolver : NSObject
-(instancetype)initWithContentProviderFactory:(id <NIOContentProviderFactory>)factory
					 withContentAuthorityBase:(NSString *)contentAuthorityBase
							withRegistrations:(NSDictionary *)registrations NS_DESIGNATED_INITIALIZER;

-(NSInteger)deleteWithURI:(NSURL *)uri
            withSelection:(NSString *)selection
        withSelectionArgs:(NSArray *)selectionArgs
                withError:(NSError **)error;

-(id <NIOContentProvider>)getContentProviderForContentURI:(NSURL *)contentURI;

-(NSURL *)insertWithURI:(NSURL *)uri
             withValues:(NSDictionary *)values
              withError:(NSError **)error;

-(void)notifyChange:(NSURL *)contentUri;

-(id<NIOCursor>)queryWithURI:(NSURL *)uri
              withProjection:(NSArray *)projection
               withSelection:(NSString *)selection
           withSelectionArgs:(NSArray *)selectionArgs
                 withGroupBy:(NSString *)groupBy
                  withHaving:(NSString *)having
                    withSort:(NSString *)sort
                   withError:(NSError **)error;

-(void)registerContentObserverWithContentURI:(NSURL *)contentUri
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id <NIOContentObserver>)contentObserver;

-(void)unregisterContentObserver:(id <NIOContentObserver>)contentObserver;

-(NSInteger)updateWithURI:(NSURL *)uri
               withValues:(NSDictionary *)values
            withSelection:(NSString *)selection
        withSelectionArgs:(NSArray *)selectionArgs
                withError:(NSError **)error;
@end