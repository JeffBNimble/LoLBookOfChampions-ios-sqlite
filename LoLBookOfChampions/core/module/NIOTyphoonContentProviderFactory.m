//
// NIOTyphoonContentProviderFactory / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/13/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOContentProviderFactory.h"
#import "NIOTyphoonContentProviderFactory.h"
#import <Typhoon/Typhoon.h>
#import "NIOContentProvider.h"


@implementation NIOTyphoonContentProviderFactory
-(instancetype)initWithFactory:(TyphoonComponentFactory *)factory {
	self = [super initWithFactory:factory];
	if ( self ) {}

	return self;
}

- (id<NIOContentProvider>)createContentProviderWithType:(Class)contentProviderClass {
	return [self.factory componentForType:contentProviderClass];
}
@end