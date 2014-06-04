# cineio-ios - cine.io iOS SDK

This is the [cine.io][cineio] iOS SDK.

## Installation

The easiest way to use the SDK is via [CocoaPods][cocoapods]. Create a new XCode project with a file named `Podfile` that contains at least the following:

```ruby
platform :ios, '6.0'

pod 'cineio-ios', '~> 0.1.0'
```

Then, install the Pod by running the `pod install` command:

```bash
pod install
```

Then you can open the project using the `<project>.xcworkspace` file:

``bash
open <project>.xcworkspace
```

## Usage

### Import the SDK

```objective-c
#import <cineio/CineIO.h>
```

### Instantiate the client

```objective-c
CineClient *client = [[CineClient alloc] initWithSecretKey:@"6e95ce96660bae74c954e291ea5b3e90"];
```

### Get your project (asynchronously)

```objective-c
[client getProjectWithCompletionHandler:^(NSError *error, CineProject *project) {
    // do something
}];
```

### Get your streams (asynchronously)

```objective-c
[project getStreamsWithCompletionHandler:^(NSError *err, NSArray *streams) {
    for (id object in streams) {
        CineStream *stream = (CineStream *)object;
        // do something
    }
}];
```

## Publishing

We recommend the excellent[VideoCore][VideoCore] library for publishing streams to the RTMP publishing endpoint.


## Playback

Every `CineStream` object has an `playUrlHLS` property. It should be possible to hook this up to an `MPMoviePlayerController` and you'll be on your way.


## TODO

- Working sample application for publishing.
- Working sample application for playback.


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
