#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tencent_effect_player.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tencent_effect_player'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }

  s.ios.framework    = ['AVFoundation' ,'Security']
  s.ios.library = 'z', 'c++'
  s.requires_arc = true

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.vendored_frameworks = 'Frameworks/libtcpag.xcframework', 'Frameworks/TCEffectPlayer.xcframework','Frameworks/TCMediaX.xcframework'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }


  s.xcconfig = { 
    'HEADER_SEARCH_PATHS' => [
      '${PODS_ROOT}/TCMediaX/TCMediaX/TCMediaX.xcframework/ios-arm64_armv7/TCMediaX.framework/Headers/',
      '${PODS_ROOT}/TCEffectPlayer/TCEffectPlayer/TCEffectPlayer.xcframework/ios-arm64_armv7/TCEffectPlayer.framework/Headers/',
    ],
    'OTHER_LDFLAGS' => '-ObjC'
  }

  # 添加合规属性
  s.resources = 'Frameworks/TCMediaX.xcframework/TCMediaX-Privacy.bundle'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'tencent_effect_player_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
