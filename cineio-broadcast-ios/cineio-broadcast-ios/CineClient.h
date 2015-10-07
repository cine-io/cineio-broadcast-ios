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
    AFHTTPRequestOperationManager *_http;
}

@property (nonatomic, strong) NSString *masterKey;
@property (nonatomic, strong) NSString *projectSecretKey;
@property (nonatomic, strong) NSString *projectPublicKey;

- (id)init;

- (void)getProjectsWithCompletionHandler:(void (^)(NSError* error, NSArray* projects))completion;
- (void)getProjectWithCompletionHandler:(void (^)(NSError* error, CineProject* project))completion;
- (void)getStreamsWithCompletionHandler:(void (^)(NSError* error, NSArray* streams))completion;
- (void)getStreamsForName:(NSString *)name withCompletionHandler:(void (^)(NSError* error, NSArray* streams))completion;
- (void)getStream:(NSString *)streamId withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion;
- (void)createStream:(NSDictionary *)attributes withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion;
- (void)updateStream:(NSDictionary *)attributes withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion;
- (void)deleteStream:(NSString *)streamId withCompletionHandler:(void (^)(NSError* error, NSHTTPURLResponse* response))completion;
- (void)getStreamRecordings:(NSString *)streamId withCompletionHandler:(void (^)(NSError* error, NSArray* recordings))completion;
- (void)deleteStreamRecording:(NSString *)streamId withName:(NSString *)name andCompletionHandler:(void (^)(NSError* error, NSHTTPURLResponse* response))completion;

- (void)getStream:(NSString *)streamId byPassword:(NSString *)password withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion;
- (void)getStream:(NSString *)streamId byTicket:(NSString *)ticket withCompletionHandler:(void (^)(NSError* error, CineStream* stream))completion;

@end
