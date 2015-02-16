//
// Created by Jeff Roberts on 2/16/15.
// Copyright (c) 2015 io.nimblenoggin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NIOCursor <NSObject>
@required 
-(BOOL)boolForColumn:(NSString *)columnName;
-(BOOL)boolForColumnIndex:(int)columnIndex;
-(void)close;
-(int)columnCount;
-(int)columnIndexForName:(NSString *)columnName;
-(BOOL)columnIndexIsNull:(int)columnIndex;
-(BOOL)columnIsNull:(NSString *)columnName;
-(NSString *)columnNameForIndex:(int)columnIndex;
-(NSData *)dataForColumn:(NSString *)columnName;
-(NSData *)dataForColumnIndex:(int)columnIndex;
-(NSDate *)dateForColumn:(NSString *)columnName;
-(NSDate *)dateForColumnIndex:(int)columnIndex;
-(double)doubleForColumn:(NSString *)columnName;
-(double)doubleForColumnIndex:(int)columnIndex;
-(int)intForColumn:(NSString *)columnName;
-(int)intForColumnIndex:(int)columnIndex;
-(long)longForColumn:(NSString *)columnName;
-(long)longForColumnIndex:(int)columnIndex;
-(long long int)longLongIntForColumn:(NSString *)columnName;
-(long long int)longLongIntForColumnIndex:(int)columnIndex;
-(BOOL)move:(int)offset;
-(BOOL)moveToFirst;
-(BOOL)moveToLast;
-(BOOL)moveToPosition:(uint)position;
-(BOOL)next;
-(BOOL)previous;
-(NSUInteger)rowCount;
-(NSString *)stringForColumn:(NSString *)columnName;
-(NSString *)stringForColumnIndex:(int)columnIndex;
-(unsigned long long int)unsignedLongLongIntForColumn:(NSString *)columnName;
-(unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIndex;

@optional
-(NSData *)dataNoCopyForColumn:(NSString *)columnName NS_RETURNS_NOT_RETAINED;
-(NSData *)dataNoCopyForColumnIndex:(int)columnIndex NS_RETURNS_NOT_RETAINED;
-(id)objectForColumnName:(NSString *)columnName;
-(id)objectForColumnIndex:(int)columnIndex;
-(id)objectForKeyedSubscript:(NSString *)columnName;
-(id)objectAtIndexedSubscript:(int)columnIndex;
-(const unsigned char *)UTF8StringForColumnName:(NSString *)columnName;
-(const unsigned char *)UTF8StringForColumnIndex:(int)columnIndex;
@end