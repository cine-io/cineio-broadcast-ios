//
//  ACBRBroadcasterControlsView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/13/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBRRecordButtonView.h"

@interface ACBRBroadcasterControlsView : UIView

@property (nonatomic, assign) BOOL orientationLocked;
@property (nonatomic, strong) ACBRRecordButtonView *recordButton;
@property (nonatomic, strong) UIButton *torchButton;
@property (nonatomic, strong) UIButton *cameraStateButton;

@end
