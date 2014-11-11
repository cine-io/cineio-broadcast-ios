//
//  CineBroadcasterControlsView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/13/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterControlsView.h"
#import "CineIconsBase64.h"

@implementation CineBroadcasterControlsView

@synthesize recordButton;
@synthesize torchButton;
@synthesize cameraStateButton;

- (id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];

    // set up UI
    recordButton = [[CineRecordButtonView alloc] initWithFrame:CGRectMake(self.center.x-36, self.center.y-36, 72, 72)];
    recordButton.enabled = NO;
    [self addSubview:recordButton];
    
    // torch button
    NSString *lightningIconString = @"data:image/png;base64,";
    lightningIconString = [lightningIconString stringByAppendingString:CineLightningIcon];
    NSData *lightningIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:lightningIconString]];
    UIImage *lightningIcon = [UIImage imageWithData:lightningIconData];
    torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [torchButton setBackgroundImage:lightningIcon forState:UIControlStateNormal];
    torchButton.frame = CGRectMake(0, 0, 25, 25);
    [self addSubview:torchButton];
    
    // switch camera button
    NSString *switchCameraIconString = @"data:image/png;base64,";
    switchCameraIconString = [switchCameraIconString stringByAppendingString:CineSwitchCameraIcon];
    NSData *switchCameraIconData = [NSData dataWithContentsOfURL:[NSURL URLWithString:switchCameraIconString]];
    UIImage *switchCameraIcon = [UIImage imageWithData:switchCameraIconData];
    cameraStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraStateButton setBackgroundImage:switchCameraIcon forState:UIControlStateNormal];
    cameraStateButton.frame = CGRectMake(0, 0, 25, 25);
    [self addSubview:cameraStateButton];

    [[NSNotificationCenter defaultCenter] addObserver:(self) selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [UIView performWithoutAnimation:^{
                recordButton.frame = CGRectMake(self.center.x - 36, 7, 72, 72);
                torchButton.frame = CGRectMake(25, 31, 25, 25);
                cameraStateButton.frame = CGRectMake(self.bounds.size.width - 50, 31, 25, 25);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            [UIView performWithoutAnimation:^{
                recordButton.frame = CGRectMake(7, self.center.y - 36, 72, 72);
                torchButton.frame = CGRectMake(self.center.x - 25, 25, 25, 25);
                cameraStateButton.frame = CGRectMake(self.center.x - 25, self.bounds.size.height - 50, 25, 25);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            [UIView performWithoutAnimation:^{
                recordButton.frame = CGRectMake(7, self.center.y - 36, 72, 72);
                torchButton.frame = CGRectMake(self.center.x - 25, self.bounds.size.height - 50, 25, 25);
                cameraStateButton.frame = CGRectMake(self.center.x - 25, 25, 25, 25);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)orientationChanged
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    double rotation = 0;

    //NSLog(@"self.bounds: %.0fx%.0f@%.0f,%.0f", self.bounds.size.width, self.bounds.size.height, self.bounds.origin.x, self.bounds.origin.y);
    //NSLog(@"self.center: %.0f,%.0f", self.center.x, self.center.y);

    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        {
            rotation = 0;
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        {
            rotation = M_PI;
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            rotation = M_PI_2;
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            rotation = -M_PI_2;
        }
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
                         torchButton.transform = cameraStateButton.transform = transform;
                     }
                     completion:nil];
    
}

@end
