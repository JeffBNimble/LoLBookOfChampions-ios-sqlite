//
// NIOChampionCollectionViewCell / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOChampionCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NIOChampionCollectionViewCell ()

@end

@implementation NIOChampionCollectionViewCell
-(void)prepareForReuse {
	[super prepareForReuse];
	self.championImageView.image = nil;
}


@end