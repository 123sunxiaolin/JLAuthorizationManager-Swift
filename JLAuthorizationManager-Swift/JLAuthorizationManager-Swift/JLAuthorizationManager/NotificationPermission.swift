//
//  NotificationPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import UIKit
import UserNotifications

protocol NotificationPermissionProtocol: Permission {
    
    /// For iOS 10.0, async fetch notification permission
    ///
    /// - Parameter handler: return result
    func asyncFetchAuthorizedStatus(_ handler: @escaping (AuthorizedStatus) -> Void)
}

class NotificationPermission: BasePermission {

    private var completion: AuthorizedCompletion?
    
    private lazy var defaults: UserDefaults = {
        return .standard
    }()
    
    private var currentAuthorizedStatus: AuthorizedStatus = .notDetermined
    
    /**
     A timer that fires the event to let us know the user has asked for
     notifications permission.
     */
     private var notificationTimer : Timer?
    
    
    /// wheather authorzed notification
    private var isAuthorizedNotification: Bool {
        get {
            return defaults.bool(forKey: Constants.UserDefaultsKeys.requestedNotifications)
        }
        
        set {
            defaults.set(isAuthorizedNotification, forKey: Constants.UserDefaultsKeys.requestedBluetooth)
            defaults.synchronize()
        }
    }
    
    override init() {
        super.init()
    }
}

// MARK: - NotificationPermissionProtocol
extension NotificationPermission: NotificationPermissionProtocol {
    var type: PermissionType {
        return .notification
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        
        if #available(iOS 10.0, *) {
            return self.currentAuthorizedStatus
        } else {
            let settings = UIApplication.shared.currentUserNotificationSettings
            if let settingsType = settings?.types,
                settingsType != UIUserNotificationType() {
                return .authorized
            } else {
                // 存在问题，
                if isAuthorizedNotification {
                    return .authorized
                } else {
                    return .unAuthorized
                }
            }
            
        }
    }
    
    func asyncFetchAuthorizedStatus(_ handler: @escaping (AuthorizedStatus) -> Void) {
        guard #available(iOS 10.0, *) else {
            self.currentAuthorizedStatus = .disabled
            handler(.disabled)
            return
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            var tempStatus: AuthorizedStatus = .notDetermined
            switch settings.authorizationStatus {
            case .authorized:
                tempStatus = .authorized
            case .notDetermined:
                tempStatus = .notDetermined
            case .denied:
                tempStatus = .unAuthorized
            default:
                // provisional: In iOS 12.0, can provide for, otherwise, return notDetermined
                if #available(iOS 12.0, *) {
                    tempStatus = .authorized
                } else {
                    tempStatus = .notDetermined
                }
            }
            
            self.currentAuthorizedStatus = tempStatus
            
            self.safeAync {
                handler(tempStatus)
            }
        }
        
    }
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            if #available(iOS 10.0, *) {
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { granted, _ in
                    self.safeAync {
                        completion(granted)
                    }
                }
            } else {
                self.completion = completion
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(requestingNotificationPermission),
                                                       name: UIApplication.willResignActiveNotification,
                                                       object: nil)
                
                notificationTimer = Timer.scheduledTimer(timeInterval: 1,
                                                         target: self,
                                                         selector: #selector(finishedRequestNotificationPermission),
                                                         userInfo: nil,
                                                         repeats: false)
                
                UIApplication.shared.registerUserNotificationSettings(
                    UIUserNotificationSettings(types: [.alert, .sound, .badge],
                                               categories: nil)
                )
            }
            
        default:
            completion(status == .authorized)
        }
    }
    
}

// MARK: - Action
extension NotificationPermission {
    @objc func requestingNotificationPermission() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willResignActiveNotification,
                                                  object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(finishedRequestNotificationPermission),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        notificationTimer?.invalidate()
    }
    
    @objc func finishedRequestNotificationPermission() {
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willResignActiveNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
        
        notificationTimer?.invalidate()
        
        isAuthorizedNotification = true
        
        if let completion = self.completion {
            completion(isAuthorizedNotification)
        }
    }
}

