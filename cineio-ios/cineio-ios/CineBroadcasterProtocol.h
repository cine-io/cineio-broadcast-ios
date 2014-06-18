//
//  CineBroadcasterProtocol.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/17/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CineBroadcasterProtocol <NSObject>

@property (nonatomic, copy) NSString *publishUrl;
@property (nonatomic, copy) NSString *publishStreamName;

@property (nonatomic) NSInteger frameWidth;
@property (nonatomic) NSInteger frameHeight;
@property (nonatomic) NSInteger videoBitRate;
@property (nonatomic) NSInteger framesPerSecond;
@property (nonatomic) NSInteger numAudioChannels;
@property (nonatomic) NSInteger sampleRateInHz;

@end
