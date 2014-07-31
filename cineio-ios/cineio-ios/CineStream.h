//
//  CineStream.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineStream : NSObject

@property (nonatomic, copy, readonly) NSString *streamId;
@property (nonatomic, copy, readonly) NSString *playUrlHLS;
@property (nonatomic, copy, readonly) NSString *playUrlRTMP;
@property (nonatomic, copy, readonly) NSString *publishUrl;
@property (nonatomic, copy, readonly) NSString *publishStreamName;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, copy, readonly) NSDate *expiration;
@property (nonatomic, copy, readonly) NSDate *assignedAt;
@property (nonatomic, readonly) BOOL record;

- (id)initWithAttributes:(NSDictionary *)streamAttributes;

@end
