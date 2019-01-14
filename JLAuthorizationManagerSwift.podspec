Pod::Spec.new do |s|
    s.name         = 'JLAuthorizationManagerSwift'
    s.version      = '1.0.0'
    s.summary      = 'In swift, a Project can provide uniform method for system authorization accesses! '
    s.homepage     = 'https://github.com/123sunxiaolin/JLAuthorizationManager-Swift'
    s.license      = 'MIT'
    s.authors      = {'Jacklin' => '401788217@qq.com'}
    s.platform     = :ios, '9.0'
    s.source_files = 'JLAuthorizationManager/*.{h,m}'
    s.description  = '🔑 JLAuthorizationManager is a project to show all develop process authorization managers.'
    s.social_media_url   = "https://123sunxiaolin.github.io"
    s.swift_version = '4.0'
    s.source       = {:git => 'https://github.com/123sunxiaolin/JLAuthorizationManager-Swift.git', :tag => s.version}
    s.default_subspec = "All"

    s.subspec 'All' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/*.{h,m}'
    end

    s.subspec 'AuthorizationManager' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/AuthorizationManager/', 'JLAuthorizationManagerSwift/Base/Constants.swift', 'JLAuthorizationManagerSwift/AuthorizationManager/Base/PermissionType.swift'
    end

    s.subspec 'Camera' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/CameraPermission.swift'
    end

    s.subspec 'Microphone' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/AudioPermission.swift', 'JLAuthorizationManagerSwift/Permissions/MicrophonePermission.swift'
    end

    s.subspec 'Notification' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/NotificationPermission.swift'
    end

    s.subspec 'Photos' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/PhotosPermission.swift'
    end

    s.subspec 'CellularNetwork' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/CellularNetworkPermission.swift'
    end

    s.subspec 'Contact' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/ContactPermission.swift'
    end

    s.subspec 'Events' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/EventsPermission.swift'
    end

    s.subspec 'Reminder' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/ReminderPermission.swift'
    end

    s.subspec 'Location' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/LocationInUsePermission.swift', 'JLAuthorizationManagerSwift/Permissions/LocationAlwaysPermission.swift'
    end

    s.subspec 'AppleMusic' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/AppleMusicPermission.swift'
    end

    s.subspec 'SpeechRecognizer' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/SpeechRecognizerPermission.swift'
    end

    s.subspec 'Siri' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/SiriPermission.swift'
    end

    s.subspec 'Motion' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/MotionPermission.swift'
    end

    s.subspec 'Bluetooth' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/BluetoothPermission.swift', , 'JLAuthorizationManagerSwift/Permissions/BluetoothPeripheralPermission.swift'
    end

    s.subspec 'Health' do |ss|
        ss.source_files = 'JLAuthorizationManagerSwift/Base/', 'JLAuthorizationManagerSwift/Permissions/HealthPermission.swift'
    end

end