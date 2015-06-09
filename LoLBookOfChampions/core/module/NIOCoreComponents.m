//
// NIOCoreComponents / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/4/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOCoreComponents.h"
#import "NIOContentResolver.h"
#import "NIOBaseComponentFactory.h"
#import "NIOContentProviderFactory.h"
#import "NIOTyphoonContentProviderFactory.h"
#import "NIOTaskFactory.h"
#import "NIOTyphoonTaskFactory.h"
#import <Typhoon/Typhoon.h>

@implementation NIOCoreComponents

- (NSString *)bundleIdentifier {
    return [TyphoonDefinition withFactory:self.mainBundle selector:@selector(bundleIdentifier)];
}

- (DDAbstractLogger *)consoleLogger {
    return [TyphoonDefinition withClass:[DDTTYLogger class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(sharedInstance)];
    }];
}

- (id<NIOContentProviderFactory>)contentProviderFactory {
	return [TyphoonDefinition withClass:[NIOTyphoonContentProviderFactory class]
						  configuration:^(TyphoonDefinition *definition) {
							  [definition useInitializer:@selector(initWithFactory:) parameters:^(TyphoonMethod *initializer) {
								  [initializer injectParameterWith:self];
							  }];
						  }];
}

- (NIOContentResolver *)contentResolver {
    return [TyphoonDefinition withClass:[NIOContentResolver class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithContentProviderFactory:withContentAuthorityBase:withRegistrations:)
            parameters:^(TyphoonMethod *initializer) {
                [initializer injectParameterWith:[self.coreComponents contentProviderFactory]];
                [initializer injectParameterWith:self.bundleIdentifier];
                [initializer injectParameterWith:TyphoonConfig(@"content.registrations")];
            }];

        definition.scope = TyphoonScopeSingleton;
    }];
}

-(BFExecutor *)databaseCompletionExecutor {
    return [TyphoonDefinition withClass:[BFExecutor class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(executorWithDispatchQueue:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:dispatch_queue_create("io.nimblenoggin.content.completion", DISPATCH_QUEUE_SERIAL)];
        }];
    }];
}

-(BFExecutor *)databaseExecutionExecutor {
    return [TyphoonDefinition withClass:[BFExecutor class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(executorWithDispatchQueue:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:dispatch_queue_create("io.nimblenoggin.content.execution", DISPATCH_QUEUE_SERIAL)];
        }];
    }];
}

-(NSFileManager *)fileManager {
	return [TyphoonDefinition withClass:[NSFileManager class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(defaultManager)];
	}];
}

- (NSBundle *)mainBundle {
    return [TyphoonDefinition withClass:[NSBundle class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(mainBundle)];
    }];
}

- (NSNotificationCenter *)notificationCenter {
    return [TyphoonDefinition withClass:[NSNotificationCenter class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(defaultCenter)];
    }];
}

-(NSURLCache *)sharedURLCache {
	return [TyphoonDefinition withClass:[NSURLCache class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(sharedURLCache)];

		definition.scope = TyphoonScopeLazySingleton;
	}];
}


-(id <NIOTaskFactory>)taskFactory {
	return [TyphoonDefinition withClass:[NIOTyphoonTaskFactory class]
						  configuration:^(TyphoonDefinition *definition) {
							  [definition useInitializer:@selector(initWithFactory:) parameters:^(TyphoonMethod *initializer) {
								  [initializer injectParameterWith:self];
							  }];
						  }];
}

@end