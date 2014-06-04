//
//  CineClient.h
//  cineio-ios
//
//  Created by Jeffrey Wescott on 6/3/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CineProject.h"

@interface CineClient : NSObject

@property (nonatomic, readonly) CineProject *project;

- (id)initWithSecretKey:(NSString *)secretKey;

@end
