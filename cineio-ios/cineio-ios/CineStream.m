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
@synthesize playUrlHLS;
@synthesize playUrlRTMP;
@synthesize publishUrl;
@synthesize publishStreamName;
@synthesize name;
@synthesize password;
@synthesize expiration;
@synthesize assignedAt;
@synthesize record;

- (id)initWithAttributes:(NSDictionary *)streamAttributes
{
    if (self = [super init]) {
        streamId = [streamAttributes[@"id"] copy];
        playUrlHLS = [streamAttributes[@"play"][@"hls"] copy];
        playUrlRTMP = [streamAttributes[@"play"][@"rtmp"] copy];
        publishUrl = [streamAttributes[@"publish"][@"url"] copy];
        publishStreamName = [streamAttributes[@"publish"][@"stream"] copy];
        name = [streamAttributes[@"name"] copy];
        password = [streamAttributes[@"password"] copy];
        expiration = [streamAttributes[@"expiration"] copy];
        assignedAt = [streamAttributes[@"assignedAt"] copy];
        record = ((NSNumber *)[streamAttributes[@"record"] copy]).boolValue;
    }
    
    return self;
}

@end
