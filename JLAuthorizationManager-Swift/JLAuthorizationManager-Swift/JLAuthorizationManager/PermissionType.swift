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
    case disabled // unsupport
}

public enum PermissionType {
    case camera
    case audio
    case photoLibrary
    case microphone
    case contact
    case events
    case reminder
    case locationInUse
    case locationInAlways
    case cellularNetwork
    case appleMusic
    case speechRecognizer
    case siri
    
    // TODO
    case notification
    
    // 需要特殊处理的
    case health
    case motion
    case bluetooth
    
    // 社交分享
    case twitter
    case facebook
    case sinaWeibo
    case tencentWeibo
    
}
