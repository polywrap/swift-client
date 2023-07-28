Pod::Spec.new do |s|
  s.name             = 'PolywrapClient'
  s.version          = '0.0.5'
  s.summary          = 'Implementation of a client compatible with the WRAP Protocol in Swift'
  s.homepage         = 'https://github.com/polywrap/swift-client'
  s.license          = 'MIT'
  s.author           = { 'Cesar' => 'cesar@polywrap.io' }

  s.source_files = 'Source/**/*.swift'
  s.swift_version  = "5.0"
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.source = { :git => "https://github.com/polywrap/swift-client.git", :branch => 'main' }
  s.static_framework = true
  s.dependency 'PolywrapClientNative', '~> 0.0.4'
  s.dependency 'MessagePacker', '~> 0.4.7'
  s.dependency 'AsyncObjects', '~> 2.1.0'
end