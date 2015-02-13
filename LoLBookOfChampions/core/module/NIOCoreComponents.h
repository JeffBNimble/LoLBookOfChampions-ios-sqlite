//
// Created by Jeff Roberts on 2/4/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>

@class NIOContentResolver;
@protocol NIOContentProvider;
@protocol NIOContentProviderFactory;


@interface NIOCoreComponents : TyphoonAssembly

@property (nonatomic, strong, readonly) NIOCoreComponents *coreComponents;

- (NSString *)bundleIdentifier;

- (DDAbstractLogger *)consoleLogger;

- (NIOContentResolver *)contentResolver;

- (NSBundle *)mainBundle;

- (NSNotificationCenter *)notificationCenter;

- (id<NIOContentProviderFactory>)contentProviderFactory;

@end