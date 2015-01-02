Pod::Spec.new do |s|
  s.name                = "cineio-broadcast-ios"
  s.version             = "0.6.1"
  s.summary             = "cine.io Broadcast iOS SDK"
  s.description      = <<-DESC
                          iOS SDK for Broadcasting using the cine.io API.
                          DESC
  s.homepage            = "https://github.com/cine-io/cineio-broadcast-ios"
  s.license             = 'MIT'
  s.authors             = { "Jeffrey Wescott" => "jeffrey@cine.io" }
  s.source              = { :git => "https://github.com/cine-io/cineio-broadcast-ios.git", :tag => s.version.to_s }

  s.requires_arc        = true

  s.header_dir          = 'cineio'

  s.source_files        = [ 'cineio-broadcast-ios/cineio-broadcast-ios/*.h',
                            'cineio-broadcast-ios/cineio-broadcast-ios/*.m*',
                            'cineio-broadcast-ios/cineio-broadcast-ios/*.c*' ]

  s.frameworks          = [ 'Foundation', 'UIKit', 'QuartzCore', 'CoreGraphics', 'CoreAudio', 'CoreMedia', 'AudioToolbox', 'AVFoundation', 'MediaPlayer' ]

  s.dependency          'AFNetworking', '~> 2.4.1'
  s.dependency          'VideoCore', '~> 0.2.1.2'

  # propagated from VideoCore
  s.xcconfig            = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/boost" }

  s.ios.deployment_target = '6.0'
end
