//
//  ACBRRecording.h
//  broadcast-ios
//
//  Created by Jeffrey Wescott on 7/30/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACBRRecording : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, readonly) NSInteger size;
@property (nonatomic, copy, readonly) NSDate *date;

- (id)initWithAttributes:(NSDictionary *)projectAttributes;

@end
