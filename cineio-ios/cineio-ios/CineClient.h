//
//  CineClient.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CineProject.h"
#import "CineStream.h"
#import <AFNetworking/AFNetworking.h>


@interface CineClient : NSObject
{
    NSString *_secretKey;
    AFHTTPRequestOperationManager *_http;
}

- (id)initWithSecretKey:(NSString *)secretKey;
- (void)getProjectWithCompletionHandler:(void (^)(NSError* error, CineProject* project))completion;
- (void)getStreamsWithCompletionHandler:(void (^)(NSError* error, NSArray* streams))completion;
- (void)getStream:(NSString *)streamId withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion;
- (void)createStream:(NSDictionary *)attributes withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion;

@end
