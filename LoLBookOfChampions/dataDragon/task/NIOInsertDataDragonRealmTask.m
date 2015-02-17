//
// NIOInsertDataDragonRealmTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOInsertDataDragonRealmTask.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"

@interface NIOInsertDataDragonRealmTask ()
@property (strong, nonatomic) NIOContentResolver *contentResolver;
@end

@implementation NIOInsertDataDragonRealmTask
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver {
	self = [super init];
	if ( self ) {
		self.contentResolver = contentResolver;
	}

	return self;
}

-(NSDictionary *)convertRemoteDataDragonRealmDataToInsertValues {
	NSMutableDictionary *values = [NSMutableDictionary new];
	values[[RealmColumns COL_REALM_VERSION]] = self.remoteDataDragonRealmData[@"v"]; // Realm version
	values[[RealmColumns COL_CDN]] = self.remoteDataDragonRealmData[@"cdn"]; // CDN URL
	values[[RealmColumns COL_PROFILE_ICON_MAX]] = self.remoteDataDragonRealmData[@"profileiconmax"]; // Max profile icon identifier

	NSDictionary *versions = self.remoteDataDragonRealmData[@"n"]; // Sub-dictionary of individual API versions
	values[[RealmColumns COL_CHAMPION_VERSION]] = versions[@"champion"]; // Champion version
	values[[RealmColumns COL_SUMMONER_VERSION]] = versions[@"summoner"]; // Summoner version
	values[[RealmColumns COL_LANGUAGE_VERSION]] = versions[@"language"]; // Language version
	values[[RealmColumns COL_MAP_VERSION]] = versions[@"map"]; // Map version
	values[[RealmColumns COL_ITEM_VERSION]] = versions[@"item"]; // Item version
	values[[RealmColumns COL_MASTERY_VERSION]] = versions[@"mastery"]; // Mastery version
	values[[RealmColumns COL_RUNE_VERSION]] = versions[@"rune"]; // Rune version
	values[[RealmColumns COL_PROFILE_ICON_VERSION]] = versions[@"profileicon"]; // Profile icon version

	return values;
}

-(BFTask *)runAsync {
	return [self.contentResolver insertWithURI:[Realm URI]
									withValues:[self convertRemoteDataDragonRealmDataToInsertValues]];
}

@end