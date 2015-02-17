//
// NIOChampionSkinCollectionViewController / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOChampionSkinCollectionViewController.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"
#import "NIOCursor.h"
#import "NIOChampionSkinCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NIOChampionSkinCollectionViewController ()
@property (strong, nonatomic) id<NIOCursor> cursor;
@end

@implementation NIOChampionSkinCollectionViewController
-(void)viewDidLoad {
	[super viewDidLoad];
	self.title = [NSString stringWithFormat:@"%@, %@", self.championName, self.championTitle];
	[self queryChampionSkins];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if ( self.cursor ) {
		[self.cursor close];
		self.cursor = nil;
		self.championName = nil;
		self.championId = 0;
		self.championTitle = nil;
	}
}

-(void)viewWillTransitionToSize:(CGSize)size
	  withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	[self.collectionViewLayout invalidateLayout];
	dispatch_async(dispatch_get_main_queue(), ^{
		NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
		[self.collectionView reloadItemsAtIndexPaths:indexPaths];
		[self.collectionView scrollToItemAtIndexPath:[indexPaths firstObject]
									atScrollPosition:UICollectionViewScrollPositionTop
											animated:YES];

	});
}

-(NSArray *)buildProjection {
	return @[[ChampionSkinColumns COL_NAME], [ChampionSkinColumns COL_LOADING_IMAGE_URL], [ChampionSkinColumns COL_SPLASH_IMAGE_URL]];
}

-(NSString *)buildSelection {
	return [NSString stringWithFormat:@"%@ = ?", [ChampionSkinColumns COL_CHAMPION_ID]];
}

-(NSArray *)buildSelectionArgs {
	return @[@(self.championId)];
}

-(void)queryChampionSkins {
	__weak NIOChampionSkinCollectionViewController *weakSelf = self;
	[[self.contentResolver queryWithURL:[ChampionSkin URI]
						 withProjection:[self buildProjection]
						  withSelection:[self buildSelection]
					  withSelectionArgs:[self buildSelectionArgs]
							withGroupBy:nil
							 withHaving:nil
							   withSort:[@[[ChampionSkinColumns COL_ID], [ChampionSkinColumns COL_SKIN_NUMBER]] componentsJoinedByString:@","]]
			continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {

		if ( task.error || task.exception ) {
			DDLogError(@"An error occurred querying champion skins: %@", task.error ? task.error : task.exception);
		} else {
			if ( weakSelf ) {
				weakSelf.cursor = task.result;
				[weakSelf.collectionView reloadData];
			}

		}
		return nil;
	}];
}

#pragma mark UICollectionViewDataSource delegate methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	__block NIOChampionSkinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"championSkinCell"
																							forIndexPath:indexPath];
	[self.cursor moveToPosition:(uint)indexPath.row];

	NSString *urlString = UIDeviceOrientationIsLandscape(self.interfaceOrientation) ? [ChampionSkinColumns COL_SPLASH_IMAGE_URL] : [ChampionSkinColumns COL_LOADING_IMAGE_URL];
	NSURL *imageURL = [NSURL URLWithString:[self.cursor stringForColumn:urlString]];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];

	[cell.skinImageView setImageWithURLRequest:urlRequest
								  placeholderImage:nil
										   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
											   cell.skinImageView.image = image;
											   [cell setNeedsDisplay];
										   }
										   failure:nil];
	return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.cursor ? self.cursor.rowCount : 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return self.cursor ? 1 : 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView
				 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return self.view.frame.size;
}

@end