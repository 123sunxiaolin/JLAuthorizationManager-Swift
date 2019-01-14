//
//  LocationInUsePermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import CoreLocation

// please use singleton: `shared`
class LocationInUsePermission: BasePermission {
    
    static let shared = LocationInUsePermission()
    private var completion: AuthorizedCompletion?
    
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    private override init() {
        super.init()
    }
}

// MARK: - Permission
extension LocationInUsePermission: Permission {
    var type: PermissionType {
        return .locationInUse
    }
    
    func authorizedStatus() -> AuthorizedStatus {
        guard CLLocationManager.locationServicesEnabled() else { return .disabled }
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .restricted, .denied:
            return .unAuthorized
        case .notDetermined:
            return .notDetermined
        }
    }
    
    func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasLocationWhenInUseKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.locationWhenInUse).isNil
         assert(hasLocationWhenInUseKey, Constants.InfoPlistKeys.locationWhenInUse + " not found in Info.plist.")
        
        self.completion = completion
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        default:
            completion(status == .authorized)
        }
    }
}

extension LocationInUsePermission: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let completion = self.completion {
            completion(status == .authorizedWhenInUse)
        }
    }
}
