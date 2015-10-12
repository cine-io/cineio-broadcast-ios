//
//  ACBRRecordButtonView.m
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/5/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import "ACBRRecordButtonView.h"

@implementation ACBRRecordButtonView

@synthesize recording = _recording;
@synthesize button;

- (id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    
    // set up UI
    self.layer.cornerRadius = 36;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 5.5;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 56, 56)];
    button.backgroundColor = [UIColor redColor];
    button.alpha = 1.0;
    button.layer.cornerRadius = 28;
    button.layer.masksToBounds = YES;
    button.enabled = YES;
    [self addSubview:button];
    
    return self;
}

-(BOOL)getEnabled
{
    return button.enabled;
}

-(void)setEnabled:(BOOL)enabled
{
    button.enabled = enabled;
    NSLog(@"button enabled? %d", enabled);
    if (enabled) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        button.backgroundColor = [UIColor redColor];
    } else {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.backgroundColor = [UIColor grayColor];
    }
}

-(void)setRecording:(BOOL)recording
{
    _recording = recording;
    if (recording) {
        button.frame = CGRectMake(16, 16, 40, 40);
        button.layer.cornerRadius = 8;
    } else {
        button.frame = CGRectMake(8, 8, 56, 56);
        button.layer.cornerRadius = 28;
    }

}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(72.0, 72.0);
}

@end
