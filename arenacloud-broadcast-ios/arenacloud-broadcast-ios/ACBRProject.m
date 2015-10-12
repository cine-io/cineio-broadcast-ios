//
//  ACBRProject.m
//  broadcast-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import "ACBRProject.h"
#import "ACBRConstants.h"
#import "ACBRStream.h"
#import <AFNetworking/AFNetworking.h>

@implementation ACBRProject

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
