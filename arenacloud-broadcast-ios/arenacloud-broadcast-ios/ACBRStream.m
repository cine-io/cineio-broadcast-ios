//
//  ACBRStream.m
//  broadcast-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import "ACBRStream.h"

@implementation ACBRStream

@synthesize streamId;
@synthesize playUrlHLS;
@synthesize playUrlRTMP;
@synthesize playUrlTTL;
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
        playUrlTTL = ((NSNumber *)[streamAttributes[@"play"][@"ttl"] copy]).intValue;
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
