Pod::Spec.new do |s|
  s.name                = "arenacloud-broadcast-ios"
  s.version             = "0.8.0"
  s.summary             = "ArenaCloud Broadcast iOS SDK"
  s.description      = <<-DESC
                          iOS SDK for Broadcasting using the ArenaCloud API.
                          DESC
  s.homepage            = "https://github.com/ArenaCloud/arenacloud-broadcast-ios"
  s.license             = 'MIT'

  s.authors             = { "Jeffrey Wescott" => "jeffrey@cine.io",
                            "Wang Wenlin" => "sopl.wang@gmail.com" }

  s.source              = { :git => "https://github.com/ArenaCloud/arenacloud-broadcast-ios.git", :tag => s.version.to_s }

  s.requires_arc        = true

  s.header_dir          = 'ArenaCloud/broadcast'

  s.source_files        = [ 'arenacloud-broadcast-ios/arenacloud-broadcast-ios/*.h',
                            'arenacloud-broadcast-ios/arenacloud-broadcast-ios/*.m*',
                            'arenacloud-broadcast-ios/arenacloud-broadcast-ios/*.c*' ]

  s.frameworks          = [ 'Foundation', 'UIKit', 'QuartzCore', 'CoreGraphics', 'CoreAudio', 'CoreMedia', 'AudioToolbox', 'AVFoundation', 'MediaPlayer' ]

  s.dependency          'AFNetworking', '~> 2.5'
  s.dependency          'VideoCore', '~> 0.3'
  s.dependency          'ijkplayer', '~> 1.1'

  # propagated from VideoCore
  s.xcconfig            = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/boost" }

  s.ios.deployment_target = '8.0'
end
