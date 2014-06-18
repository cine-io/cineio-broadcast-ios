//
//  CineBroadcasterViewController.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterViewController.h"
#import <cineio/CineIO.h>
#import <AVFoundation/AVFoundation.h>

@interface CineBroadcasterViewController ()
{
    CineBroadcasterView *_broadcasterView;
}

@end

@implementation CineBroadcasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _broadcasterView = (CineBroadcasterView *)self.view;
    [_broadcasterView.controlsView.recordButton.button addTarget:self action:@selector(toggleStreaming:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)toggleStreaming:(id)sender
{
    NSLog(@"record / stop button touched");
    
    if (!_broadcasterView.controlsView.recordButton.recording) {
        _broadcasterView.controlsView.recordButton.recording = YES;
        NSString* rtmpUrl = [NSString stringWithFormat:@"%@/%@", self.publishUrl, self.publishStreamName];
        
        NSLog(@"RTMP URL: %@", rtmpUrl);
        [self updateStatus:@"Connecting to server ..."];

        
        pipeline.reset(new Broadcaster::CineBroadcasterPipeline([self](Broadcaster::SessionState state){
            [self connectionStatusChange:state];
        }));
        
        
        pipeline->setPBCallback([=](const uint8_t* const data, size_t size) {
            [self gotPixelBuffer: data withSize: size];
        });
        
        pipeline->startRtmpSession([rtmpUrl UTF8String], self.frameWidth, self.frameHeight, self.videoBitRate, self.framesPerSecond, self.numAudioChannels, self.sampleRateInHz);
    } else {
        [self updateStatus:@"Stopping ..."];
        _broadcasterView.controlsView.recordButton.recording = NO;
        // disconnect
        pipeline.reset();
        [self updateStatus:@"Stopped"];
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

- (void) connectionStatusChange:(Broadcaster::SessionState) state
{
    if(state == Broadcaster::kSessionStateStarted) {
        [self updateStatus:@"Streaming"];
    } else if(state == Broadcaster::kSessionStateError) {
        [self updateStatus:@"Couldn't connect to server"];
        pipeline.reset();
    } else if (state == Broadcaster::kSessionStateEnded) {
        [self updateStatus:@"Disconnected"];
        pipeline.reset();
    }
}

- (void) gotPixelBuffer: (const uint8_t* const) data withSize: (size_t) size {
    @autoreleasepool {
        CVPixelBufferRef pb = (CVPixelBufferRef) data;
        float width = CVPixelBufferGetWidth(pb);
        float height = CVPixelBufferGetHeight(pb);
        CVPixelBufferLockBaseAddress(pb, 1);
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pb];
        
        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext
                                 createCGImage:ciImage
                                 fromRect:CGRectMake(0, 0, width, height)];
        
        UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
        CVPixelBufferUnlockBaseAddress(pb, 0);
        
        [_broadcasterView.cameraView performSelectorOnMainThread:@selector(setImage:) withObject:uiImage waitUntilDone:NO];
        
        CGImageRelease(videoImage);
    }
}

@end
