//
//  CineClient.m
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineClient.h"
#import "CineConstants.h"
#import "CineStream.h"

@interface CineClient (PrivateMethods)
- (NSString *)url:(NSString *)endpoint;
- (NSDictionary *)params:(NSDictionary *)optionalParams;
@end

@implementation CineClient

- (id)initWithSecretKey:(NSString *)secretKey
{
    if (self = [super init]) {
        _secretKey = secretKey;
        _http = [AFHTTPRequestOperationManager manager];
        _http.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)getProjectWithCompletionHandler:(void (^)(NSError* error, CineProject* project))completion
{
    [_http GET:[self url:@"/project"] parameters:[self params:nil] success:^(AFHTTPRequestOperation *operation, id attributes) {
        CineProject *project = [[CineProject alloc] initWithAttributes:attributes];
        completion(nil, project);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)getStreamsWithCompletionHandler:(void (^)(NSError* error, NSArray* streams))completion
{
    [_http GET:[self url:@"/streams"] parameters:[self params:nil] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *streamDicts = (NSArray *)responseObject;
        NSMutableArray *streams = [[NSMutableArray alloc] initWithCapacity:[streamDicts count]];
        for (id object in streamDicts) {
            NSDictionary *streamDict = (NSDictionary *)object;
            CineStream *stream = [[CineStream alloc] initWithAttributes:streamDict];
            [streams addObject:stream];
        }
        completion(nil, [streams copy]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)getStream:(NSString *)streamId withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion
{
    [_http GET:[self url:@"/stream"] parameters:[self params:@{@"id" : streamId}] success:^(AFHTTPRequestOperation *operation, id attributes) {
        CineStream *stream = [[CineStream alloc] initWithAttributes:attributes];
        completion(nil, stream);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)createStream:(NSDictionary *)attributes withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion
{
    [_http POST:[self url:@"/stream"] parameters:[self params:attributes] success:^(AFHTTPRequestOperation *operation, id attributes) {
        CineStream *stream = [[CineStream alloc] initWithAttributes:attributes];
        completion(nil, stream);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (NSString *)url:(NSString *)endpoint
{
    return [NSString stringWithFormat:@"%@%@", BaseUrl, endpoint];
}

- (NSDictionary *)params:(NSDictionary *)optionalParams
{
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    [allParams addEntriesFromDictionary:@{ @"secretKey" : _secretKey }];
    if (optionalParams) [allParams addEntriesFromDictionary:optionalParams];

    return allParams;
}

@end
