//
// NIOSqliteOpenHelper / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "NIOSqliteOpenHelper.h"

@interface NIOSqliteOpenHelper ()
@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) NSString *databaseName;
@property (assign, nonatomic) NSInteger databaseVersion;
@end

@implementation NIOSqliteOpenHelper
-(instancetype)initWithName:(NSString *)name withVersion:(NSInteger)version {
	self = [super init];
	if ( self ) {
		self.databaseName = name;
		self.databaseVersion = version;
	}

	return self;
}

-(NSString *)asAbsolutePath:(NSString *)databasePath {
	NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	return [documentsPath stringByAppendingPathComponent:databasePath];
}

-(void)close {
	if ( _database ) [ self.database close];
}

-(FMDatabase *)database {
	if ( !_database ) {
		self.database = [[FMDatabase alloc] initWithPath:[self asAbsolutePath:self.databaseName]];

		[_database open];
		[_database beginTransaction];

		[self onConfigure:_database];

		NSInteger currentDatabaseVersion = [self getCurrentDatabaseVersion:_database];

		if ( currentDatabaseVersion == 0 ) {
			[self onCreate:_database];
		}

		if ( currentDatabaseVersion > 0 ) {
			if ( currentDatabaseVersion < self.databaseVersion ) {
				[self onUpgrade:_database fromOldVersion:currentDatabaseVersion toNewVersion:self.databaseVersion];
			} else if ( currentDatabaseVersion > self.databaseVersion ) {
				[self onDowngrade:_database fromOldVersion:currentDatabaseVersion toNewVersion:self.databaseVersion];
			}
		}

		if ( currentDatabaseVersion != self.databaseVersion ) {
			[self setCurrentDatabaseVersion:_database withVersion:self.databaseVersion];
		}

		[self onOpen:_database];

		[_database commit];
	}

	return _database;

}

-(NSInteger)getCurrentDatabaseVersion:(FMDatabase *)db {
	FMResultSet *cursor = [db executeQuery:@"PRAGMA user_version"];
	NSInteger version = 0;
	if ( [cursor next] ) {
		version = [cursor intForColumn:@"user_version"];
	}

	[cursor close];

	return version;
}

-(void)onConfigure:(FMDatabase *)database {
	DDLogVerbose(@"Configuring %@", [database databasePath]);
}

-(void)onCreate:(FMDatabase *)database {
	DDLogVerbose(@"Creating %@", [database databasePath]);
}

-(void)onDowngrade:(FMDatabase *)database fromOldVersion:(NSInteger)oldVersion toNewVersion:(NSInteger)newVersion {
	DDLogVerbose(@"Downgrading %@ from v%ld to v%ld", [database databasePath], oldVersion, newVersion);
}

-(void)onOpen:(FMDatabase *)database {
	DDLogVerbose(@"Opening %@", [database databasePath]);
}

-(void)onUpgrade:(FMDatabase *)database fromOldVersion:(NSInteger)oldVersion toNewVersion:(NSInteger)newVersion {
	DDLogVerbose(@"Upgrading %@ from v%ld to v%ld", [database databasePath], oldVersion, newVersion);
}

-(void)setCurrentDatabaseVersion:(FMDatabase *)db withVersion:(NSInteger)dbVersion {
	[db executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version = %ld", dbVersion]];
}

@end