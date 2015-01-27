//
// DataDragonContract / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/25/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "DataDragonContract.h"

@implementation DataDragonContract
+(NSURL *)CONTENT_URI {
	static NSURL *contentUri;
	if ( !contentUri ) {
		contentUri = [NSURL URLWithString:@"content://io.nimblenoggin.datadragon"];
	}

	return contentUri;
}

@end

@implementation Realm
+(NSString *)DB_TABLE {
	return @"realm";
}

+(NSURL *)URI {
	static NSURL *uri;
	if ( !uri ) {
		uri = [[DataDragonContract CONTENT_URI] URLByAppendingPathComponent:@"realm"];
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