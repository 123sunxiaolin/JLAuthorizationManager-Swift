//
//  PermissionType.swift
//  JLAuthorizationManager-Swift
//
//  Created by Jacklin on 2019/1/10.
//  Copyright © 2019年 Jacklin. All rights reserved.
//

public enum AuthorizedStatus {
    case authorized
    case unAuthorized
    case notDetermined
    case disabled // unsupported
}

public enum PermissionType {
    case camera
    case audio
    case notification
    case photoLibrary
    case cellularNetwork
    case microphone
    case contact
    case events
    case reminder
    case locationInUse
    case locationInAlways
    case appleMusic
    case speechRecognizer
    case siri
    case motion
    case bluetooth
    case peripheralBluetooth
    case health
}
