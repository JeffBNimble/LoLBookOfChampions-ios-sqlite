//
// Created by Jeff Roberts on 2/4/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>

@class NIOContentResolver;
@protocol NIOContentProvider;
@protocol NIOContentProviderFactory;
@protocol NIOTaskFactory;


@interface NIOCoreComponents : TyphoonAssembly

@property (nonatomic, strong, readonly) NIOCoreComponents *coreComponents;

-(NSString *)bundleIdentifier;
-(DDAbstractLogger *)consoleLogger;
-(id<NIOContentProviderFactory>)contentProviderFactory;
-(NIOContentResolver *)contentResolver;
-(NSFileManager *)fileManager;
-(NSBundle *)mainBundle;
-(NSNotificationCenter *)notificationCenter;
-(NSURLCache *)sharedURLCache;
-(id<NIOTaskFactory>)taskFactory;

@end