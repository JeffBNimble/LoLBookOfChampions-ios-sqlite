//
// NIODataDragonComponents / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import "NIODataDragonComponents.h"
#import "NIOLoLApiRequestOperationManager.h"
#import "GetRealmTask.h"
#import "NIODataDragonSyncService.h"
#import "NIOContentProvider.h"
#import "NIODataDragonContentProvider.h"
#import "NIOCoreComponents.h"
#import "DataDragonContract.h"
#import <Typhoon/Typhoon.h>


@implementation NIODataDragonComponents

-(id)config {
	return [TyphoonDefinition configDefinitionWithName:@"DataDragonConfiguration.plist"];
}

-(NIODataDragonContentProvider *)dataDragonContentProvider {
	return [TyphoonDefinition withClass:[NIODataDragonContentProvider class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(init)];

		definition.scope = TyphoonScopeWeakSingleton;
	}];
}


-(NIODataDragonSyncService *)dataDragonSyncService {
	return [TyphoonDefinition withClass:[NIODataDragonSyncService class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithContentResolver:withGetRealmTask:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.coreComponents.contentResolver];
			[initializer injectParameterWith:self.getRealmTask];
		}];

		definition.scope = TyphoonScopeWeakSingleton;
	}];
}

-(GetRealmTask *)getRealmTask {
	return [TyphoonDefinition withClass:[GetRealmTask class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithHTTPRequestOperationManager:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.lolStaticDataApiRequestOperationManager];
		}];

		definition.scope = TyphoonScopePrototype;
	}];
}

-(NIOLoLApiRequestOperationManager *)lolStaticDataApiRequestOperationManager {
	return [TyphoonDefinition withClass:[NIOLoLApiRequestOperationManager class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithBaseURL:sessionConfiguration:completionQueue:apiKey:region:apiVersion:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:TyphoonConfig(@"global.endpoint")];
			[initializer injectParameterWith:[NSURLSessionConfiguration defaultSessionConfiguration]];
			[initializer injectParameterWith:dispatch_queue_create("io.nimblenoggin.lol.staticdata", DISPATCH_QUEUE_CONCURRENT)];
			[initializer injectParameterWith:TyphoonConfig(@"api.key")];
			[initializer injectParameterWith:TyphoonConfig(@"lol.region")];
			[initializer injectParameterWith:TyphoonConfig(@"static.data.api.version")];
		}];

		definition.scope = TyphoonScopeWeakSingleton;
	}];
}

@end