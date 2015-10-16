//
//  ACBRBroadcasterProtocol.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/17/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <videocore/api/iOS/VCSimpleSession.h>

typedef NS_ENUM(NSUInteger, ACBRCameraState) {
    ACBRCameraStateFront = VCCameraStateFront,
    ACBRCameraStateBack = VCCameraStateBack
};

typedef NS_ENUM(NSUInteger, ACBRStreamState) {
    ACBRStreamStateNone = VCSessionStateNone,
    ACBRStreamStatePreviewStarted = VCSessionStatePreviewStarted,
    ACBRStreamStateStarting = VCSessionStateStarting,
    ACBRStreamStateStarted = VCSessionStateStarted,
    ACBRStreamStateEnded = VCSessionStateEnded,
    ACBRStreamStateError = VCSessionStateError
};

@protocol ACBRBroadcasterProtocol <NSObject>

@property (nonatomic, strong) NSString *publishUrl;
@property (nonatomic, strong) NSString *publishStreamName;

@property (nonatomic, assign) BOOL orientationLocked;
@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) int videoBitRate;
@property (nonatomic, assign) int framesPerSecond;
@property (nonatomic, assign) float sampleRateInHz;
@property (nonatomic, assign) BOOL torchOn;
@property (nonatomic, assign) ACBRCameraState cameraState;
@property (nonatomic, readonly) ACBRStreamState streamState;

@end
