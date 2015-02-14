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

-(BFTask *)deleteWithURL:(NSURL *)url
		   withSelection:(NSString *)selection
	   withSelectionArgs:(NSArray *)selectionArgs;

-(id <NIOContentProvider>)getContentProviderForContentURL:(NSURL *)contentURL;

-(BFTask *)insertWithURL:(NSURL *)url
			  withValues:(NSDictionary *)values;

-(void)notifyChange:(NSURL *)contentUrl;

-(BFTask *)queryWithURL:(NSURL *)url
		 withProjection:(NSArray *)projection
		  withSelection:(NSString *)selection
	  withSelectionArgs:(NSArray *)selectionArgs
			withGroupBy:(NSString *)groupBy
			 withHaving:(NSString *)having
			   withSort:(NSString *)sort;

-(void)registerContentObserverWithContentURL:(NSURL *)contentUrl
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id <NIOContentObserver>)contentObserver;

-(void)unregisterContentObserver:(id <NIOContentObserver>)contentObserver;

-(BFTask *)updateWithURL:(NSURL *)url
		   withSelection:(NSString *)selection
	   withSelectionArgs:(NSArray *)selectionArgs;
@end