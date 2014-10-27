//
//  CineBroadcasterProtocol.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/17/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <videocore/api/iOS/VCSimpleSession.h>

enum CineCameraState {
    CineCameraStateFront = VCCameraStateFront,
    CineCameraStateBack = VCCameraStateBack
};

enum CineStreamState {
    CineStreamStateNone = VCSessionStateNone,
    CineStreamStatePreviewStarted = VCSessionStatePreviewStarted,
    CineStreamStateStarting = VCSessionStateStarting,
    CineStreamStateStarted = VCSessionStateStarted,
    CineStreamStateEnded = VCSessionStateEnded,
    CineStreamStateError = VCSessionStateError
};

@protocol CineBroadcasterProtocol <NSObject>

@property (nonatomic, strong) NSString *publishUrl;
@property (nonatomic, strong) NSString *publishStreamName;

@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) int videoBitRate;
@property (nonatomic, assign) int framesPerSecond;
@property (nonatomic, assign) float sampleRateInHz;
@property (nonatomic, assign) BOOL torchOn;
@property (nonatomic, assign) enum CineCameraState cameraState;
@property (nonatomic, readonly) enum CineStreamState streamState;

@end
