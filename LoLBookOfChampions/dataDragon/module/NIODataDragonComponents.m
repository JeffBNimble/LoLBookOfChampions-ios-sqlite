//
// NIODataDragonComponents / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "NIODataDragonComponents.h"
#import "NIOLoLApiRequestOperationManager.h"
#import "GetRealmTask.h"
#import "NIODataDragonSyncService.h"
#import "ContentProvider.h"
#import "NIODataDragonContentProvider.h"
#import <Typhoon/Typhoon.h>


@implementation NIODataDragonComponents
-(id)config {
	return [TyphoonDefinition configDefinitionWithName:@"DataDragonConfiguration.plist"];
}

-(id <ContentProvider>)dataDragonContentProvider {
	return [TyphoonDefinition withClass:[NIODataDragonContentProvider class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithDatabaseName:withVersion:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:TyphoonConfig(@"database.name")];
			[initializer injectParameterWith:TyphoonConfig(@"database.version")];
		}];

		definition.scope = TyphoonScopeSingleton;
	}];
}

-(NIODataDragonSyncService *)dataDragonSyncService {
	return [TyphoonDefinition withClass:[NIODataDragonSyncService class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithContentProvider:withGetRealmTask:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.dataDragonContentProvider];
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
		[definition useInitializer:@selector(initWithBaseURL:apiKey:region:apiVersion:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:TyphoonConfig(@"global.endpoint")];
			[initializer injectParameterWith:TyphoonConfig(@"api.key")];
			[initializer injectParameterWith:TyphoonConfig(@"lol.region")];
			[initializer injectParameterWith:TyphoonConfig(@"static.data.api.version")];
		}];

		definition.scope = TyphoonScopeWeakSingleton;
	}];
}

@end