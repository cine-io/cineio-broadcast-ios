//
//  CineBroadcasterView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/6/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineBroadcasterControlsView.h"

@interface CineBroadcasterView : UIView

@property (nonatomic, strong) UIImageView *cameraView;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *status;

@property (nonatomic, strong) CineBroadcasterControlsView *controlsView;

@end
