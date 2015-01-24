//
// NIOLoLApiRequestOperationManager / LoLBookOfChampions
//
// Created by Jeff Roberts on 1/23/15.
// Copyright (c) 2015 Riot Games. All rights reserved.
//


#import "NIOLoLApiRequestOperationManager.h"
#import "LoLApiConstants.h"

@interface NIOLoLApiRequestOperationManager ()
@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSString *apiVersion;
@property (strong, nonatomic) NSString *region;
@end

@implementation NIOLoLApiRequestOperationManager
-(instancetype)initWithBaseURL:(NSURL *)baseUrl
						apiKey:(NSString *)apiKey
						region:(NSString *)region
					apiVersion:(NSString *)apiVersion {
	self = [super initWithBaseURL:baseUrl];
	if ( self ) {
		self.apiKey = apiKey;
		self.apiVersion = apiVersion;
		self.region = region;
	}

	return self;
}

-(AFHTTPRequestOperation *)GET:(NSString *)URLString
					parameters:(id)parameters
					   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
					   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {

	return [super GET:[self absoluteURLStringWith:URLString]
		   parameters:[self addLoLParameters:parameters]
			  success:success
			  failure:failure];
}

-(NSString *)absoluteURLStringWith:(NSString *)urlString {
	NSString *resolvedURLString = [self resolvePlaceholdersInURLString:urlString];
	return [NSString stringWithFormat:@"%@%@", self.baseURL, resolvedURLString];
}

-(id)addLoLParameters:(id)parameters {
	if ( parameters == nil ) parameters = [NSMutableDictionary new];
	if ( [parameters isMemberOfClass:[NSDictionary class]] ) parameters = [NSMutableDictionary dictionaryWithDictionary:parameters];

	parameters[@"api_key"] = self.apiKey;

	return parameters;
}

-(NSString *)resolvePlaceholdersInURLString:(NSString *)urlString {
	NSString *resolvedURLString = [urlString stringByReplacingOccurrencesOfString:PLACEHOLDER_REGION
																	   withString:self.region];
	resolvedURLString = [resolvedURLString stringByReplacingOccurrencesOfString:PLACEHOLDER_API_VERSION
															 withString:self.apiVersion];
	return resolvedURLString;
}


@end