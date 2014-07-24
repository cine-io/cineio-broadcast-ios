//
//  CineBroadcasterViewController.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CineBroadcasterViewController () <VCSessionDelegate>
{
    CineBroadcasterView *_broadcasterView;
}

@property (nonatomic, strong) VCSimpleSession* session;

@end

@implementation CineBroadcasterViewController

@dynamic publishUrl;
@dynamic publishStreamName;

@dynamic frameWidth;
@dynamic frameHeight;
@dynamic videoBitRate;
@dynamic framesPerSecond;

@dynamic torchOn;
@dynamic cameraState;

// TODO: uncomment these if / when VideoCore supports the ability to configure them
//@dynamic numAudioChannels;
//@dynamic sampleRateInHz;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _session = [[VCSimpleSession alloc] initWithVideoSize:CGSizeMake(self.frameWidth, self.frameHeight) frameRate:self.framesPerSecond bitrate:self.videoBitRate useInterfaceOrientation:NO];

    _broadcasterView = (CineBroadcasterView *)self.view;
    [_broadcasterView.controlsView.recordButton.button addTarget:self action:@selector(toggleStreaming:) forControlEvents:UIControlEventTouchUpInside];
    [_broadcasterView.controlsView.torchButton addTarget:self action:@selector(toggleTorch:) forControlEvents:UIControlEventTouchUpInside];
    [_broadcasterView.controlsView.cameraStateButton addTarget:self action:@selector(toggleCameraState:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_broadcasterView.cameraView addSubview:_session.previewView];
    _session.previewView.frame = _broadcasterView.bounds;
    _session.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (BOOL)torchOn
{
    return _session.torch;
}

- (void)setTorchOn:(BOOL)isOn
{
    _session.torch = isOn;
}

- (CineCameraState)cameraState
{
    return (CineCameraState)_session.cameraState;
}

- (void)setCameraState:(CineCameraState)cameraState
{
    _session.cameraState = (VCCameraState)cameraState;
}

- (void)toggleTorch:(id)sender {
    if (self.torchOn) {
        self.torchOn = NO;
    } else {
        self.torchOn = YES;
    }
}

- (void)toggleCameraState:(id)sender {
    if (self.cameraState == CineCameraStateFront) {
        self.cameraState = CineCameraStateBack;
    } else {
        self.cameraState = CineCameraStateFront;
    }
}

- (void)toggleStreaming:(id)sender
{
    NSLog(@"record / stop button touched");

    switch(_session.rtmpSessionState) {
        case VCSessionStateNone:
        case VCSessionStatePreviewStarted:
        case VCSessionStateEnded:
        case VCSessionStateError:
            [_session startRtmpSessionWithURL:self.publishUrl andStreamKey:self.publishStreamName];
            break;
        default:
            [self updateStatus:@"Stopping ..."];
            [_session endRtmpSession];
            break;
    }
}

- (void)updateStatus:(NSString *)message
{
    NSLog(@"%@", message);
    _broadcasterView.status.text = message;
}

- (void)enableControls
{
    _broadcasterView.controlsView.recordButton.enabled = YES;
    [self updateStatus:@"Ready"];
}

- (void) connectionStatusChanged:(VCSessionState)state
{
    switch(state) {
        case VCSessionStateStarting:
            _broadcasterView.controlsView.recordButton.recording = YES;
            [self updateStatus:@"Connecting to server ..."];
            break;
        case VCSessionStateStarted:
            [self updateStatus:@"Streaming"];
            break;
        case VCSessionStateEnded:
            _broadcasterView.controlsView.recordButton.recording = NO;
            [self updateStatus:@"Disconnected"];
            break;
        case VCSessionStateError:
            _broadcasterView.controlsView.recordButton.recording = NO;
            [self updateStatus:@"Couldn't connect to server"];
            break;
        default:
            break;
    }
}

@end
