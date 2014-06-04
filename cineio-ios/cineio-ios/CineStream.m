//
//  CineStream.m
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineStream.h"

@implementation CineStream

@synthesize streamId;
@synthesize playUrl;
@synthesize publishUrl;
@synthesize name;
@synthesize password;
@synthesize expiration;
@synthesize assignedAt;

- (id)initWithAttributes:(NSDictionary *)streamAttributes
{
    if (self = [super init]) {
        streamId = streamAttributes[@"id"];
        playUrl = streamAttributes[@"playUrl"];
        publishUrl = streamAttributes[@"publishUrl"];
        name = streamAttributes[@"name"];
        password = streamAttributes[@"password"];
        expiration = streamAttributes[@"expiration"];
        assignedAt = streamAttributes[@"assignedAt"];
    }
    
    return self;
}

@end
