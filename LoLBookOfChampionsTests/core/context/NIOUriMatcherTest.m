//
// NIOUriMatcherTest / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/25/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import <Kiwi/Kiwi.h>
#import "NIOUriMatcher.h"

#define CONTENT_AUTHORITY		@"content://io.nimblenoggin.lolbookofchampions.datadragon"
#define CONTENT_URI(path)		[[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:path]
#define URI_CHAMPIONS(path)		CONTENT_URI([@"champion/" stringByAppendingPathComponent:path])
#define URI_ALL_CHAMPIONS		URI_CHAMPIONS(@"")
#define URI_CHAMPION_BY_NAME	URI_CHAMPIONS(@"*")
#define URI_CHAMPION_BY_ID		URI_CHAMPIONS(@"#")
#define URI_CHAMPION_ITEMS		URI_CHAMPIONS(@"#/item")
#define URI_CHAMPION_ITEM		URI_CHAMPIONS(@"#/item/*")

#define ALL_CHAMPIONS			1
#define CHAMPION_FOR_NAME		2
#define CHAMPION_FOR_ID			3
#define ALL_ITEMS_FOR_CHAMPION	4
#define ITEM_FOR_CHAMPION		5


SPEC_BEGIN(UriMatcherSpec)
	describe(@"With an NIOUriMatcher", ^{
		__block NIOUriMatcher *uriMatcher;
		__block NSArray *uris = @[
				URI_ALL_CHAMPIONS,
				URI_CHAMPION_BY_NAME,
				URI_CHAMPION_BY_ID,
				URI_CHAMPION_ITEMS,
				URI_CHAMPION_ITEM
		];
		__block NSURL *nonMatchingUri;
		beforeEach(^{
			uriMatcher = [[NIOUriMatcher alloc] initWith:NO_MATCH];
			for ( int i = 1; i <= 5; i++ ) {
				[uriMatcher addURI:uris[(NSUInteger) i - 1] withMatchCode:i];
			}
			nonMatchingUri = [[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:@"game/12345"];
		});
		context(@"when matching URI's", ^{
			context(@"without wildcards", ^{
				it(@"it should match when passed a configured uri", ^{
					int match = [uriMatcher match:URI_ALL_CHAMPIONS];
					[[theValue(match) should] equal:theValue(ALL_CHAMPIONS)];
				});

				it(@"it should not match a non-matching uri", ^{
					int match = [uriMatcher match:nonMatchingUri];
					[[theValue(match) should] equal:theValue(NO_MATCH)];
				});
			});

			context(@"with wildcards", ^{
				__block NSURL *championByNameUri;
				__block NSURL *championByIdUri;
				__block NSURL *championItemsUri;
				__block NSURL *championItemUri;

				beforeEach(^{
					championByNameUri = [[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:@"champion/Aatrox"];
					championByIdUri = [[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:@"champion/123"];
					championItemsUri = [[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:@"champion/123/item"];
					championItemUri = [[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:@"champion/123/item/shield-1"];
				});

				it(@"it should match a configured Uri with an alpha wildcard", ^{
					int match = [uriMatcher match:championByNameUri];
					[[theValue(match) should] equal:theValue(CHAMPION_FOR_NAME)];
				});

				it(@"it should match a configured Uri with a numeric wildcard", ^{
					int match = [uriMatcher match:championByIdUri];
					[[theValue(match) should] equal:theValue(CHAMPION_FOR_ID)];
				});

				it(@"it should match a configured Uri with an alpha wildcard in the middle of the Uri", ^{
					int match = [uriMatcher match:championItemsUri];
					[[theValue(match) should] equal:theValue(ALL_ITEMS_FOR_CHAMPION)];
				});

				it(@"it should match a configured Uri with both an alpha and numeric uri", ^{
					int match = [uriMatcher match:championItemUri];
					[[theValue(match) should] equal:theValue(ITEM_FOR_CHAMPION)];
				});

				it(@"it should not match a numeric wildcard with a uri containing an alpha", ^{
					NSURL *uri = [[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:@"champion/Aatrox/item"];
					int match = [uriMatcher match:uri];
					[[theValue(match) should] equal:theValue(NO_MATCH)];
				});

				it(@"it should not match an alpha wildcard with a uri containing a numeric", ^{
					NSURL *uri = [[NSURL URLWithString:CONTENT_AUTHORITY] URLByAppendingPathComponent:@"champion/123/item/456"];
					int match = [uriMatcher match:uri];
					[[theValue(match) should] equal:theValue(NO_MATCH)];
				});
			});

		});
	});
SPEC_END