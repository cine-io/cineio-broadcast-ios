//
//  CineProject.m
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineProject.h"
#import "CineConstants.h"
#import "CineStream.h"
#import <AFNetworking/AFNetworking.h>

@implementation CineProject

@synthesize projectId;
@synthesize publicKey;
@synthesize secretKey;
@synthesize name;
@synthesize streamsCount;
@synthesize updatedAt;

- (id)initWithAttributes:(NSDictionary *)streamAttributes
{
    if (self = [super init]) {
        projectId = streamAttributes[@"id"];
        publicKey = streamAttributes[@"publicKey"];
        secretKey = streamAttributes[@"secretKey"];
        name = streamAttributes[@"name"];
        streamsCount = [streamAttributes[@"streamsCount"] integerValue];
        updatedAt = streamAttributes[@"updatedAt"];
    }
    
    return self;
}

- (void)getStreams:(void (^)(NSError* error, NSArray* streams))completion;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseUrl, @"/streams"];
    NSDictionary *params = @{ @"secretKey" : secretKey };
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSArray *streamDicts = (NSArray *)responseObject;
        NSMutableArray *streams = [[NSMutableArray alloc] initWithCapacity:[streamDicts count]];
        for (id object in streamDicts) {
            NSDictionary *streamDict = (NSDictionary *)object;
            CineStream *stream = [[CineStream alloc] initWithAttributes:streamDict];
            [streams addObject:stream];
        }
        completion(nil, [streams copy]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error, nil);
    }];
}

@end
