//
// NIOChampionSkinCollectionViewCell / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOChampionSkinCollectionViewCell.h"


@implementation NIOChampionSkinCollectionViewCell
-(void)prepareForReuse {
	[super prepareForReuse];
	self.skinImageView.image = nil;
}

@end