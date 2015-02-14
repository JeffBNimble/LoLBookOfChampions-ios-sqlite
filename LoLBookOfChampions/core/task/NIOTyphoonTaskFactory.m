//
// NIOTyphoonTaskFactory / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/13/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOTyphoonTaskFactory.h"
#import "NIOTask.h"


@implementation NIOTyphoonTaskFactory
-(instancetype)initWithFactory:(TyphoonComponentFactory *)factory {
	self = [super initWithFactory:factory];
	if ( self ) {}

	return self;
}

-(id <NIOTask>)createTaskWithType:(Class)taskClass {
	return [self.factory componentForType:taskClass];
}
@end