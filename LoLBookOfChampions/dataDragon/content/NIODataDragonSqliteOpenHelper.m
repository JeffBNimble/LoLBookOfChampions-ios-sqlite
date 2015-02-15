//
// NIODataDragonSqliteOpenHelper / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODataDragonSqliteOpenHelper.h"
#import "NIODataDragonContract.h"


@implementation NIODataDragonSqliteOpenHelper
-(instancetype)initWithName:(NSString *)name withVersion:(NSInteger)version {
	self = [super initWithName:name withVersion:version];
	if ( self ) {
	}

	return self;
}

-(void)createChampionTable:(FMDatabase *)database {
	NSString *sql = @"CREATE TABLE %@ "
			"(%@ INTEGER NOT NULL PRIMARY KEY, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL "
			") ";

	[database executeUpdate:[NSString stringWithFormat:sql,
													   [Champion DB_TABLE],
													   [ChampionColumns COL_ID],
													   [ChampionColumns COL_NAME],
													   [ChampionColumns COL_TITLE],
													   [ChampionColumns COL_BLURB],
													   [ChampionColumns COL_KEY],
													   [ChampionColumns COL_IMAGE_URL]
	]];

	sql = @"CREATE INDEX %@ ON %@ (%@)";
	[database executeUpdate:[NSString stringWithFormat:sql,
													   @"champion_idx_01",
													   [Champion DB_TABLE],
													   [ChampionColumns COL_NAME]]];
}

-(void)createChampionSkinTable:(FMDatabase *)database {
	NSString *sql = @"CREATE TABLE %@ "
			"(%@ INTEGER NOT NULL, "
			"%@ INTEGER NOT NULL, "
			"%@ INTEGER NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"PRIMARY KEY(%@, %@)"
			") ";

	[database executeUpdate:[NSString stringWithFormat:sql,
													   [ChampionSkin DB_TABLE],
													   [ChampionSkinColumns COL_ID],
													   [ChampionSkinColumns COL_CHAMPION_ID],
													   [ChampionSkinColumns COL_SKIN_NUMBER],
													   [ChampionSkinColumns COL_NAME],
													   [ChampionSkinColumns COL_SPLASH_IMAGE_URL],
													   [ChampionSkinColumns COL_LOADING_IMAGE_URL],
													   [ChampionSkinColumns COL_CHAMPION_ID],
													   [ChampionSkinColumns COL_SKIN_NUMBER]
	]];
}

-(void)createRealmTable:(FMDatabase *)database {
	NSString *sql = @"CREATE TABLE %@ "
			"(%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ TEXT NOT NULL, "
			"%@ INTEGER NOT NULL) ";

	[database executeUpdate:[NSString stringWithFormat:sql,
													   [Realm DB_TABLE],
													   [RealmColumns COL_REALM_VERSION],
													   [RealmColumns COL_CDN],
													   [RealmColumns COL_CHAMPION_VERSION],
													   [RealmColumns COL_ITEM_VERSION],
													   [RealmColumns COL_LANGUAGE_VERSION],
													   [RealmColumns COL_MAP_VERSION],
													   [RealmColumns COL_MASTERY_VERSION],
													   [RealmColumns COL_PROFILE_ICON_VERSION],
													   [RealmColumns COL_RUNE_VERSION],
													   [RealmColumns COL_SUMMONER_VERSION],
													   [RealmColumns COL_PROFILE_ICON_MAX]
	]];
}

-(void)dropAndRecreateDatabase:(FMDatabase *)db {
	[self reset];
	[self onCreate:db];
}

-(void)onCreate:(FMDatabase *)database {
	[super onCreate:database];

	[self createRealmTable:database];
	[self createChampionTable:database];
	[self createChampionSkinTable:database];
}

-(void)onDowngrade:(FMDatabase *)database fromOldVersion:(NSInteger)oldVersion toNewVersion:(NSInteger)newVersion {
	[super onDowngrade:database fromOldVersion:oldVersion toNewVersion:newVersion];

	[self dropAndRecreateDatabase:database];
}

-(void)onUpgrade:(FMDatabase *)database fromOldVersion:(NSInteger)oldVersion toNewVersion:(NSInteger)newVersion {
	[super onUpgrade:database fromOldVersion:oldVersion toNewVersion:newVersion];

	[self dropAndRecreateDatabase:database];
}

-(void)reset {
	FMDatabase *db = self.database;

	[db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", Realm.DB_TABLE]];
	[db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", Champion.DB_TABLE]];
	[db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", ChampionSkin.DB_TABLE]];
}


@end