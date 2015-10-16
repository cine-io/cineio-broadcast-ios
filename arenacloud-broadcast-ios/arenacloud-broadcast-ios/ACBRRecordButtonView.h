//
//  ACBRRecordButtonView.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/5/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ACBRRecordButtonView : UIView

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL recording;
@property (nonatomic, strong) UIButton *button;

@end
