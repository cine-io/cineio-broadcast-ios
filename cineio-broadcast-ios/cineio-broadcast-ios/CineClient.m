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
#import "CineRecording.h"

@interface CineClient (PrivateMethods)
- (NSString *)url:(NSString *)endpoint;
- (NSDictionary *)params:(NSDictionary *)optionalParams;
@end

@implementation CineClient

@synthesize masterKey;
@synthesize projectSecretKey;

- (id)init
{
    if (self = [super init]) {
        _http = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        [_http.requestSerializer setValue:UserAgent forHTTPHeaderField:@"User-Agent"];
        _http.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)getProjectsWithCompletionHandler:(void (^)(NSError* error, NSArray* projects))completion
{
    NSAssert(masterKey != nil, @"masterKey must be set!");
    [_http GET:@"projects" parameters:@{ @"masterKey" : masterKey } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *projectDicts = (NSArray *)responseObject;
        NSMutableArray *projects = [[NSMutableArray alloc] initWithCapacity:[projectDicts count]];
        for (id object in projectDicts) {
            NSDictionary *projectDict = (NSDictionary *)object;
            CineProject *project = [[CineProject alloc] initWithAttributes:projectDict];
            [projects addObject:project];
        }
        completion(nil, [projects copy]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)getProjectWithCompletionHandler:(void (^)(NSError* error, CineProject* project))completion
{
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
    [_http GET:@"project" parameters:[self params:nil] success:^(AFHTTPRequestOperation *operation, id attributes) {
        CineProject *project = [[CineProject alloc] initWithAttributes:attributes];
        completion(nil, project);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)getStreamsWithCompletionHandler:(void (^)(NSError* error, NSArray* streams))completion
{
    [self getStreams:nil withCompletionHandler:completion];
}

- (void)getStreamsForName:(NSString *)name withCompletionHandler:(void (^)(NSError* error, NSArray* streams))completion
{
    [self getStreams:@{@"name" : name} withCompletionHandler:completion];
}

- (void)getStreams:(NSDictionary *)attributes withCompletionHandler:(void (^)(NSError* error, NSArray* streams))completion
{
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
    [_http GET:@"streams" parameters:[self params:attributes] success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
    [_http GET:@"stream" parameters:[self params:@{@"id" : streamId}] success:^(AFHTTPRequestOperation *operation, id attributes) {
        CineStream *stream = [[CineStream alloc] initWithAttributes:attributes];
        completion(nil, stream);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)createStream:(NSDictionary *)attributes withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion
{
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
    [_http POST:@"stream" parameters:[self params:attributes] success:^(AFHTTPRequestOperation *operation, id attrs) {
        CineStream *stream = [[CineStream alloc] initWithAttributes:attrs];
        completion(nil, stream);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)updateStream:(NSDictionary *)attributes withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion
{
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
   [_http PUT:@"stream" parameters:[self params:attributes] success:^(AFHTTPRequestOperation *operation, id attrs) {
        CineStream *stream = [[CineStream alloc] initWithAttributes:attrs];
        completion(nil, stream);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)deleteStream:(NSString *)streamId withCompletionHandler:(void (^)(NSError* error, NSHTTPURLResponse* response))completion
{
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
    [_http DELETE:@"stream" parameters:[self params:@{@"id" : streamId}] success:^(AFHTTPRequestOperation *operation, id attributes) {
        completion(nil, operation.response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)getStreamRecordings:(NSString *)streamId withCompletionHandler:(void (^)(NSError* error, NSArray* recordings))completion
{
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
    [_http GET:@"stream/recordings" parameters:[self params:@{@"id" : streamId}] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *recordingDicts = (NSArray *)responseObject;
        NSMutableArray *recordings = [[NSMutableArray alloc] initWithCapacity:[recordingDicts count]];
        for (id object in recordingDicts) {
            NSDictionary *recordingDict = (NSDictionary *)object;
            CineRecording *recording = [[CineRecording alloc] initWithAttributes:recordingDict];
            [recordings addObject:recording];
        }
        completion(nil, [recordings copy]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (void)deleteStreamRecording:(NSString *)streamId withName:(NSString *)name andCompletionHandler:(void (^)(NSError* error, NSHTTPURLResponse* response))completion
{
    NSAssert(projectSecretKey != nil, @"projectSecretKey must be set!");
    [_http DELETE:@"stream/recording" parameters:[self params:@{@"id" : streamId, @"name" : name}] success:^(AFHTTPRequestOperation *operation, id attributes) {
        completion(nil, operation.response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error, nil);
    }];
}

- (NSDictionary *)params:(NSDictionary *)optionalParams
{
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    [allParams addEntriesFromDictionary:@{ @"secretKey" : projectSecretKey }];
    if (optionalParams) [allParams addEntriesFromDictionary:optionalParams];

    return allParams;
}

@end
