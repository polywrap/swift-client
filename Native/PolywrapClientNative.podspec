Pod::Spec.new do |s|
  s.name             = 'PolywrapClientNative'
  s.version          = '0.0.3'
  s.summary          = 'A short description of PolywrapClient.'
  s.homepage         = 'https://github.com/polywrap/swift-client'
  s.license          = 'MIT'
  s.author           = { 'Cesar' => 'cesar@polywrap.io' }
  s.source           = { :http => "https://github.com/polywrap/swift-client/releases/download/v#{s.version}/PolywrapClientNative.xcframework.zip" }
  s.source_files     = "PolywrapClientNativeLib.swift"

  s.swift_version  = "5.0"

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  
  s.vendored_frameworks = "Frameworks/PolywrapClientNative.xcframework"
end
