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

@protocol CineBroadcasterProtocol <NSObject>

@property (nonatomic, copy) NSString *publishUrl;
@property (nonatomic, copy) NSString *publishStreamName;

@property (nonatomic) int frameWidth;
@property (nonatomic) int frameHeight;
@property (nonatomic) int videoBitRate;
@property (nonatomic) int framesPerSecond;

@property (nonatomic, assign) BOOL torchOn;
@property (nonatomic, assign) CineCameraState cameraState;


// TODO: uncomment these if / when VideoCore supports the ability to configure them
//@property (nonatomic) int numAudioChannels;
//@property (nonatomic) float sampleRateInHz;

@end
