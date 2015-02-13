//
// NIOCoreComponents / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/4/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOCoreComponents.h"
#import "NIOContentResolver.h"
#import "NIOContentProvider.h"
#import "ContentProviderFactoryDefaultImpl.h"
#import "NIOContentProviderFactory.h"
#import <Typhoon/Typhoon.h>


@implementation NIOCoreComponents

static id<NIOContentProviderFactory> contentProviderFactory;


- (NSString *)bundleIdentifier
{
    return [TyphoonDefinition withFactory:self.mainBundle selector:@selector(bundleIdentifier)];
}

- (DDAbstractLogger *)consoleLogger
{
    return [TyphoonDefinition withClass:[DDTTYLogger class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(sharedInstance)];
    }];
}

- (NIOContentResolver *)contentResolver
{
    return [TyphoonDefinition withClass:[NIOContentResolver class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithContentProviderFactory:withContentAuthorityBase:withRegistrations:)
            parameters:^(TyphoonMethod *initializer) {
                [initializer injectParameterWith:[_coreComponents contentProviderFactory]];
                [initializer injectParameterWith:self.bundleIdentifier];
                [initializer injectParameterWith:TyphoonConfig(@"content_registrations")];
            }];

        definition.scope = TyphoonScopeSingleton;
    }];
}

- (NSBundle *)mainBundle
{
    return [TyphoonDefinition withClass:[NSBundle class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(mainBundle)];
    }];
}

- (NSNotificationCenter *)notificationCenter
{
    return [TyphoonDefinition withClass:[NSNotificationCenter class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(defaultCenter)];
    }];
}

- (id<NIOContentProviderFactory>)contentProviderFactory
{
    return [TyphoonDefinition withClass:[ContentProviderFactoryDefaultImpl class]
        configuration:^(TyphoonDefinition *definition) {
            [definition useInitializer:@selector(initWithFactory:) parameters:^(TyphoonMethod *initializer) {
                [initializer injectParameterWith:self];
            }];
        }];
}


@end