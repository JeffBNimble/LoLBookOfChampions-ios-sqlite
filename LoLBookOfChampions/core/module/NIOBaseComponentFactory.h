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

@class TyphoonComponentFactory;


@interface NIOBaseComponentFactory : NSObject

@property (nonatomic, strong, readonly) TyphoonComponentFactory *factory;

- (instancetype)initWithFactory:(TyphoonComponentFactory *)factory NS_DESIGNATED_INITIALIZER;


@end