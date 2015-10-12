//
//  ACBRBroadcasterViewController.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 ArenaCloud.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACBRBroadcasterProtocol.h"
#import "ACBRBroadcasterView.h"


@interface ACBRBroadcasterViewController : UIViewController <ACBRBroadcasterProtocol>
{
    
}

- (void)toggleStreaming:(id)sender;
- (void)updateStatus:(NSString *)message;
- (void)enableControls;

@end
