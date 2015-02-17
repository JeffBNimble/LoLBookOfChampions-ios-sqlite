//
//  NIOChampionCollectionViewController.m
//  LoLBookOfChampions
//
//  Created by Jeff Roberts on 1/19/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Bolts/BFTask.h>
#import "NIOChampionCollectionViewController.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"
#import "NIOChampionCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NIOCursor.h"
#import "NIOChampionSkinCollectionViewController.h"

@interface NIOChampionCollectionViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UICollectionView *championCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) id<NIOCursor> cursor;
@end

@implementation NIOChampionCollectionViewController

-(NSArray *)buildProjection {
	return @[[ChampionColumns COL_NAME], [ChampionColumns COL_IMAGE_URL], [ChampionColumns COL_ID], [ChampionColumns COL_TITLE]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[super prepareForSegue:segue sender:sender];

	if ( [segue.identifier isEqualToString:@"showChampionSkins"] ) {
		NSIndexPath *indexPath = [self.championCollectionView indexPathForCell:sender];
		[self.cursor moveToPosition:indexPath.row];
		NIOChampionSkinCollectionViewController *vc = (NIOChampionSkinCollectionViewController *)segue.destinationViewController;
		vc.championId = (uint) [self.cursor intForColumn:[ChampionColumns COL_ID]];
		vc.championName = [self.cursor stringForColumn:[ChampionColumns COL_NAME]];
		vc.championTitle = [self.cursor stringForColumn:[ChampionColumns COL_TITLE]];
	}
}

-(void)queryChampions {
	[self.activityIndicatorView startAnimating];
	__weak NIOChampionCollectionViewController *weakSelf = self;
	[[self.contentResolver queryWithURI:[Champion URI]
						 withProjection:[self buildProjection]
						  withSelection:nil
					  withSelectionArgs:nil
							withGroupBy:nil
							 withHaving:nil
							   withSort:[ChampionColumns COL_NAME]]
			continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		if ( weakSelf ) {
			[weakSelf.activityIndicatorView stopAnimating];
			[weakSelf.loadingLabel setHidden:YES];
		}

		if ( task.error || task.exception ) {
			DDLogError(@"An error occurred querying champions: %@", task.error ? task.error : task.exception);
		} else {
			if ( weakSelf ) {
				id<NIOCursor> championCursor = task.result;
				if ( championCursor.rowCount > 0 ) {
					weakSelf.cursor = championCursor;
					[weakSelf.championCollectionView reloadData];
				} else {
					[weakSelf.activityIndicatorView startAnimating];
					[weakSelf.loadingLabel setAlpha:0.0f];
					[weakSelf.loadingLabel setHidden:NO];
					[UIView animateWithDuration:2.0f animations:^{
						[weakSelf.loadingLabel setAlpha:1.0f];
					}];
				}
			}
		}
		return nil;
	}];
}

#pragma mark UINavigationControllerDelegate methods

-(void)navigationController:(UINavigationController *)navigationController
	 willShowViewController:(UIViewController *)viewController
				   animated:(BOOL)animated {

	if ( viewController == self ) {
		[self.contentResolver registerContentObserverWithContentURI:[Champion URI]
										   withNotifyForDescendents:YES
												withContentObserver:self];
	} else {
		[self.contentResolver unregisterContentObserver:self];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"LoL Champion Browser";
	self.navigationController.delegate = self;
	[self queryChampions];
}

#pragma mark UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	__block NIOChampionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"championCell"
																					forIndexPath:indexPath];
	[self.cursor moveToPosition:(uint)indexPath.row];
	cell.championNameLabel.text = [self.cursor stringForColumn:[ChampionColumns COL_NAME]];

	NSURL *imageURL = [NSURL URLWithString:[self.cursor stringForColumn:[ChampionColumns COL_IMAGE_URL]]];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL];

	[cell.championImageView setImageWithURLRequest:urlRequest
								  placeholderImage:nil
										   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
											   cell.championImageView.image = image;
											   [cell.championImageView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5f] CGColor]];
											   [cell.championImageView.layer setBorderWidth:1.0f];
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

#pragma mark NIOContentObserver methods

-(void)onUpdate:(NSURL *)contentUri {
	__weak NIOChampionCollectionViewController *weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		if ( weakSelf ) [weakSelf queryChampions];
	});
}

@end
