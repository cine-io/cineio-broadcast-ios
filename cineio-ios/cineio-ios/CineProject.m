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
#import <LRResty/LRResty.h>

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

- (NSArray *)getStreams
{
    NSDictionary *reqParams = @{@"secretKey" : secretKey};
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", BaseUrl, @"/streams"];
    LRRestyResponse *resp = [[LRResty client] get:url parameters:reqParams];
    NSError *e = nil;
    NSArray *streamDicts = [NSJSONSerialization JSONObjectWithData:[resp responseData] options:NSJSONReadingMutableContainers error:&e];
    
    NSMutableArray *streams = [[NSMutableArray alloc] initWithCapacity:[streamDicts count]];
    for (id object in streamDicts) {
        NSDictionary *streamDict = (NSDictionary *)object;
        CineStream *stream = [[CineStream alloc] initWithAttributes:streamDict];
        [streams addObject:stream];
    }
    
    return streams;
}

@end
