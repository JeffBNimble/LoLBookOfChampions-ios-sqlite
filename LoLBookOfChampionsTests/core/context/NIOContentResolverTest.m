//
// NIOContentResolverTest / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/25/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import <Kiwi/Kiwi.h>
#import "NIOContentResolver.h"
#import "NIOContentProviderFactory.h"
#import "NIOContentObserver.h"
#import "NIOMockContentProvider.h"
#import "NIOMockContentObserver.h"


SPEC_BEGIN(ContentResolverSpec)
	describe(@"With an NIOContentResolver", ^{
		__block NSString *dataDragonContentPath;
		__block NSString *gameContentPath;
		__block id mockContentProviderFactory;
		__block id mockContentProvider;
		__block id mockCursor;
		__block NIOMockContentProvider *contentProvider;
		__block NSString *contentAuthorityBase;
		__block dispatch_queue_t executionQueue;
		__block dispatch_queue_t completionQueue;
		__block NIOContentResolver *contentResolver;
		beforeEach(^{
			dataDragonContentPath = @"dataDragon";
			gameContentPath = @"game";
			mockContentProviderFactory = [KWMock mockForProtocol:@protocol(NIOContentProviderFactory)];
			mockContentProvider = [KWMock nullMockForProtocol:@protocol(NIOContentProvider)];
			mockCursor = [KWMock nullMockForProtocol:@protocol(NIOCursor)];
			contentProvider = [[NIOMockContentProvider alloc] init];
			contentAuthorityBase = @"io.nimblenoggin.lolbookofchampions";
			executionQueue = dispatch_queue_create("test_execution_queue", DISPATCH_QUEUE_SERIAL);
			completionQueue = dispatch_queue_create("test_completion_queue", DISPATCH_QUEUE_SERIAL);
			contentResolver = [[NIOContentResolver alloc]
					initWithContentProviderFactory:mockContentProviderFactory
						  withContentAuthorityBase:contentAuthorityBase
								 withRegistrations:@{
										 dataDragonContentPath : @"NSObject",
										 gameContentPath       : @"NIOMockContentProvider"
								 }
								withExecutionQueue:executionQueue
							   withCompletionQueue:completionQueue];

			// Stubs
			[mockContentProviderFactory stub:@selector(createContentProviderWithType:)
								   andReturn:mockContentProvider
							   withArguments:[NSObject class]];
			[mockContentProviderFactory stub:@selector(createContentProviderWithType:)
								   andReturn:contentProvider
							   withArguments:[NIOMockContentProvider class]];
		});
		context(@"when resolving content via a registered content uri", ^{
			__block NSURL *insertUri;
			context(@"and inserting content", ^{
				beforeEach(^{
					insertUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, dataDragonContentPath, @"champion"]];
				});
				context(@"successfully", ^{
					beforeEach(^{
						[mockContentProvider stub:@selector(insertWithURI:withValues:withError:) andReturn:[BFTask taskWithResult:insertUri] withArguments:any(), any(), any()];
					});

					it(@"it invokes insert on the content provider on the execution queue", ^{
						insertUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
						[contentResolver insertWithURI:insertUri withValues:@{}];
						[[expectFutureValue(contentProvider.executionQueue.description) shouldEventually] equal: executionQueue.description];
					});

					it(@"it invokes insert on the content provider registered for that content uri", ^{
						[[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(insertWithURI:withValues:withError:) withArguments:any(), any(), any()];
						[contentResolver insertWithURI:insertUri withValues:@{}];
					});

					it(@"it passes the correct uri to the registered content provider", ^{
						[[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(insertWithURI:withValues:withError:) withArguments:insertUri, any(), any()];
						[contentResolver insertWithURI:insertUri withValues:@{}];
					});

					it(@"it passes the correct insertable values to the registered content provider", ^{
						NSDictionary *values = @{@"someKey":@"someValue"};
						[[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(insertWithURI:withValues:withError:) withArguments:any(), values, any()];
						[contentResolver insertWithURI:insertUri withValues:values];
					});

					it(@"it returns a promise with a result", ^{
						BFTask *promise = [contentResolver insertWithURI:insertUri withValues:@{}];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.result) shouldNotEventually] beNil];
					});

					it(@"it sets the promise result on the completion queue", ^{
						[[[contentResolver insertWithURI:insertUri withValues:@{}]
								continueWithBlock:^id(BFTask *task) {
									NSString *completionQueueName = completionQueue.description;
									NSString *thisQueueName = dispatch_get_current_queue().description;
									[[thisQueueName should] equal:completionQueueName];
									return nil;
								}] waitUntilFinished];
					});
				});

				context(@"unsuccessfully", ^{
					beforeEach(^{
						insertUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
						NSError *error = [NSError errorWithDomain:@"fail" code:99 userInfo:nil];
						contentProvider.failWithError = error;
					});

					it(@"returns a promise with an error", ^{
						BFTask *promise = [contentResolver insertWithURI:insertUri withValues:@{}];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.error) shouldNotEventually] beNil];
					});
				});
			});

			context(@"and updating content", ^{
				__block NSURL *updateUri;
				beforeEach(^{
					updateUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, dataDragonContentPath, @"champion"]];
				});
				context(@"successfully", ^{
					beforeEach(^{
						[mockContentProvider stub:@selector(updateWithURI:withSelection:withSelectionArgs:withError:) andReturn:[BFTask taskWithResult:@(27)] withArguments:any(), any(), any(), any()];
					});

					it(@"it invokes update on the content provider on the execution queue", ^{
						updateUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
						[contentResolver updateWithURI:updateUri withValues:nil withSelection:nil withSelectionArgs:nil];
						[[expectFutureValue(contentProvider.executionQueue.description) shouldEventually] equal: executionQueue.description];
					});

					it(@"it invokes update on the content provider registered for that content uri", ^{
						[[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(updateWithURI:withValues:withSelection:withSelectionArgs:withError:) withArguments:any(), any(), any(), any(), any()];
						[contentResolver updateWithURI:updateUri withValues:nil withSelection:nil withSelectionArgs:nil];
					});

					it(@"it passes the correct uri to the registered content provider", ^{
						[[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(updateWithURI:withValues:withSelection:withSelectionArgs:withError:) withArguments:updateUri, any(), any(), any(), any()];
						[contentResolver updateWithURI:updateUri withValues:nil withSelection:nil withSelectionArgs:nil];
					});

					it(@"it passes the correct updateable values to the registered content provider", ^{
                        NSDictionary *values = @{@"someColumn":@"someValue"};
                        [[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(updateWithURI:withValues:withSelection:withSelectionArgs:withError:) withArguments:any(), values, any(), any(), any()];
                        [contentResolver updateWithURI:updateUri withValues:values withSelection:nil withSelectionArgs:nil];
					});

					it(@"it passes the correct selection to the registered content provider", ^{
						NSString *selection = @"someColumn = ?";
						[[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(updateWithURI:withValues:withSelection:withSelectionArgs:withError:) withArguments:any(), any(), selection, any(), any()];
						[contentResolver updateWithURI:updateUri withValues:nil withSelection:selection withSelectionArgs:nil];
					});

					it(@"it passes the correct selectionArgs to the registered content provider", ^{
						NSArray *selectionArgs = @[@"someValue"];
						[[expectFutureValue(mockContentProvider) shouldEventually] receive:@selector(updateWithURI:withValues:withSelection:withSelectionArgs:withError:) withArguments:any(), any(), any(), selectionArgs, any()];
						[contentResolver updateWithURI:updateUri withValues:nil withSelection:nil withSelectionArgs:selectionArgs];
					});

					it(@"it returns a promise with a result", ^{
						BFTask *promise = [contentResolver updateWithURI:updateUri withValues:nil withSelection:nil withSelectionArgs:nil];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.result) shouldNotEventually] beNil];
					});

					it(@"it returns a promise on the completion queue", ^{
						[[[contentResolver updateWithURI:updateUri withValues:nil withSelection:nil withSelectionArgs:nil]
								continueWithBlock:^id(BFTask *task) {
									NSString *completionQueueName = completionQueue.description;
									NSString *thisQueueName = dispatch_get_current_queue().description;
									[[thisQueueName should] equal:completionQueueName];
									return nil;
								}] waitUntilFinished];
					});
				});
				context(@"unsuccessfully", ^{
					beforeEach(^{
						updateUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
						NSError *error = [NSError errorWithDomain:@"fail" code:99 userInfo:nil];
						contentProvider.failWithError = error;
					});

					it(@"returns a promise with an error", ^{
						BFTask *promise = [contentResolver updateWithURI:updateUri withValues:nil withSelection:nil withSelectionArgs:nil];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.error) shouldNotEventually] beNil];
					});
				});
			});

			context(@"and deleting content", ^{
				__block NSURL *deleteUri;
				beforeEach(^{
					deleteUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, dataDragonContentPath, @"champion"]];
				});
				context(@"successfully", ^{
					beforeEach(^{
						[mockContentProvider stub:@selector(updateWithURI:withSelection:withSelectionArgs:withError:)
										andReturn:[BFTask taskWithResult:@(27)]
									withArguments:any(),
												  any(),
												  any(),
												  any()];
					});

					it(@"it invokes delete on the content provider on the execution queue", ^{
						deleteUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@",
																					contentAuthorityBase,
																					gameContentPath,
																					@"stats"]];
						[contentResolver deleteWithURI:deleteUri withSelection:nil withSelectionArgs:nil];
						[[expectFutureValue(contentProvider.executionQueue.description)
								shouldEventually]
								equal:executionQueue.description];
					});

					it(@"it invokes delete on the content provider registered for that content uri", ^{
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(deleteWithURI:withSelection:withSelectionArgs:withError:)
						  withArguments:any(),
										any(),
										any(),
										any()];
						[contentResolver deleteWithURI:deleteUri withSelection:nil withSelectionArgs:nil];
					});

					it(@"it passes the correct uri to the registered content provider", ^{
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(deleteWithURI:withSelection:withSelectionArgs:withError:)
						  withArguments:deleteUri, any(), any(), any()];
						[contentResolver deleteWithURI:deleteUri withSelection:nil withSelectionArgs:nil];
					});

					it(@"it passes the correct selection to the registered content provider", ^{
						NSString *selection = @"someColumn = ?";
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(deleteWithURI:withSelection:withSelectionArgs:withError:)
						  withArguments:any(),
										selection,
										any(),
										any()];
						[contentResolver deleteWithURI:deleteUri withSelection:selection withSelectionArgs:nil];
					});

					it(@"it passes the correct selectionArgs to the registered content provider", ^{
						NSArray *selectionArgs = @[@"someValue"];
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(deleteWithURI:withSelection:withSelectionArgs:withError:)
						  withArguments:any(),
										any(),
										selectionArgs,
										any()];
						[contentResolver deleteWithURI:deleteUri withSelection:nil withSelectionArgs:selectionArgs];
					});

					it(@"it returns a promise with a result", ^{
						BFTask *promise = [contentResolver deleteWithURI:deleteUri
														   withSelection:nil
													   withSelectionArgs:nil];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.result) shouldNotEventually] beNil];
					});

					it(@"it returns a promise on the completion queue", ^{
						[[[contentResolver deleteWithURI:deleteUri withSelection:nil withSelectionArgs:nil]
								continueWithBlock:^id(BFTask *task) {
									NSString *completionQueueName = completionQueue.description;
									NSString *thisQueueName = dispatch_get_current_queue().description;
									[[thisQueueName should] equal:completionQueueName];
									return nil;
								}] waitUntilFinished];
					});
				});
				context(@"unsuccessfully", ^{
					beforeEach(^{
						deleteUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
						NSError *error = [NSError errorWithDomain:@"fail" code:99 userInfo:nil];
						contentProvider.failWithError = error;
					});

					it(@"returns a promise with an error", ^{
						BFTask *promise = [contentResolver deleteWithURI:deleteUri withSelection:nil withSelectionArgs:nil];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.error) shouldNotEventually] beNil];
					});
				});
			});

			context(@"and querying content", ^{
				__block NSURL *queryUri;
				beforeEach(^{
					queryUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, dataDragonContentPath, @"champion"]];
				});
				context(@"successfully", ^{
					beforeEach(^{
						[mockContentProvider stub:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
										andReturn:[BFTask taskWithResult:mockCursor]
									withArguments:any(),
												  any(),
												  any(),
												  any(),
												  any(),
												  any(),
												  any(),
												  any()];
					});
					it(@"it invokes query on the content provider on the execution queue", ^{
						queryUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@",
																					contentAuthorityBase,
																					gameContentPath,
																					@"stats"]];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:nil
									withSelectionArgs:nil
										  withGroupBy:nil
										   withHaving:nil
											 withSort:nil];
						[[expectFutureValue(contentProvider.executionQueue.description)
								shouldEventually]
								equal:executionQueue.description];
					});

					it(@"it invokes query on the content provider registered for that content uri", ^{
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:any(),
										any(),
										any(),
										any(),
										any(),
										any(),
										any(),
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:nil
									withSelectionArgs:nil
										  withGroupBy:nil
										   withHaving:nil
											 withSort:nil];
					});

					it(@"it passes the correct uri to the registered content provider", ^{
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:queryUri,
										any(),
										any(),
										any(),
										any(),
										any(),
										any(),
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:nil
									withSelectionArgs:nil
										  withGroupBy:nil
										   withHaving:nil
											 withSort:nil];
					});

					it(@"it passes the correct projection to the registered content provider", ^{
						NSArray *projection = @[@"*"];
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:any(),
										projection,
										any(),
										any(),
										any(),
										any(),
										any(),
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:projection
										withSelection:nil
									withSelectionArgs:nil
										  withGroupBy:nil
										   withHaving:nil
											 withSort:nil];
					});

					it(@"it passes the correct selection to the registered content provider", ^{
						NSString *selection = @"someColumn = ?";
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:any(),
										any(),
										selection,
										any(),
										any(),
										any(),
										any(),
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:selection
									withSelectionArgs:nil
										  withGroupBy:nil
										   withHaving:nil
											 withSort:nil];
					});

					it(@"it passes the correct selectionArgs to the registered content provider", ^{
						NSArray *selectionArgs = @[];
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:any(),
										any(),
										any(),
										selectionArgs,
										any(),
										any(),
										any(),
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:nil
									withSelectionArgs:selectionArgs
										  withGroupBy:nil
										   withHaving:nil
											 withSort:nil];
					});

					it(@"it passes the correct groupBy to the registered content provider", ^{
						NSString *groupBy = @"someColumn";
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:any(),
										any(),
										any(),
										any(),
										groupBy,
										any(),
										any(),
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:nil
									withSelectionArgs:nil
										  withGroupBy:groupBy
										   withHaving:nil
											 withSort:nil];
					});

					it(@"it passes the correct having clause to the registered content provider", ^{
						NSString *having = @"x > 25";
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:any(),
										any(),
										any(),
										any(),
										any(),
										having,
										any(),
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:nil
									withSelectionArgs:nil
										  withGroupBy:nil
										   withHaving:having
											 withSort:nil];
					});

					it(@"it passes the correct sort to the registered content provider", ^{
						NSString *sort = @"someColumm ASC";
						[[expectFutureValue(mockContentProvider)
								shouldEventually]
								receive:@selector(queryWithURI:withProjection:withSelection:withSelectionArgs:withGroupBy:withHaving:withSort:withError:)
						  withArguments:any(),
										any(),
										any(),
										any(),
										any(),
										any(),
										sort,
										any()];
						[contentResolver queryWithURI:queryUri
									   withProjection:nil
										withSelection:nil
									withSelectionArgs:nil
										  withGroupBy:nil
										   withHaving:nil
											 withSort:sort];
					});

					it(@"it returns a promise with a result", ^{
						BFTask *promise = [contentResolver queryWithURI:queryUri
														 withProjection:nil
														  withSelection:nil
													  withSelectionArgs:nil
															withGroupBy:nil
															 withHaving:nil
															   withSort:nil];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.result) shouldNotEventually] beNil];
					});

					it(@"it returns a promise on the completion queue", ^{
						[[[contentResolver queryWithURI:queryUri
										 withProjection:nil
										  withSelection:nil
									  withSelectionArgs:nil
											withGroupBy:nil
											 withHaving:nil
											   withSort:nil]
								continueWithBlock:^id(BFTask *task) {
									NSString *completionQueueName = completionQueue.description;
									NSString *thisQueueName = dispatch_get_current_queue().description;
									[[thisQueueName should] equal:completionQueueName];
									return nil;
								}] waitUntilFinished];
					});
				});
				context(@"unsuccessfully", ^{
					beforeEach(^{
						queryUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
						NSError *error = [NSError errorWithDomain:@"fail" code:99 userInfo:nil];
						contentProvider.failWithError = error;
					});

					it(@"returns a promise with an error", ^{
						BFTask *promise = [contentResolver queryWithURI:queryUri
														 withProjection:nil
														  withSelection:nil
													  withSelectionArgs:nil
															withGroupBy:nil
															 withHaving:nil
															   withSort:nil];
						[[promise shouldNot] beNil];
						[[expectFutureValue(promise.error) shouldNotEventually] beNil];
					});
				});
			});
		});

		context(@"when attempting to resolve content via an unregistered content uri", ^{
			__block NSURL *badUri;
			beforeEach(^{
				badUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, @"nothingHere", @"bad"]];
			});
			context(@"and inserting content", ^{
				it(@"it returns a promise containing an error describing an unmatched uri", ^{
					BFTask *promise = [contentResolver insertWithURI:badUri withValues:@{}];
					[[expectFutureValue(promise.error) shouldNotEventually] beNil];
				});

				it(@"it returns a promise on the completion queue", ^{
					[[[contentResolver insertWithURI:badUri withValues:@{}]
							continueWithBlock:^id(BFTask *task) {
								NSString *completionQueueName = completionQueue.description;
								NSString *thisQueueName = dispatch_get_current_queue().description;
								[[thisQueueName should] equal:completionQueueName];
								return nil;
							}] waitUntilFinished];
				});
			});

			context(@"and updating content", ^{
				it(@"it returns a promise containing an error describing an unmatched uri", ^{
					BFTask *promise = [contentResolver updateWithURI:badUri withValues:nil withSelection:nil withSelectionArgs:nil];
					[[expectFutureValue(promise.error) shouldNotEventually] beNil];
				});

				it(@"it returns a promise on the completion queue", ^{
					[[[contentResolver updateWithURI:badUri withValues:nil withSelection:nil withSelectionArgs:nil]
							continueWithBlock:^id(BFTask *task) {
								NSString *completionQueueName = completionQueue.description;
								NSString *thisQueueName = dispatch_get_current_queue().description;
								[[thisQueueName should] equal:completionQueueName];
								return nil;
							}] waitUntilFinished];
				});
			});

			context(@"and deleting content", ^{
				it(@"it returns a promise containing an error describing an unmatched uri", ^{
					BFTask *promise = [contentResolver deleteWithURI:badUri withSelection:nil withSelectionArgs:nil];
					[[expectFutureValue(promise.error) shouldNotEventually] beNil];
				});

				it(@"it returns a promise on the completion queue", ^{
					[[[contentResolver deleteWithURI:badUri withSelection:nil withSelectionArgs:nil]
							continueWithBlock:^id(BFTask *task) {
								NSString *completionQueueName = completionQueue.description;
								NSString *thisQueueName = dispatch_get_current_queue().description;
								[[thisQueueName should] equal:completionQueueName];
								return nil;
							}] waitUntilFinished];
				});
			});

			context(@"and querying content", ^{
				it(@"it returns a promise containing an error describing an unmatched uri", ^{
					BFTask *promise = [contentResolver queryWithURI:badUri
													 withProjection:nil
													  withSelection:nil
												  withSelectionArgs:nil
														withGroupBy:nil
														 withHaving:nil
														   withSort:nil];
					[[expectFutureValue(promise.error) shouldNotEventually] beNil];
				});

				it(@"it returns a promise on the completion queue", ^{
					[[[contentResolver queryWithURI:badUri
									 withProjection:nil
									  withSelection:nil
								  withSelectionArgs:nil
										withGroupBy:nil
										 withHaving:nil
										   withSort:nil]
							continueWithBlock:^id(BFTask *task) {
								NSString *completionQueueName = completionQueue.description;
								NSString *thisQueueName = dispatch_get_current_queue().description;
								[[thisQueueName should] equal:completionQueueName];
								return nil;
							}] waitUntilFinished];
				});
			});
		});

		context(@"when retrieving a content provider for a registered uri", ^{
			it(@"the correct content provider is returned", ^{
				NSURL *uri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
				id cp = [contentResolver getContentProviderForContentURI:uri];
				[[cp should] beIdenticalTo:contentProvider];
			});
		});

		context(@"when attempting to retrieve a content provider for an unregistered uri", ^{
			it(@"no content provider is returned", ^{
				NSURL *badUri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, @"badUriPath", @"reallyBad"]];
				id cp = [contentResolver getContentProviderForContentURI:badUri];
				[[cp should] beNil];
			});
		});

		context(@"when registering for content observation change notifications", ^{
			__block NIOMockContentObserver *mockContentObserver;
			__block NSURL *uri;
			beforeEach(^{
				uri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"stats"]];
				mockContentObserver = [NIOMockContentObserver new];
			});
			context(@"and an observer does not want to be notified of descendent changes", ^{
				beforeEach(^{
					[contentResolver registerContentObserverWithContentURI:uri
												  withNotifyForDescendents:NO
													   withContentObserver:mockContentObserver];
				});

				it(@"a notification is received for an exact Uri match", ^{
					[contentResolver notifyChange:uri];
					[[expectFutureValue(theValue(mockContentObserver.didReceiveUriUpdateNotification)) shouldEventually] beTrue];
				});

				it(@"a notification is not received for a descendent Uri match", ^{
					[contentResolver notifyChange:[uri URLByAppendingPathComponent:@"123"]];
					[[expectFutureValue(theValue(mockContentObserver.didReceiveUriUpdateNotification)) shouldEventually] beFalse];
				});

				it(@"a notification is not received for a non-matching Uri", ^{
					uri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"game"]];
					[contentResolver notifyChange:uri];
					[[expectFutureValue(theValue(mockContentObserver.didReceiveUriUpdateNotification)) shouldEventually] beFalse];
				});

                it(@"a notification is received on the completion queue", ^{
                    [contentResolver notifyChange:uri];
                    [[expectFutureValue(mockContentObserver.completionQueue.description) shouldEventually] equal:completionQueue.description];
                });
			});

			context(@"and an observer does want to be notified of descendent changes", ^{
				beforeEach(^{
					[contentResolver registerContentObserverWithContentURI:uri
												  withNotifyForDescendents:YES
													   withContentObserver:mockContentObserver];
				});
				it(@"a notification is received for an exact Uri match", ^{
					[contentResolver notifyChange:uri];
					[[expectFutureValue(theValue(mockContentObserver.didReceiveUriUpdateNotification)) shouldEventually] beTrue];
				});

				it(@"a notification is received for a descendent Uri match", ^{
					[contentResolver notifyChange:[uri URLByAppendingPathComponent:@"123"]];
					[[expectFutureValue(theValue(mockContentObserver.didReceiveUriUpdateNotification)) shouldEventually] beTrue];
				});

				it(@"a notification is not received for a non-matching Uri", ^{
					uri = [NSURL URLWithString:[NSString stringWithFormat:@"content://%@.%@/%@", contentAuthorityBase, gameContentPath, @"game"]];
					[contentResolver notifyChange:uri ];
					[[expectFutureValue(theValue(mockContentObserver.didReceiveUriUpdateNotification)) shouldEventually] beFalse];
				});
			});
		});
	});
SPEC_END