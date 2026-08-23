#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint whisper_edge.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'whisper_edge'
  s.version          = '0.1.1'
  s.summary          = 'On-device speech-to-text for Flutter, powered by whisper.cpp.'
  s.description      = <<-DESC
Offline transcription for iOS built on whisper.cpp. Ships a prebuilt
whisper.xcframework (Metal + Accelerate) plus a small C shim exposed to
Dart over FFI.
                       DESC
  s.homepage         = 'https://popy.app'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Popy' => 'haydar@motivolog.com' }

  # Classes contains a forwarder C file that relatively imports the shim in
  # ../src, because podspecs cannot reference sources outside the pod root.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.vendored_frameworks = 'Frameworks/whisper.xcframework'
  s.dependency 'Flutter'
  # Matches the deployment target of the vendored whisper.xcframework
  # (build-xcframework.sh uses IOS_MIN_OS_VERSION=16.4).
  s.platform = :ios, '16.4'

  s.frameworks = 'Accelerate', 'Metal', 'MetalKit', 'Foundation'
  s.libraries  = 'c++'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    # The shim is plain C (no module import), so Xcode's auto-linking never
    # kicks in — link the vendored framework explicitly.
    'OTHER_LDFLAGS' => '$(inherited) -framework whisper',
    'HEADER_SEARCH_PATHS' => [
      '"$(PODS_TARGET_SRCROOT)/../src/whisper.cpp/include"',
      '"$(PODS_TARGET_SRCROOT)/../src/whisper.cpp/ggml/include"',
    ].join(' '),
  }
  s.swift_version = '5.0'
end
