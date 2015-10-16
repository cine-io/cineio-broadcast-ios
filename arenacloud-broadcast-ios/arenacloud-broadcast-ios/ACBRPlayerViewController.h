//
//  ACBRPlayerViewController.h
//  
//
//  Created by Jeffrey Wescott on 7/15/14.
//
//

#import <UIKit/UIKit.h>
//#import <MediaPlayer/MediaPlayer.h>
#import "ACBRStream.h"

#import "IJKMediaPlayback.h"

@interface ACBRPlayerViewController : UIViewController

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) ACBRStream *stream;

//@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) id<IJKMediaPlayback> player;

- (void)startStreaming;
- (void)finishStreaming;

@end
