//
// NIOClearLocalDataDragonDataTaskTest / LoLBookOfChampions
//
// Created by Jeff Roberts on 3/3/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import <Kiwi/Kiwi.h>
#import "NIOClearLocalDataDragonDataTask.h"
#import "NIOContentResolver.h"
#import "NIODataDragonContract.h"


SPEC_BEGIN(NIOClearLocalDataDragonDataTaskSpec)
	describe(@"With a ClearLocalDataDragonDataTask", ^{
		context(@"when executing the task", ^{
			__block NIOContentResolver *mockContentResolver;
			__block NSURLCache *mockURLCache;
			__block NIOClearLocalDataDragonDataTask *task;
			__block BFTask *promise;

			beforeEach(^{
				mockContentResolver = [NIOContentResolver mock];
				mockURLCache = [NSURLCache nullMock];
				task = [[NIOClearLocalDataDragonDataTask alloc]
						initWithContentResolver:mockContentResolver
							 withSharedURLCache:mockURLCache];
				promise = [BFTask taskWithResult:nil];

				// Stub out the content resolver
				[mockContentResolver stub:@selector(deleteWithURI:withSelection:withSelectionArgs:)
								andReturn:promise
							withArguments:any(), any(), any()];
			});

			it(@"it clears the shared disk cache", ^{
				[[expectFutureValue(mockURLCache) shouldEventually] receive:@selector(removeAllCachedResponses)];
				[task runAsync];
			});

			it(@"it deletes the data dragon realm data", ^{
				[[expectFutureValue(mockContentResolver) shouldEventually]
						receive:@selector(deleteWithURI:withSelection:withSelectionArgs:)
				  withArguments:[Realm URI], any(), any()];
				[task runAsync];
			});

			it(@"it deletes the data dragon champion data", ^{
				[[expectFutureValue(mockContentResolver) shouldEventually]
						receive:@selector(deleteWithURI:withSelection:withSelectionArgs:)
				  withArguments:[Champion URI], any(), any()];
				[task runAsync];
			});

			pending(@"it deletes the data dragon champion skin data", ^{

			});

			pending(@"it returns a promise", ^{

			});
		});
	});
SPEC_END