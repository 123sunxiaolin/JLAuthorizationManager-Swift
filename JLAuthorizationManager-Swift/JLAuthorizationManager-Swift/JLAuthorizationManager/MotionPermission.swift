//
//  MotionPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import CoreMotion

class MotionPermission: BasePermission {

    private var completion: AuthorizedCompletion?
    
    private lazy var defaults: UserDefaults = {
        return .standard
    }()
    
    private lazy var motionManager:CMMotionActivityManager = {
        return CMMotionActivityManager()
    }()
    
    /// wheather request motion before or not
    private var isRequestedMotion: Bool {
        get {
            return defaults.bool(forKey: Constants.UserDefaultsKeys.requestedMotion)
        }
        
        set {
            defaults.set(isRequestedMotion, forKey: Constants.UserDefaultsKeys.requestedMotion)
            defaults.synchronize()
        }
    }
    
    /// wheather wait for user to enable or disable bluetooth access or not
    private var waitingForMotion: Bool = false
    
    /// Default status for Core Motion Activity
    private var motionPermissionStatus: AuthorizedStatus = .notDetermined
    
    override init() {
        super.init()
    }
}

// MARK: - Permission
extension MotionPermission: Permission {
    var type: PermissionType {
        return .motion
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        if isRequestedMotion {
            startUpdateMotionStatus()
        }
        
        return motionPermissionStatus
    }
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            self.completion = completion
            startUpdateMotionStatus()
        default:
            completion(status == .authorized)
        }
    }
}

// MARK: - Private
extension MotionPermission {
    private func startUpdateMotionStatus() {
        let hasAppleMusicKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.motion).isNil
        assert(hasAppleMusicKey, Constants.InfoPlistKeys.motion + " not found in Info.plist.")
        
        let tmpMotionPermissionStatus = motionPermissionStatus
        
        let today = Date()
        motionManager.queryActivityStarting(from: today, to: today, to: .main) { [weak self] (_, error) in
            
            if let err = error, err._code == CMErrorMotionActivityNotEntitled.rawValue {
                self?.motionPermissionStatus = .unAuthorized
            } else {
                self?.motionPermissionStatus = .authorized
            }
            
            self?.motionManager.stopActivityUpdates()
            if tmpMotionPermissionStatus != self?.motionPermissionStatus {
                self?.waitingForMotion = false
                if let completion = self?.completion {
                    completion(self?.motionPermissionStatus == .authorized)
                }
            }
        }
        
        isRequestedMotion = true
        waitingForMotion = true
    }
}
