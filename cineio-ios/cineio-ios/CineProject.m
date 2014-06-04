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

@end
