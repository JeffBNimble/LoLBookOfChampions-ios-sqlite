//
// NIOContentResolverTest / LoLBookOfChampions
//
// Created by Jeff Roberts on 2/25/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import <Kiwi/Kiwi.h>


SPEC_BEGIN(ContentResolverSpec)
	describe(@"With a content resolver", ^{
		context(@"when resolving content via a registered content uri", ^{
			context(@"and inserting content", ^{
				pending(@"it invokes insert on the content provider on the execution queue", ^{
				});

				pending(@"it invokes insert on the content provider registered for that content uri", ^{
				});

				pending(@"it passes the correct uri to the registered content provider", ^{
				});

				pending(@"it passes the correct insertable values to the registered content provider", ^{
				});

				pending(@"it returns a promise with a result", ^{
				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});

			context(@"and updating content", ^{
				pending(@"it invokes update on the content provider on the execution queue", ^{
				});

				pending(@"it invokes update on the content provider registered for that content uri", ^{
				});

				pending(@"it passes the correct uri to the registered content provider", ^{
				});

				pending(@"it passes the correct updateable values to the registered content provider", ^{
				});

				pending(@"it passes the correct selection to the registered content provider", ^{
				});

				pending(@"it passes the correct selectionArgs to the registered content provider", ^{
				});

				pending(@"it returns a promise with a result", ^{
				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});

			context(@"and deleting content", ^{
				pending(@"it invokes delete on the content provider on the execution queue", ^{
				});

				pending(@"it invokes delete on the content provider registered for that content uri", ^{
				});

				pending(@"it passes the correct uri to the registered content provider", ^{

				});

				pending(@"it passes the correct selection to the registered content provider", ^{

				});

				pending(@"it passes the correct selectionArgs to the registered content provider", ^{

				});

				pending(@"it returns a promise with a result", ^{

				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});

			context(@"and querying content", ^{
				pending(@"it invokes query on the content provider on the execution queue", ^{
				});

				pending(@"it invokes query on the content provider registered for that content uri", ^{
				});

				pending(@"it passes the correct uri to the registered content provider", ^{
				});

				pending(@"it passes the correct projection to the registered content provider", ^{
				});

				pending(@"it passes the correct selection to the registered content provider", ^{
				});

				pending(@"it passes the correct selectionArgs to the registered content provider", ^{
				});

				pending(@"it passes the correct groupBy to the registered content provider", ^{
				});

				pending(@"it passes the correct having clause to the registered content provider", ^{
				});

				pending(@"it passes the correct sort to the registered content provider", ^{
				});

				pending(@"it returns a promise with a result", ^{
				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});
		});

		context(@"when attempting to resolve content via an unregistered content uri", ^{
			context(@"and inserting content", ^{
				pending(@"it returns a promise containing an error describing an unmatched uri", ^{
				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});

			context(@"and updating content", ^{
				pending(@"it returns a promise containing an error describing an unmatched uri", ^{
				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});

			context(@"and deleting content", ^{
				pending(@"it returns a promise containing an error describing an unmatched uri", ^{
				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});

			context(@"and querying content", ^{
				pending(@"it returns a promise containing an error describing an unmatched uri", ^{
				});

				pending(@"it returns a promise on the completion queue", ^{
				});
			});
		});

		context(@"when retrieving a content provider for a registered uri", ^{
			pending(@"the correct content provider is returned", ^{
			});
		});

		context(@"when attempting to retrieve a content provider for an unregistered uri", ^{
			pending(@"no content provider is returned", ^{

			});
		});

		context(@"when registering for content observation change notifications", ^{
			context(@"and an observer does not want to be notified of descendent changes", ^{
				pending(@"a notification is received for an exact Uri match", ^{
				});

				pending(@"a notification is not received for a descendent Uri match", ^{
				});

				pending(@"a notification is not received for a non-matching Uri", ^{
				});

				pending(@"a notification is received on the completion queue", ^{
				});
			});

			context(@"and an observer does want to be notified of descendent changes", ^{
				pending(@"a notification is received for an exact Uri match", ^{
				});

				pending(@"a notification is received for a descendent Uri match", ^{
				});

				pending(@"a notification is not received for a non-matching Uri", ^{
				});
			});
		});
	});
SPEC_END