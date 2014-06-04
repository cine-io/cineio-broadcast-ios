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
#import <AFNetworking/AFNetworking.h>

@implementation CineClient

- (id)initWithSecretKey:(NSString *)secretKey
{
    if (self = [super init]) {
        _secretKey = secretKey;
    }
    
    return self;
}

- (void)getProjectWithCompletionHandler:(void (^)(NSError* error, CineProject* project))completion {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@", BaseUrl, @"/project"];
    NSDictionary *params = @{ @"secretKey" : _secretKey };
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id attributes) {
        NSLog(@"JSON: %@", attributes);
        CineProject *project = [[CineProject alloc] initWithAttributes:attributes];
        completion(nil, project);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        completion(error, nil);
    }];
}

@end
