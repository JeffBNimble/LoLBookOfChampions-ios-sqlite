//
// NIODataDragonContract / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/25/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODataDragonContract.h"

#define CONTENT_AUTHORITY_URL_STRING(CONTENT_AUTHORITY)		[NSString stringWithFormat:@"content://%@", CONTENT_AUTHORITY]

@implementation NIODataDragonContract

static NSString *contentAuthorityBase;
+(void)contentAuthorityBase:(NSString *)contentAuthority {
	contentAuthorityBase = CONTENT_AUTHORITY_URL_STRING(contentAuthority);
}

+(NSURL *)CONTENT_URI {
	static NSURL *contentUri;
	if ( !contentUri ) {
		contentUri = [NSURL URLWithString:[NSString stringWithFormat:@"%@.datadragon", contentAuthorityBase]];
	}

	return contentUri;
}

+(NSString *)DB_NAME {
	static NSString *databaseName;
	if ( !databaseName ) {
		databaseName = @"dataDragon.sqlite3";
	}

	return databaseName;
}

@end

@implementation Champion
+(NSString *)DB_TABLE {
	return @"champion";
}

+(NSURL *)URI {
	static NSURL *uri;
	if ( !uri ) {
		uri = [[NIODataDragonContract CONTENT_URI] URLByAppendingPathComponent:@"champion"];
	}

	return uri;
}

@end

@implementation ChampionColumns
+(NSString *)COL_BLURB {
	return @"blurb";
}

+(NSString *)COL_ID {
	return @"champion_id";
}

+(NSString *)COL_IMAGE_URL {
	return @"image_url";
}

+(NSString *)COL_KEY {
	return @"key";
}

+(NSString *)COL_NAME {
	return @"name";
}

+(NSString *)COL_TITLE {
	return @"title";
}
@end

@implementation ChampionSkin
+(NSString *)DB_TABLE {
	return @"champion_skin";
}

+(NSURL *)URI {
	static NSURL *uri;
	if ( !uri ) {
		uri = [[Champion URI] URLByAppendingPathComponent:@"skin"];
	}

	return uri;
}

@end

@implementation ChampionSkinColumns
+(NSString *)COL_CHAMPION_ID {
	return [ChampionColumns COL_ID];
}

+(NSString *)COL_LOADING_IMAGE_URL {
	return @"loading_image_url";
}

+(NSString *)COL_NAME {
	return [ChampionColumns COL_NAME];
}

+(NSString *)COL_SKIN_NUMBER {
	return @"skin_number";
}

+(NSString *)COL_SPLASH_IMAGE_URL {
	return @"splash_image_url";
}

@end

@implementation Realm
+(NSString *)DB_TABLE {
	return @"realm";
}

+(NSURL *)URI {
	static NSURL *uri;
	if ( !uri ) {
		uri = [[NIODataDragonContract CONTENT_URI] URLByAppendingPathComponent:@"realm"];
	}

	return uri;
}

@end

@implementation RealmColumns
+(NSString *)COL_CHAMPION_VERSION {
	return @"champion_version";
}

+(NSString *)COL_CDN {
	return @"cdn";
}

+(NSString *)COL_ITEM_VERSION {
	return @"item_version";
}

+(NSString *)COL_LANGUAGE_VERSION {
	return @"language_version";
}

+(NSString *)COL_MAP_VERSION {
	return @"map_version";
}

+(NSString *)COL_MASTERY_VERSION {
	return @"master_version";
}

+(NSString *)COL_PROFILE_ICON_MAX {
	return @"profile_icon_max";
}

+(NSString *)COL_PROFILE_ICON_VERSION {
	return @"profile_icon_version";
}

+(NSString *)COL_REALM_VERSION {
	return @"realm_version";
}

+(NSString *)COL_RUNE_VERSION {
	return @"rune_version";
}

+(NSString *)COL_SUMMONER_VERSION {
	return @"summoner_version";
}

@end