Pod::Spec.new do |s|
  s.name             = 'PolywrapClientNative'
  s.version          = '0.0.5'
  s.summary          = 'Binary framework for Polywrap Client'
  s.homepage         = 'https://github.com/polywrap/swift-client'
  s.license          = 'MIT'
  s.author           = { 'Cesar' => 'cesar@polywrap.io' }
  s.swift_version    = "5.0"
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.source = { :http => "https://github.com/polywrap/swift-client/releases/download/v#{s.version}/PolywrapClientNative.xcframework.zip" }
  s.vendored_frameworks = 'Frameworks/PolywrapClientNative.xcframework'
end