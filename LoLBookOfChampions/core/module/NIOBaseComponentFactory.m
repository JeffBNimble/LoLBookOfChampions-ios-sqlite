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
#import "NIOBaseComponentFactory.h"
#import "NIOContentProvider.h"

@interface NIOBaseComponentFactory ()
@property (nonatomic, strong) TyphoonComponentFactory *factory;
@end

@implementation NIOBaseComponentFactory

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction
//-------------------------------------------------------------------------------------------

- (instancetype)initWithFactory:(TyphoonComponentFactory *)factory {
    self = [super init];
    if (self) {
        self.factory = factory;
    }

    return self;
}

//-------------------------------------------------------------------------------------------
#pragma mark - Interface Methods
//-------------------------------------------------------------------------------------------



@end