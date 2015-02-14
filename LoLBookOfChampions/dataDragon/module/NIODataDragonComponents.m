//
// NIODataDragonComponents / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import "NIODataDragonComponents.h"
#import "NIOLoLApiRequestOperationManager.h"
#import "NIOGetRealmTask.h"
#import "NIODataDragonSyncService.h"
#import "NIOContentProvider.h"
#import "NIODataDragonContentProvider.h"
#import "NIOCoreComponents.h"
#import "NIODataDragonContract.h"
#import "NIODataDragonSqliteOpenHelper.h"
#import "NIOQueryRealmsTask.h"
#import <Typhoon/Typhoon.h>


@implementation NIODataDragonComponents

-(id)config {
	return [TyphoonDefinition configDefinitionWithName:@"DataDragonConfiguration.plist"];
}

-(NIODataDragonContentProvider *)dataDragonContentProvider {
	return [TyphoonDefinition withClass:[NIODataDragonContentProvider class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithTaskFactory:withSqliteOpenHelper:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.coreComponents.taskFactory];
			[initializer injectParameterWith:self.dataDragonSqliteOpenHelper];
		}];

		definition.scope = TyphoonScopeWeakSingleton;
	}];
}

-(FMDatabase *)dataDragonSqliteDatabase {
	return [TyphoonDefinition withFactory:self.dataDragonSqliteOpenHelper selector:@selector(database)];
}

-(NIODataDragonSqliteOpenHelper *)dataDragonSqliteOpenHelper {
	return [TyphoonDefinition withClass:[NIODataDragonSqliteOpenHelper class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithName:withVersion:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:TyphoonConfig(@"database.name")];
			[initializer injectParameterWith:TyphoonConfig(@"database.version")];
		}];

		definition.scope = TyphoonScopeLazySingleton;
	}];
}


-(NIODataDragonSyncService *)dataDragonSyncService {
	return [TyphoonDefinition withClass:[NIODataDragonSyncService class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithContentResolver:withTaskFactory:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.coreComponents.contentResolver];
			[initializer injectParameterWith:self.coreComponents.taskFactory];
		}];

		definition.scope = TyphoonScopeWeakSingleton;
	}];
}

-(NIOGetRealmTask *)getRealmTask {
	return [TyphoonDefinition withClass:[NIOGetRealmTask class] configuration:^(TyphoonDefinition *definition) {
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

-(NIOQueryRealmsTask *)queryRealmsTask {
	return [TyphoonDefinition withClass:[NIOQueryRealmsTask class] configuration:^(TyphoonDefinition *definition) {
		[definition useInitializer:@selector(initWithDatabase:) parameters:^(TyphoonMethod *initializer) {
			[initializer injectParameterWith:self.dataDragonSqliteDatabase];
		}];

		definition.scope = TyphoonScopePrototype;
	}];
}


@end