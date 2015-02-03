//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>

@class NIOLoLApiRequestOperationManager;
@class GetRealmTask;
@class NIODataDragonSyncService;
@protocol NIOContentProvider;

@interface NIODataDragonComponents : TyphoonAssembly
-(GetRealmTask *)getRealmTask;
-(id<NIOContentProvider>)dataDragonContentProvider;
-(NIODataDragonSyncService *)dataDragonSyncService;
-(NIOLoLApiRequestOperationManager *)lolStaticDataApiRequestOperationManager;
@end