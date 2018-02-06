//
//  RechabilityManager.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Alamofire
import Foundation

public enum VLNetworkReachabilityStatus: Int {
    
    case unknown
    case notReachable
    case reachableViaWWAN
    case reachableViaWiFi
    
    public var isReachable: Bool {
        switch self {
        case .notReachable:
            return false
        default:
            return true
        }
    }
}

final class VLReachabilityManager: NSObject {
    static let shared = VLReachabilityManager()
    fileprivate let manager = NetworkReachabilityManager()
    
    /// The current network reachability status.
    var networkReachabilityStatus: VLNetworkReachabilityStatus = .unknown
    
    /// A callback to be executed when the network availability changes.
    public var onReachabilityStatusChanged: ((VLNetworkReachabilityStatus) -> Void)?
    
    /// Whether or not the network is currently reachable.
    var isReachable: Bool {
        guard let manager = self.manager else { return true }
        return manager.isReachable || manager.networkReachabilityStatus == .unknown
    }
    
    fileprivate override init() {
        super.init()
        manager?.listener = { [unowned self] status in
            self.networkReachabilityStatus = status.convertToVLReachabilityStatus()
            self.onReachabilityStatusChanged?(self.networkReachabilityStatus)
            DispatchQueue.main.async {
                let notification = NotificationCenter.default
                let userInfo: [String: VLNetworkReachabilityStatus] = [VLReachabilityNotificationStatusItem: self.networkReachabilityStatus]
                notification.post(name: NSNotification.Name.VLNetworkingReachabilityDidChange, object: nil, userInfo: userInfo)
            }
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Start monitoring network reachability
    func startMonitoring() {
        manager?.startListening()
    }
    
    /// Stop monitoring network reachability
    func stopMonitoring() {
        manager?.stopListening()
    }
}

extension NetworkReachabilityManager.NetworkReachabilityStatus {
    func convertToVLReachabilityStatus() -> VLNetworkReachabilityStatus {
        switch self {
        case .notReachable:
            return VLNetworkReachabilityStatus.notReachable
        case .reachable(.ethernetOrWiFi):
            return VLNetworkReachabilityStatus.reachableViaWiFi
        case .reachable(.wwan):
            return VLNetworkReachabilityStatus.reachableViaWWAN
        default:
            return VLNetworkReachabilityStatus.unknown
        }
    }
}

extension NSNotification.Name {
    
    /// Posted when network reachability changes.
    public static let VLNetworkingReachabilityDidChange: NSNotification.Name = NSNotification.Name(rawValue: "com.pingwinator.VLNetworkingReachabilityDidChange")
}

public let VLReachabilityNotificationStatusItem: String = "com.pingwinator.VLNetworkingReachabilityDidChange"
