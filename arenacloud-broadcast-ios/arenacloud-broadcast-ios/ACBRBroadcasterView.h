//
//  ACBRBroadcasterView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBRBroadcasterControlsView.h"

@interface ACBRBroadcasterView : UIView

@property (nonatomic, assign) BOOL orientationLocked;

@property (nonatomic, strong) UIView *cameraView;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *status;

@property (nonatomic, strong) ACBRBroadcasterControlsView *controlsView;

@end
