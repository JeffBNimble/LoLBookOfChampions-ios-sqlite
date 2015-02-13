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
#import "NIOCoreComponents.h"
#import "NIOContentProvider.h"
#import <Typhoon/Typhoon.h>

@implementation NIOApplicationAssembly
+(void)load {
	//[self markSelectorReserved:@selector(createContentProviderWithType:)];
}

-(AppDelegate *)appDelegate {
	return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
		[definition injectProperty:@selector(window) with:self.mainWindow];
		[definition injectProperty:@selector(bundleIdentifier) with:self.coreComponents.bundleIdentifier];
		[definition injectProperty:@selector(dataDragonSyncService) with:self.dataDragonComponents.dataDragonSyncService];
		[definition injectProperty:@selector(loggers) with:@[self.coreComponents.consoleLogger]];
		[definition injectProperty:@selector(contentResolver) with:self.coreComponents.contentResolver];
		[definition injectProperty:@selector(notificationCenter) with:self.coreComponents.notificationCenter];
	}];
}

-(id)config {
	[NIOCoreComponents setContentProviderFactory:self];
	return [TyphoonDefinition configDefinitionWithName:@"Configuration.plist"];
}

-(id <NIOContentProvider>)createContentProviderWithType:(Class)contentProviderClass {
	id<NIOContentProvider> contentProvider = [[self asFactory] componentForType:contentProviderClass];
	contentProvider = contentProvider ? contentProvider :
					  [[self.dataDragonComponents asFactory] componentForType:contentProviderClass];
	contentProvider = contentProvider ? contentProvider :
					  [[self.coreComponents asFactory] componentForType:contentProviderClass];

	return contentProvider;
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