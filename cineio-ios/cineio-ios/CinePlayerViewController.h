//
//  CinePlayerViewController.h
//  
//
//  Created by Jeffrey Wescott on 7/15/14.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CineStream.h"

@interface CinePlayerViewController : UIViewController

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, weak) CineStream *stream;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

- (void)finishStreaming;

@end
