//
// NIOSqliteCursor / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOSqliteCursor.h"

@interface NIOSqliteCursor ()
@property (assign, nonatomic) NSInteger cursorPosition; // 0-based
@property (strong, nonatomic) FMResultSet *resultSet;
@property (assign, nonatomic) NSUInteger resultSetRowCount;
@property (strong, nonatomic) NSMutableArray *rowCache; // An array of dictionaries (1 per row)
@end

@implementation NIOSqliteCursor
-(instancetype)initWithResultSet:(FMResultSet *)resultSet andRowCount:(NSUInteger)rowCount {
	self = [super init];
	if ( self ) {
		self.resultSet = resultSet;
		self.resultSetRowCount = rowCount;
		self.rowCache = [[NSMutableArray alloc] initWithCapacity:rowCount];
		[self ensureRowCacheUpTo:MIN(MAX(0, rowCount - 1), 5)]; // Cache the first chunk of rows
	}

	return self;
}

-(BOOL)boolForColumn:(NSString *)columnName {
	return [self boolForColumnIndex:[self columnIndexForName:columnName]];
}

-(BOOL)boolForColumnIndex:(int)columnIndex {
	return [((NSNumber *) [self valueAt:columnIndex]) boolValue];
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
	return [self valueAt:columnIndex] == [NSNull null];
}

-(BOOL)columnIsNull:(NSString *)columnName {
	return [self columnIndexIsNull:[self columnIndexForName:columnName]];
}

-(NSString *)columnNameForIndex:(int)columnIndex {
	return [self.resultSet columnNameForIndex:columnIndex];
}

-(NSData *)dataForColumnIndex:(int)columnIndex {
	return (NSData *)[self valueAt:columnIndex];
}

-(NSData *)dataForColumn:(NSString *)columnName {
	return [self dataForColumnIndex:[self columnIndexForName:columnName]];
}

-(NSDate *)dateForColumnIndex:(int)columnIndex {
	return (NSDate *)[self valueAt:columnIndex];
}

-(NSDate *)dateForColumn:(NSString *)columnName {
	return [self dateForColumnIndex:[self columnIndexForName:columnName]];
}

-(double)doubleForColumn:(NSString *)columnName {
	return [self doubleForColumnIndex:[self columnIndexForName:columnName]];
}

-(double)doubleForColumnIndex:(int)columnIndex {
	return [((NSNumber *) [self valueAt:columnIndex]) doubleValue];
}

-(void)ensureRowCacheUpTo:(uint)cachePosition {
	if ( (self.rowCache.count - 1) > cachePosition ) return;
	uint lastIndex = MIN(self.resultSetRowCount - 1, cachePosition);

	for ( uint i = 0; i < lastIndex; i++ ) {
		if ( ![self.resultSet next]) break;
		[self.rowCache addObject:[self.resultSet resultDictionary]];
	}
}

-(int)intForColumn:(NSString *)columnName {
	return [self intForColumnIndex:[self columnIndexForName:columnName]];
}

-(int)intForColumnIndex:(int)columnIndex {
	return [((NSNumber *) [self valueAt:columnIndex]) intValue];
}

-(long)longForColumn:(NSString *)columnName {
	return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

-(long)longForColumnIndex:(int)columnIndex {
	return [((NSNumber *)[self valueAt:columnIndex]) longValue];
}

-(long long int)longLongIntForColumn:(NSString *)columnName {
	return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

-(long long int)longLongIntForColumnIndex:(int)columnIndex {
	return [((NSNumber *)[self valueAt:columnIndex]) longLongValue];
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

-(BOOL)moveToPosition:(uint)position {
	if ( position < 0 || position >= self.resultSetRowCount ) return NO;
	[self ensureRowCacheUpTo:position];
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
	return [self stringForColumnIndex:[self columnIndexForName:columnName]];
}

-(NSString *)stringForColumnIndex:(int)columnIndex {
	return (NSString *)[self valueAt:columnIndex];
}

-(unsigned long long int)unsignedLongLongIntForColumn:(NSString *)columnName {
	return [self unsignedLongLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

-(unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIndex {
	return [((NSNumber *)[self valueAt:columnIndex]) unsignedLongLongValue];
}

-(id)valueAt:(int)columnIndex {
	return [self cachedRowAt:(uint)self.cursorPosition][[self columnNameForIndex:columnIndex]];
}


@end