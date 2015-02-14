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

@interface NIODataDragonComponents : TyphoonAssembly
@property (nonatomic, strong, readonly) NIOCoreComponents *coreComponents;

-(NIOGetRealmTask *)getRealmTask;
-(NIODataDragonContentProvider *)dataDragonContentProvider;
-(FMDatabase *)dataDragonSqliteDatabase;
-(NIODataDragonSqliteOpenHelper *)dataDragonSqliteOpenHelper;
-(NIODataDragonSyncService *)dataDragonSyncService;
-(NIOLoLApiRequestOperationManager *)lolStaticDataApiRequestOperationManager;
-(NIOQueryRealmsTask *)queryRealmsTask;
@end