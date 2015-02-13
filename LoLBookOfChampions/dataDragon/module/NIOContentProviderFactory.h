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
#import <Foundation/Foundation.h>

@protocol NIOContentProvider;

@protocol NIOContentProviderFactory

- (id<NIOContentProvider>)createContentProviderWithType:(Class)contentProviderClass;

@end
