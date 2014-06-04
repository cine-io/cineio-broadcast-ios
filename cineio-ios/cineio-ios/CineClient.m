//
//  CineClient.m
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineClient.h"
#import "CineConstants.h"
#import <LRResty/LRResty.h>

@implementation CineClient

@synthesize project;

- (id)initWithSecretKey:(NSString *)secretKey
{
    if (self = [super init]) {
        NSDictionary *reqParams = @{@"secretKey" : secretKey};

        NSString *url = [NSString stringWithFormat:@"%@/%@", BaseUrl, @"/project"];
        LRRestyResponse *resp = [[LRResty client] get:url parameters:reqParams];
        NSError *e = nil;
        NSDictionary *projectAttributes = [NSJSONSerialization JSONObjectWithData:[resp responseData] options:NSJSONReadingMutableContainers error:&e];
        project = [[CineProject alloc] initWithAttributes:projectAttributes];
    }
    
    return self;
}

@end
