////////////////////////////////////////////////////////////////////////////////
//
//  IO.NIMBLENOGGIN
//  Copyright 2015 io.nimblenoggin Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of io.nimblenoggin. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////
#import <Typhoon/TyphoonComponentFactory.h>
#import "ContentProviderFactoryDefaultImpl.h"
#import "NIOContentProvider.h"


@implementation ContentProviderFactoryDefaultImpl

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)initWithFactory:(TyphoonComponentFactory *)factory
{
    self = [super init];
    if (self) {
        _factory = factory;
    }

    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------

- (id<NIOContentProvider>)createContentProviderWithType:(Class)contentProviderClass
{
    return [_factory componentForType:contentProviderClass];
}


@end