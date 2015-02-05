//
// NIOCoreComponents / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/4/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOCoreComponents.h"
#import "NIOContentResolver.h"
#import <Typhoon/Typhoon.h>


@implementation NIOCoreComponents
-(NSString *)bundleIdentifier {
	return [TyphoonDefinition withFactory:self.mainBundle selector:@selector(bundleIdentifier)];
}

-(NIOContentResolver *)contentResolver {
	return [TyphoonDefinition withClass:[NIOContentResolver class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithContentAuthorityBase:withRegistrations:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.bundleIdentifier];
			[initializer injectParameterWith:TyphoonConfig(@"content_registrations")];
		}];

		definition.scope = TyphoonScopeSingleton;
	}];
}

-(NSBundle *)mainBundle {
	return [TyphoonDefinition withClass:[NSBundle class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(mainBundle)];
	}];
}
@end