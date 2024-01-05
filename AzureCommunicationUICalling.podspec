Pod::Spec.new do |spec|
  spec.name                 = "AzureCommunicationUICalling"
  spec.version              = "1.11.19"
  spec.summary              = "UI Library to quickly integrate Azure Communication Calling Services experiences into your applications."
  spec.homepage             = "https://github.com/Depdx/communication-ui-library-ios"
  spec.license              = { :type => 'MIT' }
  spec.author               = 'Microsoft'
  spec.source               = { :git => 'https://github.com/Depdx/communication-ui-library-ios.git', :tag => '1.4.6' }
  spec.module_name          = 'AzureCommunicationUICalling'
  spec.swift_version        = '5.8'

  spec.platform             = :ios, '14.0'

  spec.source_files         = 'AzureCommunicationUI/sdk/AzureCommunicationUICalling/Sources/**/*.swift', 'AzureCommunicationUI/sdk/AzureCommunicationUICommon/Sources/AzureCommunicationUICommon/*.swift', 'AzureCommunicationUI/sdk/common/**/Sources/**/*.swift'
  spec.resources            = 'AzureCommunicationUI/sdk/AzureCommunicationUICalling/Sources/**/*.{xcassets,strings}'
  spec.pod_target_xcconfig  = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]": "arm64", "ENABLE_BITCODE": "NO"}
  spec.info_plist           = {'UILibrarySemVersion' => "#{spec.version}"}

  spec.dependency             'AzureCommunicationCalling', '2.6.1'
  spec.dependency             'AzureCore', '1.0.0-beta.15'
  spec.dependency             'MicrosoftFluentUI/Avatar_ios', '0.10.0'
  spec.dependency             'MicrosoftFluentUI/BottomSheet_ios', '0.10.0'
  spec.dependency             'MicrosoftFluentUI/Button_ios', '0.10.0'
  spec.dependency             'MicrosoftFluentUI/PopupMenu_ios', '0.10.0'
  spec.dependency             'MicrosoftFluentUI/ActivityIndicator_ios', '0.10.0'
  spec.dependency             'MicrosoftFluentUI/AvatarGroup_ios', '0.10.0'
end
