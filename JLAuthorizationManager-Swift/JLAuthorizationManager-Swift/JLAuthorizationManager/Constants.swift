//
//  Constants.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation

struct Constants {
    
    struct UserDefaultsKeys {
        static let requestedInUseToAlwaysUpgrade = "JL_requestedInUseToAlwaysUpgrade"
        static let requestedBluetooth            = "JL_requestedBluetooth"
        static let requestedMotion               = "JL_requestedMotion"
        static let requestedNotifications        = "JL_requestedNotifications"
    }
    
    struct InfoPlistKeys {
        static let camera                        = "NSCameraUsageDescription"
        static let locationWhenInUse             = "NSLocationWhenInUseUsageDescription"
        static let locationAlways                = "NSLocationAlwaysUsageDescription"
    }
}

extension Optional {
    /// avoid unwrap glue code
    var isNil: Bool {
        if case .none = self {
            return true
        }
        return false
    }
}
