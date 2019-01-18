#
# Be sure to run `pod lib lint JLAuthorizationManagerSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JLAuthorizationManagerSwift'
  s.version          = '1.0.3'
  s.summary          = 'In swift, a Project can provide uniform method for system authorization accesses! '
  s.description      = <<-DESC
In swift, a Project can provide uniform method for system authorization accesses!
                       DESC

  s.homepage         = 'https://github.com/123sunxiaolin/JLAuthorizationManager-Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jacklin' => '401788217@qq.com' }
  s.source           = { :git => 'https://github.com/123sunxiaolin/JLAuthorizationManager-Swift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://123sunxiaolin.github.io'
  s.ios.deployment_target = '9.0'
  s.platform         = :ios, '9.0'
  s.swift_version    = '4.2'
  s.source_files     = 'JLAuthorizationManagerSwift/Classes/**/*'
  
  s.default_subspec  = 'All'
  
  s.subspec 'All' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Base/', 'JLAuthorizationManagerSwift/Classes/Permissions/'
  end
  
  s.subspec 'Base' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Base/*'
  end
  
  s.subspec 'AuthorizationManager' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/AuthorizationManager/*'#, 'JLAuthorizationManagerSwift/Base/Constants.swift', 'JLAuthorizationManagerSwift/AuthorizationManager/Base/PermissionType.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Camera' do |ss|
      ss.source_files ='JLAuthorizationManagerSwift/Classes/Permissions/CameraPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Microphone' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/AudioPermission.swift', 'JLAuthorizationManagerSwift/Classes/Permissions/MicrophonePermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Notification' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/NotificationPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Photos' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/PhotosPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'CellularNetwork' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/CellularNetworkPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Contact' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/ContactPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Events' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/EventsPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Reminder' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/ReminderPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Location' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/LocationInUsePermission.swift', 'JLAuthorizationManagerSwift/Classes/Permissions/LocationAlwaysPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'AppleMusic' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/AppleMusicPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'SpeechRecognizer' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/SpeechRecognizerPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Siri' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/SiriPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Motion' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/MotionPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Bluetooth' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/BluetoothPermission.swift', 'JLAuthorizationManagerSwift/Classes/Permissions/BluetoothPeripheralPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  s.subspec 'Health' do |ss|
      ss.source_files = 'JLAuthorizationManagerSwift/Classes/Permissions/HealthPermission.swift'
      ss.dependency 'JLAuthorizationManagerSwift/Base'
  end
  
  # s.resource_bundles = {
  #   'JLAuthorizationManagerSwift' => ['JLAuthorizationManagerSwift/Assets/*.png']
  # }
  
end
