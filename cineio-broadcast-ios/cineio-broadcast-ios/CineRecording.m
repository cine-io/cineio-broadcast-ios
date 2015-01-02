//
//  CineRecording.m
//  cineio-ios
//
//  Created by Jeffrey Wescott on 7/30/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineRecording.h"

@implementation CineRecording

@synthesize name;
@synthesize url;
@synthesize size;
@synthesize date;

- (id)initWithAttributes:(NSDictionary *)streamAttributes
{
    if (self = [super init]) {
        name = [streamAttributes[@"name"] copy];
        url = [streamAttributes[@"url"] copy];
        size = [streamAttributes[@"size"] integerValue];
        date = [streamAttributes[@"date"] copy];
    }
    
    return self;
}

@end
