//
// NIOQueryTaskTest / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import <Kiwi/Kiwi.h>
#import "NIOContentResolver.h"
#import "NIOQueryTask.h"
#import "NIODataDragonContract.h"

SPEC_BEGIN(NIOQueryTaskSpec)
	describe(@"With a query task", ^{

		__block NIOContentResolver *mockContentResolver;
		__block NIOQueryTask *queryTask;
		__block BFTask *promise;

		context(@"when the query task is run", ^{

			beforeEach(^{
				mockContentResolver = [NIOContentResolver mock];
				queryTask = [[NIOQueryTask alloc] initWithContentResolver:mockContentResolver
                                                    withExecutionExecutor:[BFExecutor mainThreadExecutor]
                                                   withCompletionExecutor:[BFExecutor mainThreadExecutor]];
				promise = [BFTask taskWithResult:nil];
			});

			it(@"it should invoke the query through the content resolver", ^{
				[[mockContentResolver should]
						receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:)
					  andReturn:promise
				  withArguments:any(), any(), any(), any(), any(), any(), any()];
				[queryTask runAsync];
			});

			it(@"it should invoke the query passing the projection, selection, selectionArgs, group by, having and sort", ^{
				NSURL *uri = [Champion URI];
				NSArray *projection = @[[ChampionColumns COL_NAME], [ChampionColumns COL_TITLE]];
				NSString *selection = [NSString stringWithFormat:@"%@ = ?", [ChampionColumns COL_NAME]];
				NSArray *selectionArgs = @[@"Heimerdinger"];
				NSString *groupBy = nil;
				NSString *having = nil;
				NSString *sort = [NSString stringWithFormat:@"%@", [ChampionColumns COL_NAME]];

				queryTask.uri = uri;
				queryTask.projection = projection;
				queryTask.selection = selection;
				queryTask.selectionArgs = selectionArgs;
				queryTask.groupBy = groupBy;
				queryTask.having = having;
				queryTask.sort = sort;

				[[mockContentResolver should]
						receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
					  andReturn:promise
				  withArguments:uri, projection, selection, selectionArgs, groupBy, having, sort, any()];
				[queryTask runAsync];
			});

			it(@"it should return a promise when invoked", ^{
				[[mockContentResolver should]
                 receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
					  andReturn:promise
				  withArguments:any(), any(), any(), any(), any(), any(), any(), any()];
				BFTask *promiseResult = [queryTask runAsync];
				[[promiseResult shouldNot] beNil];
			});
		});
	});

SPEC_END