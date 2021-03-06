//
//  ContactPermission.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

import Foundation
import Contacts
import AddressBook

public class ContactPermission: BasePermission {
    
    public override init() {
        super.init()
    }
}

// MARK: - Permission
extension ContactPermission: Permission {
    public var type: PermissionType {
        return .contact
    }
    
    public func authorizedStatus() -> AuthorizedStatus {
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            switch status {
            case .authorized:
                return .authorized
            case .restricted, .denied:
                return .unAuthorized
            case .notDetermined:
                return .notDetermined
            }
        } else {
            let status = ABAddressBookGetAuthorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .restricted, .denied:
                return .unAuthorized
            case .notDetermined:
                return .notDetermined
            }
        }
    }
    
    public func requestPermission(_ completion: @escaping AuthorizedCompletion) {
        let hasContactKey: Bool = !Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.contact).isNil
        assert(hasContactKey, Constants.InfoPlistKeys.contact + " not found in Info.plist.")
        
        let status = authorizedStatus()
        switch status {
        case .notDetermined:
            if #available(iOS 9.0, *) {
                CNContactStore().requestAccess(for: .contacts) { (granted, _) in
                    self.safeAync {
                        completion(granted)
                    }
                }
            } else {
                ABAddressBookRequestAccessWithCompletion(nil) { (granted, _) in
                    self.safeAync {
                        completion(granted)
                    }
                }
            }
        default:
            completion(status == .authorized)
        }
    }
    
}
