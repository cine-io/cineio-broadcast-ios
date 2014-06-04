//
//  CineStream.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineStream : NSObject

@property (nonatomic, readonly) NSString *streamId;
@property (nonatomic, readonly) NSString *playUrlHLS;
@property (nonatomic, readonly) NSString *playUrlRTMP;
@property (nonatomic, readonly) NSString *publishUrl;
@property (nonatomic, readonly) NSString *publishStreamName;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *password;
@property (nonatomic, readonly) NSDate *expiration;
@property (nonatomic, readonly) NSDate *assignedAt;

- (id)initWithAttributes:(NSDictionary *)streamAttributes;

@end
