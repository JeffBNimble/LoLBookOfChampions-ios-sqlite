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
@end

@implementation NIOInsertDataDragonChampionDataTask
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
	}

	return self;
}

-(NSDictionary *)championInsertValuesFrom:(NSDictionary *)championData {
	NSURL *imageURL = [self.dataDragonCDN URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/img/champion/%@", self.dataDragonRealmVersion, championData[@"name"]]];

	NSMutableDictionary *values = [NSMutableDictionary new];
	values[[ChampionColumns COL_ID]] = championData[@"id"];
	values[[ChampionColumns COL_NAME]] = championData[@"name"];
	values[[ChampionColumns COL_KEY]] = championData[@"key"];
	values[[ChampionColumns COL_BLURB]] = championData[@"blurb"];
	values[[ChampionColumns COL_TITLE]] = championData[@"title"];
	values[[ChampionColumns COL_IMAGE_URL]] = [imageURL absoluteString];

	return values;
}

-(NSDictionary *)championSkinInsertValuesFrom:(NSDictionary *)championSkinData
							   withChampionId:(NSNumber *)championId
							 withChampionName:(NSString *)championName {
	NSNumber *skinNumber = championSkinData[@"num"];
	NSURL *splashImageURL = [self.dataDragonCDN URLByAppendingPathComponent:[NSString stringWithFormat:@"img/champion/splash/%@_%@", championName, skinNumber]];
	NSURL *loadingImageURL = [self.dataDragonCDN URLByAppendingPathComponent:[NSString stringWithFormat:@"img/champion/loading/%@_%@", championName, skinNumber]];

	NSMutableDictionary *values = [NSMutableDictionary new];
	values[[ChampionSkinColumns COL_ID]] = championSkinData[@"id"];
	values[[ChampionSkinColumns COL_CHAMPION_ID]] = championId;
	values[[ChampionSkinColumns COL_SKIN_NUMBER]] = skinNumber;
	values[[ChampionSkinColumns COL_NAME]] = championSkinData[@"name"];
	values[[ChampionSkinColumns COL_SPLASH_IMAGE_URL]] = [splashImageURL absoluteString];
	values[[ChampionSkinColumns COL_LOADING_IMAGE_URL]] = [loadingImageURL absoluteString];

	return values;
}

-(BFTask *)runAsync {
	NSDictionary *allChampionData = self.remoteDataDragonChampionData[@"data"];

	for ( NSString *key in [allChampionData allKeys] ) {
		NSDictionary *championData = allChampionData[key];
		NSNumber *championId = championData[@"id"];
		NSString *championName = championData[@"name"];
		NSDictionary *championSkinsData = championData[@"skins"];

		DDLogVerbose(@"Inserting champion info for %@", championName);
		[[self.contentResolver insertWithURL:[Champion URI]
								  withValues:[self championInsertValuesFrom:championData]]
				waitUntilFinished];

		for ( NSDictionary *championSkinData in championSkinsData ) {
			DDLogVerbose(@"Inserting champion skin %@ for %@", championSkinData[@"name"], championName);
			[[self.contentResolver insertWithURL:[ChampionSkin URI]
									  withValues:[self championSkinInsertValuesFrom:championSkinData
																	 withChampionId:championId
																   withChampionName:championName]]
					waitUntilFinished];
		}
	}

	return [BFTask taskWithResult:@(allChampionData.count)];
}

@end