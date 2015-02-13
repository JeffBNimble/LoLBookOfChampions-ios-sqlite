//
// Created by Jeff Roberts on 2/3/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentProvider.h"

@protocol NIOContentObserver;
@protocol NIOContentProviderFactory;


@interface NIOContentResolver : NSObject<NIOContentProvider>
-(instancetype)initWithContentProviderFactory:(id<NIOContentProviderFactory>)factory
					 withContentAuthorityBase:(NSString *)contentAuthorityBase
							withRegistrations:(NSDictionary *)registrations NS_DESIGNATED_INITIALIZER;
-(id<NIOContentProvider>)getContentProviderForContentURL:(NSURL *)contentURL;
-(void)notifyChange:(NSURL *)contentUrl;
-(void)registerContentObserverWithContentURL:(NSURL *)contentUrl
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id<NIOContentObserver>)contentObserver;
-(void)unregisterContentObserver:(id<NIOContentObserver>)contentObserver;
@end