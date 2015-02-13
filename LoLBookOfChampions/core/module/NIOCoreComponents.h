//
// Created by Jeff Roberts on 2/4/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonAssembly.h>

@class NIOContentResolver;
@protocol NIOContentProvider;

@protocol NIOContentProviderFactory
-(id<NIOContentProvider>)createContentProviderWithType:(Class)contentProviderClass;
@end

@interface NIOCoreComponents : TyphoonAssembly
+(void)setContentProviderFactory:(id<NIOContentProviderFactory>)contentProviderFactory;
-(NSString *)bundleIdentifier;
-(DDAbstractLogger *)consoleLogger;
-(NIOContentResolver *)contentResolver;
-(NSBundle *)mainBundle;
-(NSNotificationCenter *)notificationCenter;

@end