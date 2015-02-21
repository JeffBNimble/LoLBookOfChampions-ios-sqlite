//
//  NIOChampionCollectionViewController.m
//  LoLBookOfChampions
//
//  Created by Jeff Roberts on 1/19/15.
//  Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Bolts/BFTask.h>
#import <SpriteKit/SpriteKit.h>
#import "NIOChampionCollectionViewController.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"
#import "NIOChampionCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NIOCursor.h"
#import "NIOChampionSkinCollectionViewController.h"
#import "NIOTaskFactory.h"
#import "NIOQueryTask.h"

@interface NIOChampionCollectionViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UICollectionView *championCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (strong, nonatomic) id<NIOCursor> cursor;
@property (strong, nonatomic) SKEmitterNode *magic;
@property (strong, nonatomic) NSArray *magicColors;
@property (strong, nonatomic) SKScene *magicScene;
@property (weak, nonatomic) SKView *magicView;
@property (assign, nonatomic) BOOL presentNewMagicScene;

@end

@implementation NIOChampionCollectionViewController

-(void)assignRandomMagicEmitterColor {
	int colorIndex = rand() % 3; // Generate a random index between 0 and 3
	self.magic.particleColor = self.magicColors[(uint)colorIndex];
}

-(NSArray *)buildProjection {
	return @[[ChampionColumns COL_NAME], [ChampionColumns COL_IMAGE_URL], [ChampionColumns COL_ID], [ChampionColumns COL_TITLE]];
}

-(void)configureMagicParticleView {
	CGRect frame = self.view.frame;
	SKView *magicParticleView = [[SKView alloc] initWithFrame:frame];

	self.magic = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.mainBundle pathForResource:@"magic" ofType:@"sks"]];
	self.magicView = magicParticleView;
	[self.magicView setAsynchronous:YES];
	[self.view addSubview:magicParticleView];
	[self.view sendSubviewToBack:magicParticleView];
	self.presentNewMagicScene = YES;
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

-(void)presentMagicParticleScene {
	CGRect frame = self.view.frame;
	self.magicView.frame = self.view.frame;
	self.magicScene = [SKScene sceneWithSize:frame.size];
	self.magicScene.scaleMode = SKSceneScaleModeAspectFill;
	self.magicScene.backgroundColor = [UIColor blackColor];

	[self assignRandomMagicEmitterColor];
	self.magic.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
	[self.magic removeFromParent];
	[self.magicScene addChild:self.magic];
	[self.magicView presentScene:self.magicScene];
}

-(void)queryChampions {
	[self.activityIndicatorView startAnimating];
	__weak NIOChampionCollectionViewController *weakSelf = self;
	NIOQueryTask *queryTask = [self.taskFactory createTaskWithType:[NIOQueryTask class]];
	queryTask.uri = [Champion URI];
	queryTask.projection = [self buildProjection];
	queryTask.sort = [ChampionColumns COL_NAME];
	[[queryTask runAsync] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
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

- (void)viewDidLoad {
	[super viewDidLoad];
	self.magicColors = @[[UIColor blueColor], [UIColor greenColor], [UIColor redColor]];
	[self configureMagicParticleView];
	self.title = @"LoL Champion Browser";
	self.navigationController.delegate = self;
	[self queryChampions];
}

-(void)viewWillTransitionToSize:(CGSize)size
	  withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	self.presentNewMagicScene = YES;
}

-(void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	if ( self.presentNewMagicScene ) {
		[self presentMagicParticleScene];
		self.presentNewMagicScene = NO;
	}
}

#pragma mark UINavigationControllerDelegate methods

-(void)navigationController:(UINavigationController *)navigationController
	  didShowViewController:(UIViewController *)viewController
				   animated:(BOOL)animated {

	[self.championCollectionView.collectionViewLayout invalidateLayout];
	if ( viewController == self ) {
		[self.contentResolver registerContentObserverWithContentURI:[Champion URI]
										   withNotifyForDescendents:YES
												withContentObserver:self];
		[self.magicView setPaused:NO];
	} else {
		[self.magicView setPaused:YES];
	}
}

-(void)navigationController:(UINavigationController *)navigationController
	  willShowViewController:(UIViewController *)viewController
				   animated:(BOOL)animated {

	if ( viewController == self ) {
		[self assignRandomMagicEmitterColor];
	} else {
		[self.contentResolver unregisterContentObserver:self];
	}
}

#pragma mark UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	__block NIOChampionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"championCell"
																					forIndexPath:indexPath];
	[self.cursor moveToPosition:(uint)indexPath.row];
	cell.championNameLabel.text = [self.cursor stringForColumn:[ChampionColumns COL_NAME]];

	NSURL *imageURL = [NSURL URLWithString:[self.cursor stringForColumn:[ChampionColumns COL_IMAGE_URL]]];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

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

#pragma mark UICollectionViewDelegateFlowLayout methods

-(CGSize)collectionView:(UICollectionView *)collectionView
				 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGSize size = self.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? CGSizeMake(84, 124) : CGSizeMake(124, 164);
	return size;
}


#pragma mark NIOContentObserver methods

-(void)onUpdate:(NSURL *)contentUri {
	__weak NIOChampionCollectionViewController *weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		if ( weakSelf ) [weakSelf queryChampions];
	});
}

@end
