//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>
#import <FMDB/FMDB.h>

@class NIOLoLApiRequestOperationManager;
@class NIOGetRealmTask;
@class NIODataDragonSyncService;
@protocol NIOContentProvider;
@class NIOCoreComponents;
@class NIODataDragonContentProvider;
@class NIODataDragonSqliteOpenHelper;
@class NIOQueryRealmsTask;
@class NIODeleteRealmTask;
@class NIOClearLocalDataDragonDataTask;
@class NIOInsertRealmTask;
@class NIOInsertDataDragonRealmTask;
@class NIOGetChampionStaticDataTask;
@class NIODeleteChampionTask;
@class NIODeleteChampionSkinTask;
@class NIOInsertChampionTask;
@class NIOInsertChampionSkinTask;

@interface NIODataDragonComponents : TyphoonAssembly
@property (nonatomic, strong, readonly) NIOCoreComponents *coreComponents;

-(NIOClearLocalDataDragonDataTask *)clearLocalDataDragonDataTask;
-(NIODataDragonContentProvider *)dataDragonContentProvider;
-(FMDatabase *)dataDragonSqliteDatabase;
-(NIODataDragonSqliteOpenHelper *)dataDragonSqliteOpenHelper;
-(NIODataDragonSyncService *)dataDragonSyncService;
-(NIODeleteChampionTask *)deleteChampionTask;
-(NIODeleteChampionSkinTask *)deleteChampionSkinTask;
-(NIODeleteRealmTask *)deleteRealmsTask;
-(NIOGetChampionStaticDataTask *)getChampionStaticDataTask;
-(NIOGetRealmTask *)getRealmTask;
-(NIOInsertChampionTask *)insertChampionTask;
-(NIOInsertChampionSkinTask *)insertChampionSkinTask;
-(NIOInsertDataDragonRealmTask *)insertDataDragonRealmTask;
-(NIOInsertRealmTask *)insertRealmTask;
-(NIOLoLApiRequestOperationManager *)lolStaticDataApiRequestOperationManager;
-(NIOQueryRealmsTask *)queryRealmsTask;
@end