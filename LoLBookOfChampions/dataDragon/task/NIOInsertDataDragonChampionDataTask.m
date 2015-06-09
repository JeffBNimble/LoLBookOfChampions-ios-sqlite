//
// NIOInsertDataDragonChampionDataTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/15/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOInsertDataDragonChampionDataTask.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"

@interface NIOInsertDataDragonChampionDataTask ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@property (strong, nonatomic) NSMutableArray *loadingImageURLs;
@property (strong, nonatomic) NSMutableArray *splashImageURLs;
@property (strong, nonatomic) NSMutableArray *squareChampImageURLs;
@end

@implementation NIOInsertDataDragonChampionDataTask
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver
                 withExecutionExecutor:(BFExecutor *)executionExecutor
                withCompletionExecutor:(BFExecutor *)completionExecutor {
	self = [super initWithExecutionExecutor:executionExecutor withCompletionExecutor:completionExecutor];
	if ( self ) {
		self.contentResolver = contentResolver;
	}

	return self;
}

-(NSDictionary *)championInsertValuesFrom:(NSDictionary *)championData {
	NSURL *imageURL = [self.dataDragonCDN URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/img/champion/%@.png", self.dataDragonRealmVersion, championData[@"key"]]];
	NSString *imageURLString = [imageURL absoluteString];
	[self.squareChampImageURLs addObject:imageURLString];

	NSMutableDictionary *values = [NSMutableDictionary new];
	values[[ChampionColumns COL_ID]] = championData[@"id"];
	values[[ChampionColumns COL_NAME]] = championData[@"name"];
	values[[ChampionColumns COL_KEY]] = championData[@"key"];
	values[[ChampionColumns COL_BLURB]] = championData[@"blurb"];
	values[[ChampionColumns COL_TITLE]] = championData[@"title"];
	values[[ChampionColumns COL_IMAGE_URL]] = imageURLString;

	return values;
}

-(NSDictionary *)championSkinInsertValuesFrom:(NSDictionary *)championSkinData
							   withChampionId:(NSNumber *)championId
							 withChampionName:(NSString *)championKey {
	NSNumber *skinNumber = championSkinData[@"num"];
	NSURL *splashImageURL = [self.dataDragonCDN URLByAppendingPathComponent:[NSString stringWithFormat:@"img/champion/splash/%@_%@.jpg", championKey, skinNumber]];
	NSString *splashImageURLString = [splashImageURL absoluteString];
	NSURL *loadingImageURL = [self.dataDragonCDN URLByAppendingPathComponent:[NSString stringWithFormat:@"img/champion/loading/%@_%@.jpg", championKey, skinNumber]];
	NSString *loadingImageURLString = [loadingImageURL absoluteString];

	[self.splashImageURLs addObject:splashImageURLString];
	[self.loadingImageURLs addObject:loadingImageURLString];

	NSMutableDictionary *values = [NSMutableDictionary new];
	values[[ChampionSkinColumns COL_ID]] = championSkinData[@"id"];
	values[[ChampionSkinColumns COL_CHAMPION_ID]] = championId;
	values[[ChampionSkinColumns COL_SKIN_NUMBER]] = skinNumber;
	values[[ChampionSkinColumns COL_NAME]] = championSkinData[@"name"];
	values[[ChampionSkinColumns COL_SPLASH_IMAGE_URL]] = splashImageURLString;
	values[[ChampionSkinColumns COL_LOADING_IMAGE_URL]] = loadingImageURLString;

	return values;
}

-(BFTask *)run {
    __block __weak NIOInsertDataDragonChampionDataTask *weakSelf = self;
    return [BFTask taskFromExecutor:self.executionExecutor withBlock:^id{
        NSError *error;
        NSDictionary *allChampionData = weakSelf.remoteDataDragonChampionData[@"data"];
        weakSelf.squareChampImageURLs = [[NSMutableArray alloc] initWithCapacity:allChampionData.count];
        weakSelf.loadingImageURLs = [[NSMutableArray alloc] initWithCapacity:allChampionData.count * 5]; // Assume an average of 5 skins per champ
        weakSelf.splashImageURLs = [[NSMutableArray alloc] initWithCapacity:allChampionData.count * 5]; // Assume an average of 5 skins per champ
        
        for ( NSString *key in [allChampionData allKeys] ) {
            NSDictionary *championData = allChampionData[key];
            NSNumber *championId = championData[@"id"];
            NSString *championKey = championData[@"key"];
            NSDictionary *championSkinsData = championData[@"skins"];
            
            // Insert the champion row
            DDLogVerbose(@"Inserting champion info for %@", championKey);
            [weakSelf.contentResolver insertWithURI:[Champion URI]
                                      withValues:[weakSelf championInsertValuesFrom:championData]
                                       withError:&error];
            
            if (error) return [BFTask taskWithError:error];
            
            // Insert the skins for this champion
            for ( NSDictionary *championSkinData in championSkinsData ) {
                DDLogVerbose(@"Inserting champion skin %@ for %@", championSkinData[@"name"], championKey);
                [weakSelf.contentResolver insertWithURI:[ChampionSkin URI]
                                             withValues:[weakSelf championSkinInsertValuesFrom:championSkinData
                                                                                withChampionId:championId
                                                                              withChampionName:championKey]
                                              withError:&error];
                
            }
        }
        
        
        NSUInteger imageCount = weakSelf.squareChampImageURLs.count + weakSelf.loadingImageURLs.count + weakSelf.splashImageURLs.count;
        __block NSMutableArray *allImageURLs = [[NSMutableArray alloc] initWithCapacity:imageCount];
        [allImageURLs addObjectsFromArray:weakSelf.squareChampImageURLs]; // Cache the square images first
        [allImageURLs addObjectsFromArray:weakSelf.loadingImageURLs]; // Cache the loading images next
        [allImageURLs addObjectsFromArray:weakSelf.splashImageURLs]; // Cache the splash images last
        return [BFTask taskFromExecutor:weakSelf.completionExecutor withBlock:^id{
            return allImageURLs;
        }];
    }];
}

@end