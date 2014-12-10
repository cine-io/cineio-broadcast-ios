//
//  CineBroadcasterView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterView.h"


@implementation CineBroadcasterView
{
    BOOL _orientationLocked;
}

@synthesize orientationLocked = _orientationLocked;
@synthesize cameraView;
@synthesize statusView;
@synthesize status;
@synthesize controlsView;

const NSInteger StatusViewHeight = 40;
const NSInteger ControlsViewHeight = 86;


- (void)awakeFromNib
{
    self.orientationLocked = NO;
    [self setupUI];
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    self.orientationLocked = NO;
    [self setupUI];

    return self;
}

- (void)layoutSubviews
{
    [cameraView setFrame:[self cameraFrameForOrientation:[[UIDevice currentDevice] orientation]]];
    [statusView setFrame:[self statusFrameForOrientation:[[UIDevice currentDevice] orientation]]];
    [status setFrame:CGRectMake(10, 10, statusView.bounds.size.width-20, 20)];
    [controlsView setFrame:CGRectMake(0, self.bounds.size.height-ControlsViewHeight, self.bounds.size.width, ControlsViewHeight)];

    if (!self.orientationLocked) {
        [[NSNotificationCenter defaultCenter] addObserver:(self) selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (BOOL)orientationLocked
{
    return _orientationLocked;
}

- (void)setOrientationLocked:(BOOL)orientationLocked
{
    _orientationLocked = orientationLocked;
    
    if (controlsView) {
        controlsView.orientationLocked = orientationLocked;
    }
}


- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    
    cameraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    cameraView.backgroundColor = [UIColor clearColor];
    [cameraView setContentMode:UIViewContentModeCenter];
    [cameraView setContentMode:UIViewContentModeScaleAspectFit];
    
    UIColor *translucentBlack = [[UIColor alloc] initWithWhite:0.0 alpha:0.25];
    
    statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, StatusViewHeight)];
    statusView.backgroundColor = translucentBlack;
    status = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, statusView.bounds.size.width-20, 20)];
    status.backgroundColor = [UIColor clearColor];
    status.textColor = [UIColor whiteColor];
    status.font = [UIFont systemFontOfSize:12];
    status.textAlignment = NSTextAlignmentLeft;
    status.numberOfLines = 1;
    status.clipsToBounds = YES;
    status.text = @"Initializing";
    [statusView addSubview:status];
    
    controlsView = [[CineBroadcasterControlsView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-ControlsViewHeight, self.bounds.size.width, ControlsViewHeight)];
    controlsView.backgroundColor = translucentBlack;
    
    [self addSubview:cameraView];
    [self addSubview:statusView];
    [self addSubview:controlsView];
}

- (void)orientationChanged
{
    if (self.orientationLocked) return;

    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    double rotation = 0;
    CGRect statusFrame = CGRectZero;
    CGRect cameraFrame = CGRectZero;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            rotation = [self rotationForOrientation:orientation];
            statusFrame = [self statusFrameForOrientation:orientation];
            cameraFrame = [self cameraFrameForOrientation:orientation];
            break;
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationUnknown:
        default:
            return;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         cameraView.transform = statusView.transform = transform;
                         cameraView.frame = cameraFrame;
                         statusView.frame = statusFrame;
                     }
                     completion:nil];
}

- (double)rotationForOrientation:(UIDeviceOrientation)orientation
{
    if (self.orientationLocked) return 0;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return 0;
        case UIDeviceOrientationPortraitUpsideDown:
            return M_PI;
        case UIDeviceOrientationLandscapeLeft:
            return M_PI_2;
        case UIDeviceOrientationLandscapeRight:
            return -M_PI_2;
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationUnknown:
        default:
            return 0;
    }
}

- (CGRect)cameraFrameForOrientation:(UIDeviceOrientation)orientation
{
    // always the same
    return CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (CGRect)statusFrameForOrientation:(UIDeviceOrientation)orientation
{
    CGRect statusFrame = CGRectZero;

    if (self.orientationLocked) {
        // portrait
        statusFrame = CGRectMake(0, 0, self.bounds.size.width, StatusViewHeight);
    } else {
        //NSLog(@"statusView.frame: %.0fx%.0f@%.0f,%.0f", statusView.frame.size.width, statusView.frame.size.height, statusView.frame.origin.x, statusView.frame.origin.y);
        
        switch (orientation) {
            case UIDeviceOrientationPortrait:
                statusFrame = CGRectMake(0, 0, self.bounds.size.width, StatusViewHeight);
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                statusFrame = CGRectMake(0, 0, self.bounds.size.width, StatusViewHeight);
                break;
            case UIDeviceOrientationLandscapeLeft:
                statusFrame = CGRectMake(self.bounds.size.width-StatusViewHeight, 0, StatusViewHeight, self.bounds.size.height-ControlsViewHeight);
                break;
            case UIDeviceOrientationLandscapeRight:
                statusFrame = CGRectMake(0, 0, StatusViewHeight, self.bounds.size.height-ControlsViewHeight);
                break;
            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationUnknown:
            default:
                statusFrame = statusView.frame;
        }
        
        //NSLog(@"statusFrame: %.0fx%.0f@%.0f,%.0f", statusFrame.size.width, statusFrame.size.height, statusFrame.origin.x, statusFrame.origin.y);
    }
    
    return statusFrame;
}

@end
