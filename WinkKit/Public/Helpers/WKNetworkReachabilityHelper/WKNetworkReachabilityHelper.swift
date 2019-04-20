//
//  File.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 15/01/18.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Alamofire

/// The object that will observe network changing. Tipically a presenter.
/// `WKNetworkObservableViewControllerPresenter` already conforms to this protocol.
public protocol WKNetworkObserver: AnyObject {
    
    /// Called when the network status did change.
    ///
    /// - Parameter status: The new status.
    func networkStatusDidChange(to status: NetworkReachabilityManager.NetworkReachabilityStatus)
    
}

/// Helper class that allows to listen to network changes. It uses Alamofire's `NetworkReachabilityManager`.
open class WKNetworkReachabilityHelper {
    
    /// The default instance of this helper.
    public static let `default` = WKNetworkReachabilityHelper()
    
    /// The Alamofire reachability manager.
    private let networkReachability = NetworkReachabilityManager(host: "www.google.com")
    
    /// Array of all observers.
    private(set) var observers = [WKNetworkObserver]()
    
    /// Initialize the helper.
    private init() {
        networkReachability?.listener = { [weak self] status in
            guard let aliveSelf = self else { return }
            aliveSelf.observers.forEach { $0.networkStatusDidChange(to: status) }
        }
        networkReachability?.startListening()
    }
    
    /// Return true if network is available, otherwise false.
    open var isNetworkAvailable: Bool {
        return networkReachability?.isReachable ?? false
    }
    
    /// Add a new observer to list of all observers.
    ///
    /// - Parameter observer: The observer to add.
    public func addObserver(_ observer: WKNetworkObserver) {
        observers.append(observer)
    }
    
    /// Remove the observer, if exists in list, otherwise does nothing.
    /// To find the observer it's used === operator.
    ///
    /// - Parameter observer: The observer to remove.
    public func removeObserver(_ observer: WKNetworkObserver) {
        observers.removeAll { $0 === observer }
    }
    
    deinit {
        networkReachability?.stopListening()
        observers.removeAll()
    }
    
    
}

