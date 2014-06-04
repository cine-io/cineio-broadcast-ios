Pod::Spec.new do |s|
  s.name                = "cineio-ios"
  s.version             = "0.1.0"
  s.summary             = "cine.io iOS SDK"
  s.description      = <<-DESC
                          iOS SDK for interacting with the cine.io API.
                          DESC
  s.homepage            = "https://github.com/cine-io/cineio-ios"
  s.license             = 'MIT'
  s.authors             = { "Jeffrey Wescott" => "jeffrey@cine.io" }
  s.source              = { :git => "https://github.com/cine-io/cineio-ios.git", :tag => s.version.to_s }

  s.requires_arc        = true

  s.header_dir          = 'cineio'
  s.header_mappings_dir = '.'

  s.source_files        = [ '**/*.h', '**/*.m' ]

  s.frameworks          = [ 'Foundation' ]

  s.dependency          'LRResty', '~> 0.11.0'

  s.ios.deployment_target = '6.0'
end
