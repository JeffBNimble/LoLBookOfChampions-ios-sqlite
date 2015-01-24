//
// NIOApplicationAssembly / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "AppDelegate.h"
#import "NIOApplicationAssembly.h"
#import "NIODataDragonComponents.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "ViewController.h"


@implementation NIOApplicationAssembly
-(AppDelegate *)appDelegate {
	return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
		[definition injectProperty:@selector(window) with:self.mainWindow];
	}];
}

-(id)config {
	return [TyphoonDefinition configDefinitionWithName:@"Configuration.plist"];
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