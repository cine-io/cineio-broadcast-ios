//
//  CineProject.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineProject : NSObject

@property (nonatomic, readonly) NSString *projectId;
@property (nonatomic, readonly) NSString *publicKey;
@property (nonatomic, readonly) NSString *secretKey;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger streamsCount;
@property (nonatomic, readonly) NSDate *updatedAt;

- (id)initWithAttributes:(NSDictionary *)projectAttributes;
- (void)getStreams:(void (^)(NSError* error, NSArray* streams))completion;

@end
