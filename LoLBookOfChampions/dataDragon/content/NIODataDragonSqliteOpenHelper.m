//
// NIODataDragonSqliteOpenHelper / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODataDragonSqliteOpenHelper.h"
#import "DataDragonContract.h"


@implementation NIODataDragonSqliteOpenHelper
-(instancetype)initWithName:(NSString *)name withVersion:(NSInteger)version {
	self = [super initWithName:name withVersion:version];
	if ( self ) {

	}

	return self;
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
}


@end