//
// Created by Jeff Roberts on 2/3/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIOContentProvider.h"

@protocol NIOContentObserver;


@interface NIOContentResolver : NSObject<NIOContentProvider>
-(instancetype)initWithContentAuthorityBase:(NSString *)contentAuthorityBase withRegistrations:(NSDictionary *)registrations;
-(id<NIOContentProvider>)getContentProviderForContentURL:(NSURL *)contentURL;
-(void)notifyChange:(NSURL *)contentUrl;
-(void)registerContentObserverWithContentURL:(NSURL *)contentUrl
					withNotifyForDescendents:(bool)notifyForDescendents
						 withContentObserver:(id<NIOContentObserver>)contentObserver;
-(void)unregisterContentObserver:(id<NIOContentObserver>)contentObserver;
@end