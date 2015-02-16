//
// NIOSqliteCursor / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOSqliteCursor.h"

@interface NIOSqliteCursor ()
@property (strong, nonatomic) NSMutableArray *columnNames;
@property (assign, nonatomic) NSInteger cursorPosition; // 0-based
@property (strong, nonatomic) FMResultSet *resultSet;
@property (assign, nonatomic) NSUInteger resultSetRowCount;
@property (strong, nonatomic) NSMutableArray *rowCache; // An array of dictionaries (1 per row)
@end

@implementation NIOSqliteCursor
-(instancetype)initWithResultSet:(FMResultSet *)resultSet withRowCount:(NSUInteger)rowCount {
	self = [super init];
	if ( self ) {
		self.cursorPosition = -1;
		self.resultSet = resultSet;
		self.resultSetRowCount = rowCount;
		self.rowCache = [[NSMutableArray alloc] initWithCapacity:rowCount];
		if ( rowCount > 0 ) {
			[self ensureRowCacheUpTo:MIN(rowCount - 1, 4)]; // Cache the first chunk of rows
		}
		self.columnNames = [NSMutableArray new];
		[self cacheColumnNames];
	}

	return self;
}

-(BOOL)boolForColumn:(NSString *)columnName {
	return [((NSNumber *) [self valueAt:columnName]) boolValue];

}

-(BOOL)boolForColumnIndex:(int)columnIndex {
	return [self boolForColumn:[self columnNameForIndex:columnIndex]];
}

-(void)cacheColumnNames {
	for ( uint i = 0; i < self.columnCount; i++ ) {
		[self.columnNames addObject:[self.resultSet columnNameForIndex:i]];
	}
}

-(NSDictionary *)cachedRowAt:(uint)index {
	return index >= self.rowCache.count ? nil : (NSDictionary *)self.rowCache[index];
}

-(void)close {
	[self.resultSet close];
	[self.rowCache removeAllObjects];
	self.resultSetRowCount = 0;
	self.cursorPosition = 0;
}

-(int)columnCount {
	return self.resultSet.columnCount;
}

-(int)columnIndexForName:(NSString *)columnName {
	return [self.resultSet columnIndexForName:columnName];
}

-(BOOL)columnIndexIsNull:(int)columnIndex {
	return [self columnIsNull:[self columnNameForIndex:columnIndex]];
}

-(BOOL)columnIsNull:(NSString *)columnName {
	return [self valueAt:columnName] == [NSNull null];
}

-(NSString *)columnNameForIndex:(int)columnIndex {
	return (NSString *)self.columnNames[columnIndex];
}

-(NSData *)dataForColumnIndex:(int)columnIndex {
	return [self dataForColumn:[self columnNameForIndex:columnIndex]];
}

-(NSData *)dataForColumn:(NSString *)columnName {
	return (NSData *)[self valueAt:columnName];
}

-(NSDate *)dateForColumnIndex:(int)columnIndex {
	return [self dateForColumn:[self columnNameForIndex:columnIndex]];
}

-(NSDate *)dateForColumn:(NSString *)columnName {
	return (NSDate *)[self valueAt:columnName];
}

-(double)doubleForColumn:(NSString *)columnName {
	return [((NSNumber *) [self valueAt:columnName]) doubleValue];
}

-(double)doubleForColumnIndex:(int)columnIndex {
	return [self doubleForColumn:[self columnNameForIndex:columnIndex]];
}

-(void)ensureRowCacheUpTo:(uint)cachePosition {
	if ( (self.rowCache.count) > cachePosition ) return;
	uint lastIndex = MIN(self.resultSetRowCount - 1, cachePosition);

	for ( uint i = 0; i <= lastIndex; i++ ) {
		if ( ![self.resultSet next]) break;
		[self.rowCache addObject:[self.resultSet resultDictionary]];
	}
}

-(int)intForColumn:(NSString *)columnName {
	return [((NSNumber *) [self valueAt:columnName]) intValue];
}

-(int)intForColumnIndex:(int)columnIndex {
	return [self intForColumn:[self columnNameForIndex:columnIndex]];
}

-(long)longForColumn:(NSString *)columnName {
	return [((NSNumber *)[self valueAt:columnName]) longValue];
}

-(long)longForColumnIndex:(int)columnIndex {
	return [self longForColumn:[self columnNameForIndex:columnIndex]];
}

-(long long int)longLongIntForColumn:(NSString *)columnName {
	return [((NSNumber *)[self valueAt:columnName]) longLongValue];
}

-(long long int)longLongIntForColumnIndex:(int)columnIndex {
	return [self longForColumn:[self columnNameForIndex:columnIndex]];
}

-(BOOL)move:(int)offset {
	return [self moveToPosition:(uint)(MAX(self.cursorPosition, 0)) + offset];
}

-(BOOL)moveToFirst {
	return [self moveToPosition:0];
}

-(BOOL)moveToLast {
	return [self moveToPosition:self.resultSetRowCount - 1];
}

-(BOOL)moveToPosition:(int)position {
	if ( position < 0 || position >= self.resultSetRowCount ) return NO;
	[self ensureRowCacheUpTo:(uint)position];
	self.cursorPosition = position;
	return YES;
}

-(BOOL)next {
	return [self moveToPosition:(uint)++self.cursorPosition];
}

-(BOOL)previous {
	if ( self.cursorPosition == 0 ) return NO;
	self.cursorPosition--;
	return YES;
}

-(NSUInteger)rowCount {
	return self.resultSetRowCount;
}

-(NSString *)stringForColumn:(NSString *)columnName {
	return (NSString *)[self valueAt:columnName];

}

-(NSString *)stringForColumnIndex:(int)columnIndex {
	return [self stringForColumn:[self columnNameForIndex:columnIndex]];
}

-(unsigned long long int)unsignedLongLongIntForColumn:(NSString *)columnName {
	return [((NSNumber *)[self valueAt:columnName]) unsignedLongLongValue];
}

-(unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIndex {
	return [self unsignedLongLongIntForColumn:[self columnNameForIndex:columnIndex]];
}

-(id)valueAt:(NSString *)columnName {
	return [self cachedRowAt:(uint)self.cursorPosition][columnName];
}


@end