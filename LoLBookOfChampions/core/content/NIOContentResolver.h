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
							withRegistrations:(NSDictionary *)registrations
						   withExecutionQueue:(dispatch_queue_t)executionQueue
						  withCompletionQueue:(dispatch_queue_t)completionQueue NS_DESIGNATED_INITIALIZER;

-(BFTask *)deleteWithURI:(NSURL *)uri
		   withSelection:(NSString *)selection
	   withSelectionArgs:(NSArray *)selectionArgs;

-(id <NIOContentProvider>)getContentProviderForContentURI:(NSURL *)contentURI;

-(BFTask *)insertWithURI:(NSURL *)uri
			  withValues:(NSDictionary *)values;

-(void)notifyChange:(NSURL *)contentUri;

-(BFTask *)queryWithURI:(NSURL *)uri
		 withProjection:(NSArray *)projection
		  withSelection:(NSString *)selection
	  withSelectionArgs:(NSArray *)selectionArgs
			withGroupBy:(NSString *)groupBy
			 withHaving:(NSString *)having
			   withSort:(NSString *)sort;

-(void)registerContentObserverWithContentURI:(NSURL *)contentUri
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id <NIOContentObserver>)contentObserver;

-(void)unregisterContentObserver:(id <NIOContentObserver>)contentObserver;

-(BFTask *)updateWithURI:(NSURL *)uri
              withValues:(NSDictionary *)values
		   withSelection:(NSString *)selection
	   withSelectionArgs:(NSArray *)selectionArgs;
@end