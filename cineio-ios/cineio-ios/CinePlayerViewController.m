//
//  CinePlayerViewController.m
//  
//
//  Created by Jeffrey Wescott on 7/15/14.
//
//

#import "CinePlayerViewController.h"

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
    [spinner startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self attemptToPlayStream];
}

-(void)attemptToPlayStream
{
    NSAssert(stream != nil, @"The stream was never set for this player.");
    
    NSInteger statusCode = 0;
    NSInteger numTries = 0;
    while (statusCode != 200 && numTries < 3) {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:stream.playUrlHLS]];
        NSHTTPURLResponse *res = nil;
        NSError *err = nil;
        [NSURLConnection sendSynchronousRequest:req
                              returningResponse:&res
                                          error:&err];
        statusCode = res.statusCode;
        numTries++;
        NSLog(@"statusCode = %ld", (long)statusCode);
        [NSThread sleepForTimeInterval:1.0];
    }
    if (statusCode == 200) {
        [self startStreaming];
    } else {
        [spinner stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stream unavailable"
                                                        message:@"The stream you attempted to play is either inactive or unavailable."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self finishStreaming];
    }
}

- (void)startStreaming
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
    [moviePlayer setFullscreen:YES animated:YES];
}

- (void)stoppedStreaming:(NSNotification*)notification {
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
