JLAuthorizationManagerSwift

![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
[![Version](https://img.shields.io/cocoapods/v/JLAuthorizationManagerSwift.svg?style=flat)](https://cocoapods.org/pods/JLAuthorizationManagerSwift) 
[![License](https://img.shields.io/cocoapods/l/JLAuthorizationManagerSwift.svg?style=flat)](https://cocoapods.org/pods/JLAuthorizationManagerSwift) 
[![Platform](https://img.shields.io/cocoapods/p/JLAuthorizationManagerSwift.svg?style=flat)](https://cocoapods.org/pods/JLAuthorizationManagerSwift)
---

[英文文档](https://github.com/123sunxiaolin/JLAuthorizationManager-Swift)

[Objective-C版本在这里](https://github.com/123sunxiaolin/JLAuthorizationManager)

🔑 **JLAuthorizationManagerSwift** 是一个易用、轻量化、完整以及线程安全的**iOS**权限管理开源库，目前支持**Objective-C**和**Swift**两种语言。

## 基本特性

- [x] 覆盖面全，目前支持拍照、相册、蜂窝网络、麦克风、日历、提醒事项、通知、定位、音乐库、语音识别、Siri、蓝牙、健康数据、体能与训练记录等权限访问；
- [x] 使用方法简单，接口统一，单一权限文件分离，避免因添加无用权限导致提交**App Store**审核不过的问题；
- [x] 异步请求权限，在主线程下回调；
- [x] 提供单例模式下的所有权限访问和单一权限访问的两种方式，便于开发者更加灵活的使用；

入门
------------
### 基本要求
- **JLAuthorizationManagerSwift**支持iOS 8.0及以上；
- **JLAuthorizationManagerSwift**需使用Xcode 8.0以上版本进行编译；

### 安装
- 使用**Cocoapods**进行安装：
<br>1.先安装[Cocoapods](https://guides.cocoapods.org/using/getting-started.html);
<br>2.通过**pod repo update**更新**JLAuthorizationManagerSwift**的**Cocoapods**版本;
<br>3.在**Podfile**对应的target中，根据业务需要添加指定的pod, 如下所示，然后执行**pod install**,在项目中使用**CocoaPods**生成的.xcworkspace运行工程;

```
// 与 pod 'JLAuthorizationManagerSwift/All' 等价
pod 'JLAuthorizationManagerSwift' 
或
pod 'JLAuthorizationManagerSwift/AuthorizationManager'
或
pod 'JLAuthorizationManagerSwift/Camera'
或
pod 'JLAuthorizationManagerSwift/Microphone'
...

```
- 手动安装
<br>1.首先，在地址**https://github.com/123sunxiaolin/JLAuthorizationManagerSwift.git**将项目克隆下来；
<br>2.找到工程目录下的路径JLAuthorizationManagerSwift/Classes,必须导入**Base**文件夹，其他文件根据业务需求自定义导入到工程中即可。

使用
------------
#### **JLAuthorizationManager**使用：
- 1.使用`shared`单例方法进行API的调用；
- 2.使用统一方法调用：

```
public func requestPermission(_ type: PermissionType,
                                  completion: @escaping PermissionCompletion)
                                 
 // 健康数据
 public func requestHealthPermission(_ typesToShare: Set<HKSampleType>,
                                        typesToRead: Set<HKObjectType>,
                                        completion: @escaping PermissionCompletion)
                                 
```

### 单一权限文件的使用**xxxPermission**:

- 1.每一个权限类继承自**BasePermisssion**基类，实现统一的接口协议**Permission**:

```
public protocol Permission where Self: BasePermission {
    
    /// Permission type
    var type: PermissionType { get }
    
    /// Current authorized status
    func authorizedStatus() -> AuthorizedStatus
    
    /// Request current permission
    func requestPermission(_ completion: @escaping AuthorizedCompletion)
    
}

```

- 基本使用（以请求相册权限为例说明）:

```
let permission = PhotosPermission()
print("\(type.title) -> status:\(permission.authorizedStatus())")
permission.requestPermission { granted in
	print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
}
```

- 请求定位、蓝牙等权限时，需要使用其单例方法**shared**进行调用，以请求定位信息为例说明：

```
let permission = LocationAlwaysPermission.shared
print("\(type.title) -> status:\(permission.authorizedStatus())")
permission.requestPermission { granted in
	print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
}
```

- 请求健康数据权限：

```
let permission = HealthPermission(typesToShare, typesToRead: typesToRead)
print("\(type.title) -> status:\(permission.authorizedStatus())")
permission.requestPermission { granted in
	print(granted ? "已授权 -> \(type.title)" : "未授权 -> \(type.title)")
}
```

更多用法请参照**DEMO**

注意事项
------------
- 1、切记在使用权限前，需要在**Info.plist**添加对应的Key;
- 2、在使用健康数据(HealthKit)或者Siri权限的时候，需要在**Capabilities**中打开对应的开关，同时，Xcode会自动生成**xx.entitlements**文件；
- 如果项目不提交至App Store，可以使用统一权限管理文件**JLAuthorizationManagerSwift**;如需提交App Store，则需根据业务需求添加对应的权限请求文件，否则，会因添加无用权限导致App Store被拒。

版本更新
------------
- **v1.0.4** (2019-2-12): 修复相关Bug; 
- **v1.0.3** (2019-1-18): 更新项目文件结构;
- **v1.0.0** (2019-1-17): 将权限拆分成单一文件，提供更加灵活、可扩展性的方法，以及解决了因添加无用权限导致App Store被拒的问题;

问题与改进
------------
- 如您在使用该开源库过程中，遇到一些bug或者需要改进的地方，您可以直接创建**issue**说明，如您有更好的实现方式，欢迎**Pull Request**

讨论与学习
------------
- iOS讨论群：**709148214**
- 微信公众号：猿视角(**iOSDevSkills**)，分享技术相关文章
- 个人微信：**401788217**
- [个人简书](https://www.jianshu.com/u/ef991f6d241c)

License
-------

JLAuthorizationManagerSwift is under MIT license. See the [LICENSE](https://github.com/123sunxiaolin/JLAuthorizationManager-Swift/blob/master/LICENSE) file for more info.