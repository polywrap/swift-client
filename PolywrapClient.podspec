Pod::Spec.new do |s|
  s.name             = 'PolywrapClient'
  s.version          = '0.0.3'
  s.summary          = 'A short description of PolywrapClient.'
  s.description      = 'A longer description of PolywrapClient.'
  s.homepage         = 'https://github.com/polywrap/swift-client'
  s.license          = 'MIT'
  s.author           = { 'Cesar' => 'cesar@polywrap.io' }

  s.source_files = 'Source/**/*.swift'
  s.swift_version  = "5.0"
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'

  s.dependency 'MessagePacker', '~> 0.4.7'
  s.dependency 'AsyncObjects', '~> 2.1.0'
  s.dependency 'PolywrapClientNative', "~> #{s.version}"
end
