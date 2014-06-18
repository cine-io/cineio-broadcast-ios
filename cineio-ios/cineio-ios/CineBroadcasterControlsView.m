//
//  CineBroadcasterControlsView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/13/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import "CineBroadcasterControlsView.h"

@implementation CineBroadcasterControlsView

@synthesize recordButton;

- (id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];

    // set up UI
    recordButton = [[CineRecordButtonView alloc] initWithFrame:CGRectMake(self.center.x-36, self.center.y-36, 72, 72)];
    recordButton.enabled = NO;
    [self addSubview:recordButton];
    
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
            NSLog(@"portrait");
            [UIView performWithoutAnimation:^{
                recordButton.frame = CGRectMake(self.center.x - 36, 7, 72, 72);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"landscape left");
            [UIView performWithoutAnimation:^{
                recordButton.frame = CGRectMake(7, self.center.y - 36, 72, 72);
            }];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:
        {
            NSLog(@"landscape right");
            [UIView performWithoutAnimation:^{
                recordButton.frame = CGRectMake(7, self.center.y - 36, 72, 72);
            }];
        }
            break;
    }
}

@end
