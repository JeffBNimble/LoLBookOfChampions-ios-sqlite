//
// NIODataDragonContentProvider / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIODataDragonContentProvider.h"
#import "NIODataDragonSqliteOpenHelper.h"
#import "NIOUriMatcher.h"
#import "NIOContentResolver.h"
#import "DataDragonContract.h"

@interface NIODataDragonContentProvider ()
@property (strong, nonatomic) NIODataDragonSqliteOpenHelper *databaseHelper;
@property (strong, nonatomic) NIOUriMatcher *urlMatcher;
@property (assign, nonatomic) NSInteger databaseVersion;
@end

@implementation NIODataDragonContentProvider
-(instancetype)initWithContentResolver:(NIOContentResolver *)contentResolver {
	self = [super initWithContentResolver:contentResolver];
	if ( self ) {
		self.databaseVersion = 1;
		self.databaseHelper = [[NIODataDragonSqliteOpenHelper alloc] initWithName:[DataDragonContract DB_NAME] withVersion:self.databaseVersion];
        self.urlMatcher = [[NIOUriMatcher alloc] initWith:NO_MATCH];
        [self.urlMatcher addURL:[NSURL URLWithString:@"content://io.nimblenoggin.lolbookofchampions/datadragon/champion"] withMatchCode:1];
        [self.urlMatcher addURL:[NSURL URLWithString:@"content://io.nimblenoggin.lolbookofchampions/datadragon/map"] withMatchCode:2];
        NSURL *matchingURL =  [NSURL URLWithString:@"content://io.nimblenoggin.lolbookofchampions/datadragon/champion"];
        NSURL *noMatchURL = [NSURL URLWithString:@"content://io.nimblenoggin.lolbookofchampions/datadragons/whatever"] ;
        NSLog(@"Matches %@? %@", matchingURL, [self.urlMatcher match:matchingURL] >= 0 ? @"Yes" : @"No");
        NSLog(@"Matches %@? %@", noMatchURL, [self.urlMatcher match:noMatchURL] >= 0 ? @"Yes" : @"No");
    }

	return self;
}

-(NSInteger)deleteWithUri:(NSURL *)uri withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return 0;
}

-(NSURL *)insertWithUri:(NSURL *)uri withValues:(NSDictionary *)values {
	return nil;
}

-(FMResultSet *)queryWithUri:(NSURL *)uri
			  withProjection:(NSArray *)projection
			   withSelection:(NSString *)selection
		   withSelectionArgs:(NSArray *)selectionArgs
				 withGroupBy:(NSString *)groupBy
				  withHaving:(NSString *)having
					withSort:(NSString *)sort {
	self.databaseHelper.database;
	return nil;
}

-(NSInteger)updateWithUri:(NSURL *)uri withSelection:(NSString *)selection withSelectionArgs:(NSArray *)selectionArgs {
	return 0;
}

@end