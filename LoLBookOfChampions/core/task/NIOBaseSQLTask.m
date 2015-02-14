//
// NIOBaseSQLTask / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/14/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOBaseSQLTask.h"

@interface NIOBaseSQLTask ()
@property (strong, nonatomic) FMDatabase *database;
@end

@implementation NIOBaseSQLTask
-(instancetype)initWithDatabase:(FMDatabase *)database {
	self = [super init];
	if ( self ) {
		self.database = database;
	}

	return self;
}

-(BFTask *)asUpdateResult:(NSInteger)rowsUpdated {
	return self.database.lastErrorCode > 0 ? [BFTask taskWithError:self.database.lastError] : [BFTask taskWithResult:@(self.database.changes)];
}

-(NSInteger)executeDelete {
	NSMutableString *sqlStatement = [NSMutableString new];
	[sqlStatement appendString:DELETE];
	[sqlStatement appendString:FROM];
	[sqlStatement appendString:self.table];

	if ( self.selection && self.selection.length ) {
		[sqlStatement appendString:WHERE];
		[sqlStatement appendString:self.selection];
	}

	if ( self.selectionArgs && self.selectionArgs.count ) {
		[self.database executeUpdate:sqlStatement withArgumentsInArray:self.selectionArgs];
	} else {
		[self.database executeUpdate:sqlStatement];
	}

	return self.database.changes;
}

-(NSInteger)executeInsert {
	NSMutableString *sqlStatement = [NSMutableString new];
	[sqlStatement appendString:INSERT_INTO];
	[sqlStatement appendString:self.table];
	[sqlStatement appendString:@" ("];
	[sqlStatement appendString:[self.values.allKeys componentsJoinedByString:@","]];
	[sqlStatement appendString:@") VALUES ("];

	NSString *comma = @"";
	for ( NSString *columnName in self.values.allKeys ) {
		[sqlStatement appendString:comma];
		[sqlStatement appendString:@":"];
		[sqlStatement appendString:columnName];
		comma = @",";
	}

	[sqlStatement appendString:@")"];

	[self.database executeUpdate:sqlStatement withParameterDictionary:self.values];

	return self.database.changes;
}


@end