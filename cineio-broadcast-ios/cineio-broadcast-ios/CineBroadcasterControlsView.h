//
//  CineBroadcasterControlsView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/13/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineRecordButtonView.h"

@interface CineBroadcasterControlsView : UIView

@property (nonatomic, assign) BOOL orientationLocked;
@property (nonatomic, strong) CineRecordButtonView *recordButton;
@property (nonatomic, strong) UIButton *torchButton;
@property (nonatomic, strong) UIButton *cameraStateButton;

@end
