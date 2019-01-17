Pod::Spec.new do |s|
    s.name         = 'JLAuthorizationManagerSwift'
    s.version      = '1.0.0'
    s.summary      = 'In swift, a Project can provide uniform method for system authorization accesses! '
    s.homepage     = 'https://github.com/123sunxiaolin/JLAuthorizationManager-Swift'
    s.license      = 'MIT'
    s.authors      = {'Jacklin' => '401788217@qq.com'}
    s.platform     = :ios, '9.0'
    s.description  = '🔑 JLAuthorizationManagerSwift is a project to show all develop process authorization managers.'
    s.social_media_url   = "https://123sunxiaolin.github.io"
    s.swift_version = '4.0'
    s.source       = {:git => 'https://github.com/123sunxiaolin/JLAuthorizationManager-Swift.git', :tag => s.version}
    s.default_subspec = "All"

    s.subspec 'All' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/*'
    end

    s.subspec 'Base' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/*'
    end

    s.subspec 'AuthorizationManager' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/AuthorizationManager/*', 'JLAuthorizationManagerSwift/Base/Constants.swift', 'JLAuthorizationManagerSwift/AuthorizationManager/Base/PermissionType.swift'
    end

    s.subspec 'Camera' do |ss|
        ss.source_files ='JLAuthorizationManagerSwift/Permissions/CameraPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Microphone' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/AudioPermission.swift', 'JLAuthorizationManagerSwift/Permissions/MicrophonePermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Notification' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/NotificationPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Photos' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/PhotosPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'CellularNetwork' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/CellularNetworkPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Contact' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/ContactPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Events' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/EventsPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Reminder' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/ReminderPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Location' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/LocationInUsePermission.swift', 'JLAuthorizationManagerSwift/Permissions/LocationAlwaysPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'AppleMusic' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/AppleMusicPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'SpeechRecognizer' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/SpeechRecognizerPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Siri' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/SiriPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Motion' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/MotionPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Bluetooth' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/BluetoothPermission.swift', 'JLAuthorizationManagerSwift/Permissions/BluetoothPeripheralPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

    s.subspec 'Health' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Permissions/HealthPermission.swift'
        ss.dependency "JLAuthorizationManagerSwift/Base"
    end

end