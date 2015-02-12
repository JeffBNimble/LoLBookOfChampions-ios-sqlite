//
// DataDragonContract / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/25/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "DataDragonContract.h"

#define CONTENT_AUTHORITY_URL_STRING(CONTENT_AUTHORITY)		[NSString stringWithFormat:@"content://%@", CONTENT_AUTHORITY]

@implementation DataDragonContract

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