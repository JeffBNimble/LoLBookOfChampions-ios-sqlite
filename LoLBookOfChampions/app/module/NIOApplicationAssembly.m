//
// NIOApplicationAssembly / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "AppDelegate.h"
#import "NIOApplicationAssembly.h"
#import "NIODataDragonComponents.h"
#import "NIOChampionCollectionViewController.h"
#import "NIOContentResolver.h"
#import "NIOCoreComponents.h"
#import "NIOContentProvider.h"
#import "NIOBaseComponentFactory.h"
#import "NIOChampionSkinCollectionViewController.h"
#import "NIOQueryTask.h"
#import <Typhoon/Typhoon.h>

@implementation NIOApplicationAssembly

- (AppDelegate *)appDelegate {
    return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(bundleIdentifier) with:self.coreComponents.bundleIdentifier];
        [definition injectProperty:@selector(contentResolver) with:self.coreComponents.contentResolver];
        [definition injectProperty:@selector(dataDragonSyncService) with:self.dataDragonComponents.dataDragonSyncService];
        [definition injectProperty:@selector(loggers) with:@[self.coreComponents.consoleLogger]];
        [definition injectProperty:@selector(notificationCenter) with:self.coreComponents.notificationCenter];
		[definition injectProperty:@selector(mainScreen) with:self.mainScreen];
        [definition injectProperty:@selector(window) with:self.mainWindow];
    }];
}

- (id)config {
    return [TyphoonDefinition configDefinitionWithName:@"Configuration.plist"];
}

- (NIOChampionCollectionViewController *)championViewController {
	return [TyphoonDefinition withClass:[NIOChampionCollectionViewController class] configuration:^(TyphoonDefinition *definition) {
		[definition injectProperty:@selector(contentResolver) with:self.coreComponents.contentResolver];
		[definition injectProperty:@selector(mainBundle) with:self.coreComponents.mainBundle];
		[definition injectProperty:@selector(currentDevice) with:self.currentDevice];
		[definition injectProperty:@selector(taskFactory) with:self.coreComponents.taskFactory];
	}];
}

- (NIOChampionSkinCollectionViewController *)championSkinViewController {
	return [TyphoonDefinition withClass:[NIOChampionSkinCollectionViewController class] configuration:^(TyphoonDefinition *definition) {
		[definition injectProperty:@selector(contentResolver) with:self.coreComponents.contentResolver];
		[definition injectProperty:@selector(taskFactory) with:self.coreComponents.taskFactory];
	}];
}

-(UIDevice *)currentDevice {
	return [TyphoonDefinition withClass:[UIDevice class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(currentDevice)];
	}];
}

-(UIScreen *)mainScreen {
	return [TyphoonDefinition withClass:[UIScreen class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(mainScreen)];
	}];
}

- (UIWindow *)mainWindow {
    return [TyphoonDefinition withClass:[UIWindow class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithFrame:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[NSValue valueWithCGRect:[[UIScreen mainScreen] bounds]]];
        }];
    }];
}

- (NIOQueryTask *)queryTask {
	return [TyphoonDefinition withClass:[NIOQueryTask class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithContentResolver:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.coreComponents.contentResolver];
		}];

		definition.scope = TyphoonScopePrototype;
	}];
}

@end