Pod::Spec.new do |s|
  s.name                = "cineio-ios"
  s.version             = "0.1.4"
  s.summary             = "cine.io iOS SDK"
  s.description      = <<-DESC
                          iOS SDK for interacting with the cine.io API.
                          DESC
  s.homepage            = "https://github.com/cine-io/cineio-ios"
  s.license             = 'MIT'
  s.authors             = { "Jeffrey Wescott" => "jeffrey@cine.io" }
  s.source              = { :git => "https://github.com/cine-io/cineio-ios.git", :tag => s.version.to_s }

  s.requires_arc        = false

  s.header_dir          = 'cineio'

  s.source_files        = [ 'cineio-ios/cineio-ios/*.h', 'cineio-ios/cineio-ios/*.m' ]

  s.frameworks          = [ 'Foundation' ]

  s.dependency          'AFNetworking', '~> 2.2.4'

  s.ios.deployment_target = '6.0'
end
