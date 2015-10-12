//
//  ACBRBroadcasterViewController.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import "ACBRBroadcasterViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ACBRBroadcasterViewController () <VCSessionDelegate>
{
    ACBRBroadcasterView *_broadcasterView;
    BOOL _orientationLocked;
    CGSize _videoSize;
    int _videoBitRate;
    int _framesPerSecond;
    float _sampleRateInHz;
    BOOL _torchOn;
    ACBRCameraState _cameraState;
}

@property (nonatomic, strong) VCSimpleSession* session;

@end

@implementation ACBRBroadcasterViewController

// managed by us
@synthesize publishUrl;
@synthesize publishStreamName;

// managed by us (and we'll keep in sync w/ VCSimpleSession)
@dynamic orientationLocked;
@dynamic videoSize;
@dynamic videoBitRate;
@dynamic framesPerSecond;
@dynamic sampleRateInHz;
@dynamic torchOn;
@dynamic cameraState;
@dynamic streamState;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _session = [[VCSimpleSession alloc] initWithVideoSize:self.videoSize frameRate:self.framesPerSecond bitrate:self.videoBitRate useInterfaceOrientation:NO];
    //_session.useAdaptiveBitrate = YES; // this seems to crash VideoCore

    _broadcasterView = (ACBRBroadcasterView *)self.view;
    _broadcasterView.orientationLocked = _session.orientationLocked = self.orientationLocked;
    [_broadcasterView.controlsView.recordButton.button addTarget:self action:@selector(toggleStreaming:) forControlEvents:UIControlEventTouchUpInside];
    [_broadcasterView.controlsView.torchButton addTarget:self action:@selector(toggleTorch:) forControlEvents:UIControlEventTouchUpInside];
    [_broadcasterView.controlsView.cameraStateButton addTarget:self action:@selector(toggleCameraState:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_broadcasterView.cameraView addSubview:_session.previewView];
    _session.previewView.frame = _broadcasterView.bounds;
    _session.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    if (!self.orientationLocked) {
        if ([self.view isKindOfClass:[ACBRBroadcasterView class]]) {
            ACBRBroadcasterView *cbView = (ACBRBroadcasterView *)self.view;
            if ([cbView respondsToSelector:NSSelectorFromString(@"orientationChanged")]) {
                [[NSNotificationCenter defaultCenter] addObserver:(cbView) selector:NSSelectorFromString(@"orientationChanged") name:UIDeviceOrientationDidChangeNotification object:nil];
            }
            if ([cbView.controlsView respondsToSelector:NSSelectorFromString(@"orientationChanged")]) {
                [[NSNotificationCenter defaultCenter] addObserver:(cbView.controlsView) selector:NSSelectorFromString(@"orientationChanged") name:UIDeviceOrientationDidChangeNotification object:nil];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.view isKindOfClass:[ACBRBroadcasterView class]]) {
        ACBRBroadcasterView *cbView = (ACBRBroadcasterView *)self.view;
        [[NSNotificationCenter defaultCenter] removeObserver:cbView];
        [[NSNotificationCenter defaultCenter] removeObserver:cbView.controlsView];
    }
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

- (BOOL)orientationLocked
{
    return _orientationLocked;
}

- (void)setOrientationLocked:(BOOL)orientationLocked
{
    _broadcasterView.orientationLocked = _orientationLocked = orientationLocked;
}

- (CGSize)videoSize
{
    return _videoSize;
}

- (void)setVideoSize:(CGSize)videoSize
{
    _session.videoSize = _videoSize = videoSize;
}

- (int)videoBitRate
{
    return _videoBitRate;
}

- (void)setVideoBitRate:(int)videoBitRate
{
    _session.bitrate = _videoBitRate = videoBitRate;
}

- (int)framesPerSecond
{
    return _framesPerSecond;
}

- (void)setFramesPerSecond:(int)framesPerSecond
{
    _session.fps = _framesPerSecond = framesPerSecond;
}

- (float)sampleRateInHz
{
    return _sampleRateInHz;
}

- (void)setSampleRateInHz:(float)sampleRateInHz
{
    _session.audioSampleRate = _sampleRateInHz = sampleRateInHz;
}

- (BOOL)torchOn
{
    return _torchOn;
}

- (void)setTorchOn:(BOOL)isOn
{
    _session.torch = _torchOn = isOn;
}

- (ACBRCameraState)cameraState
{
    return _cameraState;
}

- (void)setCameraState:(ACBRCameraState)cameraState
{
    _cameraState = cameraState;
    _session.cameraState = (VCCameraState)_cameraState;
}

- (ACBRStreamState)streamState
{
    return (ACBRStreamState)_session.rtmpSessionState;
}

- (void)toggleTorch:(id)sender {
    if (self.torchOn) {
        self.torchOn = NO;
    } else {
        self.torchOn = YES;
    }
}

- (void)toggleCameraState:(id)sender {
    if (self.cameraState == ACBRCameraStateFront) {
        self.cameraState = ACBRCameraStateBack;
    } else {
        self.cameraState = ACBRCameraStateFront;
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
