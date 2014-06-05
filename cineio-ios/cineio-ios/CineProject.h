//
//  CineProject.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineProject : NSObject

@property (nonatomic, copy, readonly) NSString *projectId;
@property (nonatomic, copy, readonly) NSString *publicKey;
@property (nonatomic, copy, readonly) NSString *secretKey;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger streamsCount;
@property (nonatomic, copy, readonly) NSDate *updatedAt;

- (id)initWithAttributes:(NSDictionary *)projectAttributes;

@end
