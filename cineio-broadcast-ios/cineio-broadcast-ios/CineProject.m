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
        projectId = [streamAttributes[@"id"] copy];
        publicKey = [streamAttributes[@"publicKey"] copy];
        secretKey = [streamAttributes[@"secretKey"] copy];
        name = [streamAttributes[@"name"] copy];
        streamsCount = [streamAttributes[@"streamsCount"] integerValue];
        updatedAt = [streamAttributes[@"updatedAt"] copy];
    }
    
    return self;
}

@end
