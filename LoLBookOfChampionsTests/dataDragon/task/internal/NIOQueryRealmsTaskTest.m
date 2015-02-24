//
// NIOQueryRealmsTaskTest / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/24/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <FMDB/FMDB.h>
#import "NIOQueryRealmsTask.h"
#import "NIOCursor.h"

SPEC_BEGIN(NIOQueryRealmsTaskSpec)
	describe(@"With a query realms task", ^{
		__block FMDatabase *mockDatabase;
		__block NIOQueryRealmsTask *queryRealmsTask;
		__block FMResultSet *mockQueryCountResultSet;
		__block FMResultSet *mockQueryResultSet;

		beforeEach(^{
			mockDatabase = [FMDatabase nullMock];
			mockQueryCountResultSet = [FMResultSet nullMock];
			mockQueryResultSet = [FMResultSet nullMock];
			queryRealmsTask = [[NIOQueryRealmsTask alloc] initWithDatabase:mockDatabase];

			// Stub the count query result set so that it returns a row count
			[mockQueryCountResultSet stub:@selector(next) andReturn:theValue(true)];
			[mockQueryCountResultSet stub:@selector(intForColumnIndex:) andReturn:theValue(27) withArguments:theValue(0)];

			// Stub the database invocation of the query so that it returns a result set
			NSString *sqlStatement = [NSString stringWithFormat:@"%@%@%@%@", SELECT, @"*", FROM, queryRealmsTask.table];
			[mockDatabase stub:@selector(executeQuery:) andReturn:mockQueryResultSet withArguments:sqlStatement];
		});

		context(@"when the query is run", ^{
			it(@"it should invoke a count query against the database to get the result set row count", ^{
				NSString *sqlStatement = [NSString stringWithFormat:@"%@%@%@%@", SELECT, COUNT, FROM, queryRealmsTask.table];
				[[mockDatabase should]
						receive:@selector(executeQuery:)
					  andReturn:mockQueryCountResultSet
					  withCount:1
					  arguments:sqlStatement];
				[queryRealmsTask runAsync];
			});

			it(@"it should return a promise whose result contains the correct result set row count", ^{
				NSString *sqlStatement = [NSString stringWithFormat:@"%@%@%@%@", SELECT, COUNT, FROM, queryRealmsTask.table];
				[mockDatabase stub:@selector(executeQuery:) andReturn:mockQueryCountResultSet withArguments:sqlStatement];
				BFTask *promise = [queryRealmsTask runAsync];
				id<NIOCursor> cursor = promise.result;
				[[theValue(cursor.rowCount) should] equal:theValue(27)];
			});
		});
	});


SPEC_END