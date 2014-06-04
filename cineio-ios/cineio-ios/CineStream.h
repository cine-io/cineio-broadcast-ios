//
//  CineStream.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineStream : NSObject

@property (nonatomic, copy) NSString *streamId;
@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, copy) NSString *publishUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) NSDate *expiration;
@property (nonatomic) NSDate *assignedAt;

- (id)initWithAttributes:(NSDictionary *)streamAttributes;

@end
