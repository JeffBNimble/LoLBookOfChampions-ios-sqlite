//
// SqliteOpenHelper / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import "SqliteOpenHelper.h"

@interface SqliteOpenHelper ()
@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) NSString *databaseName;
@property (assign, nonatomic) NSInteger databaseVersion;
@end

@implementation SqliteOpenHelper
-(instancetype)initWithName:(NSString *)name withVersion:(NSInteger)version {
	self = [super init];
	if ( self ) {
		self.databaseName = name;
		self.databaseVersion = version;
	}

	return self;
}

-(void)close {
	if ( _database ) [ self.database close];
}

-(FMDatabase *)database {
	return _database;
}

-(void)onConfigure:(FMDatabase *)database {

}

-(void)onCreate:(FMDatabase *)database {

}

-(void)onOpen:(FMDatabase *)database {

}

-(void)onUpgrade:(FMDatabase *)database {

}

@end