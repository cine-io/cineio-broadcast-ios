# cineio-ios - cine.io iOS SDK

<!-- [![Build Status](https://travis-ci.org/cine-io/cineio-ios.svg?branch=master)](https://travis-ci.org/cine-io/cineio-ios) -->

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

The easiest way to use the SDK is via [CocoaPods][cocoapods]. Create a new
XCode project with a file named `Podfile` that contains at least the
following:

```ruby
platform :ios, '7.0'

pod 'cineio-ios', '~> 0.5'
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
CineClient *client = [[CineClient alloc] init];
```

### Set the client properties

Most of the APIs on the CineClient require that the `projectSecretKey` property
has been set. In addition, the `getProjectsWithCompletionHandler` API requires
that the `masterKey` property has been set. Be sure to set the appropriate
properties for the APIs you wish to use.

```objective-c
client.masterKey = @"YOUR_ACCOUNT_MASTER_KEY";
client.projectSecretKey = @"YOUR_PROJECT_SECRET_KEY";
```

### Get your projects (asynchronously)

```objective-c
[client getProjectsWithCompletionHandler:^(NSError *err, NSArray *projects) {
  for (id object in streams) {
    CineProject *project = (CineProject *)object;
    // do something
  }
}];
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

### Get the recordings of a stream (asynchronously)
```objective-c
[client getStreamRecordings:@"<SOME STREAM ID>" withCompletionHandler:^(NSError* error, NSArray* recordings) {
  // do something
}];
```

### Delete a stream recording (asynchronously)
```objective-c
[client deleteStreamRecording:@"<SOME STREAM ID>"
                     withName:@"foo.mp4"
         andCompletionHandler:^(NSError* error, NSHTTPURLResponse* response) {
  // do something, like check for response.statusCode == 200
}];

```


## Playback (using `CinePlayerView`)

To make playback as easy as possible, cineio-ios comes with a ready-made view
controller that takes care of most of the heavy-lifting. Using it is pretty
straight forward.

### Storyboard Setup

If you're using XCode's Storyboards to build your user interface, our UI
components should work seamlessly. To use them, follow these steps:

1. Make your view controller inherit from `CinePlayerViewController` rather than `UIViewController`.
2. Ensure that the view controller in your Storyboard has the correct class name set. It should be set to *your subclass* of `CinePlayererViewController`.

### The `stream` Property

Your class that inherits from `CinePlayerViewController` will have a writeable
`stream` property. You'll need to ensure that this property is set with a
valid `CineStream` object.

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    //-- cine.io setup

    // read our cine.io configuration from a plist bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cineio-settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];

    // create a new CineClient to fetch our stream information
    CineClient *cine = [[CineClient alloc] initWithSecretKey:settings[@"CINE_IO_SECRET_KEY"]];
    [cine getStream:settings[@"CINE_IO_STREAM_ID"] withCompletionHandler:^(NSError *error, CineStream *stream) {
        if (error) {
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                          message:@"Couldn't get stream settings from cine.io."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
          [alert show];
        } else {
          self.stream = stream;
        }
    }];
```

### Starting Playback

To start playback, simply call `startStreaming`. This method will first
attempt to (asynchronously) validate that a stream exists at the given HLS
URL, and if it does, will start to play it. Otherwise, an appropriate error
message will be displayed in a `UIAlert`.

You likely want to disable the idle timer in this method.

```objective-c
- (IBAction)playButtonPressed:(id)sender
{
    playButton.enabled = NO;
    playButton.hidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self startStreaming];
}
```

### Cleaning up

When the stream has finished playing (for any reason, including the user
quitting, the stream ending, or if errors are encountered), `finishStreaming`
will be called. You should put any cleanup code that you want executed into
this method (such as re-enabling the idle timer).

```objective-c
- (void)finishStreaming
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    playButton.hidden = NO;
    playButton.enabled = YES;
}
```


## Publishing (using `CineBroadcasterView` and `CineBroadcasterViewController`)

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


### Initializing the properties

You'll need to initialize these properties, most likely in your `viewDidLoad` method. For example:

```objective-c
- (void)viewDidLoad
{
    //-- A/V setup
    self.videoSize = CGSizeMake(1280, 720);
    self.framesPerSecond = 30;
    self.videoBitRate = 1500000;
    self.sampleRateInHz = 44100; // either 44100 or 22050

    // must be called _after_ we set up our properties, as our superclass
    // will use them in its viewDidLoad method
    [super viewDidLoad];

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

### Streaming Hooks

You may want to take certain actions before or after streaming. You can do that
in the `toggleStreaming` method. For example, you will likely want to enable /
disable the idle timer in this method as appropriate.


```objective-c
- (void)toggleStreaming:(id)sender
{
    switch(self.streamState) {
        case CineStreamStateNone:
        case CineStreamStatePreviewStarted:
        case CineStreamStateEnded:
        case CineStreamStateError:
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            break;
        default:
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            break;
    }

    // start / stop the actual stream
    [super toggleStreaming:sender];
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
