//
//  CineBroadcasterViewController.h
//  Broadcaster
//
//  Created by Jeffrey Wescott on 6/4/14.
//  Copyright (c) 2014 cine.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CineBroadcasterProtocol.h"
#import "CineBroadcasterView.h"

@interface CineBroadcasterViewController : UIViewController <CineBroadcasterProtocol>
{

}

- (void)toggleStreaming:(id)sender;
- (void)updateStatus:(NSString *)message;
- (void)enableControls;

@end
