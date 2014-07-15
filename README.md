# cineio-ios - cine.io iOS SDK

This is the [cine.io][cineio] iOS SDK. This library allows you to do real-time
live video streaming from your iOS device to any other device that supports
RTMP or HLS streaming (iOS, Android, web).


## Table of Contents

- [Installation](#installation)
- [Example Application](#example-application)
- [Playback](#playback)
- [Publishing](#publishing-using-cinebroadcasterview-and-cinebroadcasterviewcontroller)
- [Acknowledgements](#acknowledgements)
- [Contributing](#contributing)


## Installation

The easiest way to use the SDK is via [CocoaPods][cocoapods]. Create a new XCode project with a file named `Podfile` that contains at least the following:

```ruby
platform :ios, '6.0'

pod 'cineio-ios', '~> 0.3.0'
```

Then, install the Pod by running the `pod install` command:

```bash
pod install
```

Then you can open the project using the `<project>.xcworkspace` file:

```bash
open <project>.xcworkspace
```


## Example Application

Check out the [cineio-ios-example-app][cineio-ios-example-app] repository for
a working example of a simple application that uses this SDK.



## Basic Usage

### Import the SDK

```objective-c
#import <cineio/CineIO.h>
```

### Instantiate the client

```objective-c
CineClient *client = [[CineClient alloc] initWithSecretKey:@"<YOUR SECRET>"];
```

### Get your project (asynchronously)

```objective-c
[client getProjectWithCompletionHandler:^(NSError *error, CineProject *project) {
  // do something
}];
```

### Get your streams (asynchronously)

```objective-c
[client getStreamsWithCompletionHandler:^(NSError *err, NSArray *streams) {
  for (id object in streams) {
    CineStream *stream = (CineStream *)object;
    // do something
  }
}];
```

### Get an individual stream (asynchronously)
```objective-c
[client getStream:@"<SOME STREAM ID>" withCompletionHandler:^(NSError* error, CineStream* stream) {
  // do something
}];
```

### Create a new stream (asynchronously)
```objective-c
[client createStream:@{ @"name" : @"my stream" } withCompletionHandler:^(NSError* error, CineStream* stream) {
  // do something
}];

```

### Update a stream (asynchronously)
```objective-c
[client updateStream:@{ @"" : "<SOME STREAM ID>", @"name" : @"my stream" } withCompletionHandler:^(NSError* error, CineStream* stream) {
  // do something
}];

```

### Delete a stream (asynchronously)
```objective-c
[client deleteStream:@"<SOME STREAM ID>" withCompletionHandler:^(NSError* error, NSHTTPURLResponse* response) {
  // do something, like check for response.statusCode == 200
}];

```


## Playback

Every `CineStream` object has an `playUrlHLS` property. This URL can be sent
directly to in instance of
[`MPMoviePlayerController`][mp-movieplayer-controller]for playback, just as
[`you would with any other HLS stream.

```objective-c
- (IBAction)startStreaming:(id)sender
{
    // assume that self.playUrlHLS is a property that we've set that contains
    // the playback URL as obtained by the CineStream
    NSURL *url = [NSURL URLWithString:self.playUrlHLS];
    _moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stoppedStreaming:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:_moviePlayer];

    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void)stoppedStreaming:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:player];

    if ([player respondsToSelector:@selector(setFullscreen:animated:)]) {
        [player.view removeFromSuperview];
    }
}
```


## Publishing (using CineBroadcasterView and CineBroadcasterViewController)

To make publishing as easy as possible, cineio-ios comes with some ready-made
user-interface components that take care of most of the heavy-lifting. Using
them is pretty straight forward.

### Setup

#### Handling Device Rotation

For user-experience reasons, our CineBroadcasterView uses neither "Auto
Layout" nor "Springs and Struts". Instead, the entire user-interface is
constructed programatically. This means that we need to listen for
notifications about when the device changes orientation. The best place to do
this is in the `AppDelegate didFinishLaunchingWithOptions` method:

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    return YES;
}
```

#### Storyboard Setup

If you're using XCode's Storyboards to build your user interface, our UI
components should work seamlessly. To use them, follow these steps:

1. Make your view controller inherit from `CineBroadcasterViewController` rather than `UIViewController`.
2. Ensure that the view controller in your Storyboard has the correct class name set. It should be set to *your subclass* of `CineBroadcasterViewController`.
3. Ensure that the view in your Storyboard has the correct class name set. It should be set to `CineBroadcasterView`.

### Complying with `CineBroadcasterProtocol`

Your `CineBroadcasterViewController` subclass must comply with
`CineBroadcasterProtocol`. Specifically, you'll need to synthesize several
properties in your subclass:

```objective-c
@implementation YourCineBroadcasterViewControllerSubclass

// CineBroadcasterProtocol
@synthesize frameWidth;
@synthesize frameHeight;
@synthesize framesPerSecond;
@synthesize videoBitRate;
@synthesize numAudioChannels;
@synthesize sampleRateInHz;

@synthesize publishUrl;
@synthesize publishStreamName;
```

### Initializing the properties

You'll need to initialize these properties, most likely in your `viewDidLoad` method. For example:

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    //-- A/V setup
    self.frameWidth = 1280;
    self.frameHeight = 720;
    self.framesPerSecond = 30;
    self.videoBitRate = 1500000;
    self.numAudioChannels = 2;
    self.sampleRateInHz = 44100;

    //-- cine.io setup

    // read our cine.io configuration from a plist bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];

    // create a new CineClient to fetch our stream information
    CineClient *cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    [self updateStatus:@"Configuring stream using cine.io ..."];
    [cine getStream:settings[@"CINE_IO_STREAM_ID"] withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
            [self updateStatus:@"ERROR: couldn't get stream information from cine.io"];
        } else {
            self.publishUrl = [stream publishUrl];
            self.publishStreamName = [stream publishStreamName];

            // once we've fully-configured our properties, we can enable the
            // UI controls on our view
            [self enableControls];
        }
    }];
}
```


## Acknowledgements

Much of the basis for the cine.io iOS SDK comes from the excellent
[VideoCore][VideoCore] library.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


<!-- external links -->

[cineio]:https://www.cine.io/
[cocoapods]:http://cocoapods.org/
[VideoCore]:https://github.com/jamesghurley/VideoCore
[cineio-ios-example-app]:https://github.com/cine-io/cineio-ios-example-app
[mp-movieplayer-controller]:https://developer.apple.com/library/ios/documentation/MediaPlayer/Reference/MPMoviePlayerController_Class/Reference/Reference.html