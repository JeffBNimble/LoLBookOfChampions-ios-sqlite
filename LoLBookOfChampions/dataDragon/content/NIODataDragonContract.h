//
// Created by Jeff Roberts on 1/25/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NIODataDragonContract : NSObject
+(void)contentAuthorityBase:(NSString *)contentAuthorityBase;
+(NSURL *)CONTENT_URI;
+(NSString *)DB_NAME;
@end

@interface Champion : NSObject
+(NSString *)DB_TABLE;
+(NSURL *)URI;
@end

@interface ChampionColumns : NSObject
+(NSString *)COL_BLURB;
+(NSString *)COL_ID;
+(NSString *)COL_IMAGE_URL;
+(NSString *)COL_KEY;
+(NSString *)COL_NAME;
+(NSString *)COL_TITLE;
@end

@interface ChampionSkin : NSObject
+(NSString *)DB_TABLE;
+(NSURL *)URI;
@end

@interface ChampionSkinColumns : NSObject
+(NSString *)COL_CHAMPION_ID;
+(NSString *)COL_LOADING_IMAGE_URL;
+(NSString *)COL_NAME;
+(NSString *)COL_SKIN_NUMBER;
+(NSString *)COL_SPLASH_IMAGE_URL;
@end

@interface Realm : NSObject
+(NSString *)DB_TABLE;
+(NSURL *)URI;
@end

@interface RealmColumns : NSObject
+(NSString *)COL_CHAMPION_VERSION;
+(NSString *)COL_CDN;
+(NSString *)COL_ITEM_VERSION;
+(NSString *)COL_LANGUAGE_VERSION;
+(NSString *)COL_MAP_VERSION;
+(NSString *)COL_MASTERY_VERSION;
+(NSString *)COL_PROFILE_ICON_MAX;
+(NSString *)COL_PROFILE_ICON_VERSION;
+(NSString *)COL_REALM_VERSION;
+(NSString *)COL_RUNE_VERSION;
+(NSString *)COL_SUMMONER_VERSION;
@end