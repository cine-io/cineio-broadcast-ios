//
//  CineRecording.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 7/30/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CineRecording : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, readonly) NSInteger size;
@property (nonatomic, copy, readonly) NSDate *date;

- (id)initWithAttributes:(NSDictionary *)projectAttributes;

@end
