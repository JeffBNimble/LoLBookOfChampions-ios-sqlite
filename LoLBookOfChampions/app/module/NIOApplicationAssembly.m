//
// NIOApplicationAssembly / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "AppDelegate.h"
#import "NIOApplicationAssembly.h"
#import "NIODataDragonComponents.h"
#import "ViewController.h"
#import "NIOContentResolver.h"
#import <Typhoon/Typhoon.h>

@implementation NIOApplicationAssembly
-(AppDelegate *)appDelegate {
	return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
		[definition injectProperty:@selector(window) with:self.mainWindow];
		[definition injectProperty:@selector(dataDragonSyncService) with:self.dataDragonComponents.dataDragonSyncService];
	}];
}

-(id)config {
	return [TyphoonDefinition configDefinitionWithName:@"Configuration.plist"];
}

-(NIOContentResolver *)contentResolver {
    return [TyphoonDefinition withClass:[NIOContentResolver class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithContentAuthorityBase:withRegistrations:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self.mainBundle bundleIdentifier]];
            [initializer injectParameterWith:TyphoonConfig(@"content_registrations")];
        }];

        definition.scope = TyphoonScopeSingleton;
    }];
}

-(NSBundle *)mainBundle {
    return [NSBundle mainBundle];
}

-(UIWindow *)mainWindow {
	return [TyphoonDefinition withClass:[UIWindow class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithFrame:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:[NSValue valueWithCGRect:[[UIScreen mainScreen] bounds]]];
		}];
	}];
}

-(ViewController *)viewController {
	return [TyphoonDefinition withClass:[ViewController class] configuration:^(TyphoonDefinition *definition) {
		[definition injectProperty:@selector(getRealmTask) with:self.dataDragonComponents.getRealmTask];
	}];
}


@end