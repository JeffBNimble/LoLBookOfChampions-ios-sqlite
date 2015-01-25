//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 nimbleNoggin.io. All rights reserved.
//

#import <FMDB/FMDatabase.h>
#import <Foundation/Foundation.h>


@interface SqliteOpenHelper : NSObject
@property (strong, nonatomic, readonly) FMDatabase *database;
@property (strong, nonatomic, readonly) NSString *databaseName;

-(instancetype)initWithName:(NSString *)name withVersion:(NSInteger)version;
-(void)close;
-(void)onConfigure:(FMDatabase *)database;
-(void)onCreate:(FMDatabase *)database;
-(void)onOpen:(FMDatabase *)database;
-(void)onUpgrade:(FMDatabase *)database;
@end