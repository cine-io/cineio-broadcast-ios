//
//  CinePlayerViewController.m
//  
//
//  Created by Jeffrey Wescott on 7/15/14.
//
//

#import "CinePlayerViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface CinePlayerViewController ()

@end

@implementation CinePlayerViewController

@synthesize spinner;
@synthesize stream;
@synthesize moviePlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor blackColor];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:spinner
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
    [spinner stopAnimating];
}

- (void)startStreaming
{
    NSAssert(stream != nil, @"The stream was never set for this player.");
    [spinner startAnimating];
    [self attemptToPlayStream:0];
}

- (void)playStream
{
    NSLog(@"about to play: %@", stream.playUrlHLS);
    NSURL *url = [NSURL URLWithString:stream.playUrlHLS];
    moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
    [moviePlayer setFullscreen:YES animated:YES];
}

- (void)attemptToPlayStream:(NSUInteger)numTries
{
    if (numTries < 3) {
        numTries++;
        AFHTTPRequestOperationManager *http = [AFHTTPRequestOperationManager manager];
        http.responseSerializer.acceptableContentTypes = [http.responseSerializer.acceptableContentTypes setByAddingObject:@"application/vnd.apple.mpegurl"];
        http.responseSerializer = [AFHTTPResponseSerializer serializer];
        [http GET:stream.playUrlHLS parameters:nil success:^(AFHTTPRequestOperation *operation, id attributes) {
            [self playStream];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", error);
            if (numTries < 3) {
                NSLog(@"Stream not yet available. Tried %lu times.", (unsigned long)numTries);
                [NSThread sleepForTimeInterval:1.0];
                [self attemptToPlayStream:numTries];
            } else {
                NSLog(@"Stream not available. Tried %lu times.", (unsigned long)numTries);
                [spinner stopAnimating];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stream unavailable"
                                                                message:@"The stream you attempted to play is either inactive or unavailable."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [self finishStreaming];
            }
        }];
    }
}

- (void)stoppedStreaming:(NSNotification*)notification {
    NSLog(@"stopped streaming");
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
    [self finishStreaming];
}

- (void)finishStreaming
{
    // subclasses should implement this method
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
