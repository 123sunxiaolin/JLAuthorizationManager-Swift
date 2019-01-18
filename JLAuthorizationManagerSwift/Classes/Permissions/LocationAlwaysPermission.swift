//
//  LocationAlwaysPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import CoreLocation

// please use singleton: `shared`
public class LocationAlwaysPermission: BasePermission {
    
    public static let shared = LocationAlwaysPermission()
    private var completion: AuthorizedCompletion?
    
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    private lazy var defaults: UserDefaults = {
        return .standard
    }()
    
    private override init() {
        super.init()
    }
}

// MARK: - Permission
extension LocationAlwaysPermission: Permission {
    public var type: PermissionType {
        return .locationInAlways
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .disabled }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            return .authorized
        case .authorizedWhenInUse:
            // InUse to Always upgrade case
            if defaults.bool(forKey: Constants.UserDefaultsKeys.requestedInUseToAlwaysUpgrade) {
                return .unAuthorized
            }
            return .notDetermined
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
        }
    }
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasLocationAlwaysUseKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.locationAlways).isNil
        assert(hasLocationAlwaysUseKey, Constants.InfoPlistKeys.locationAlways + " not found in Info.plist.")
        
        self.completion = completion
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                defaults.set(true, forKey: Constants.UserDefaultsKeys.requestedInUseToAlwaysUpgrade)
                defaults.synchronize()
            }
            locationManager.requestAlwaysAuthorization()
        default:
            completion(status == .authorized)
        }
    }
}

extension LocationAlwaysPermission: CLLocationManagerDelegate {
    private func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let completion = self.completion {
            completion(status == .authorizedAlways)
        }
    }
}

