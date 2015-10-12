//
//  ACBRRecording.m
//  broadcast-ios
//
//  Created by Jeffrey Wescott on 7/30/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import "ACBRRecording.h"

@implementation ACBRRecording

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
