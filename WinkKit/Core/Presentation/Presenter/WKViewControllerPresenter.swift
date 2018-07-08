//
//  WKViewControllerPresenter.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 05/08/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation
import Alamofire

/// The base `WKPresenter` that is already bound with ViewController lifecycle.
/// Al methods have default implementation that does nothing, so you can implement
/// only methods you want.
public protocol WKGenericViewControllerPresenter: WKPresenter {
    
    /// Required an empty initializer. At this time `view` property is still nil. You can perform additional
    /// initialization here.
    init()
    
    /// Called by the `WinkKit` framework after `view` property assignin. Here the view is guaranted to be not nil. Defualt does nothing.
    func presenterInitialized()
    
    /// Called by the view controller in `viewDidLoad()`. The default implementation does nothing.
    func viewDidLoad()
    
    /// Called by the view controller in `viewWillAppear(_:)`. The default implementation does nothing.
    func viewWillAppear()
    
    /// Called by the view controller in `viewDidAppear(_:)`. The default implementation does nothing.
    func viewDidAppear()
    
    /// Called by the view controller in `viewWillDisappear(_:)`. The default implementation does nothing.
    func viewWillDisappear()
    
    /// Called by the view controller in `viewDidDisappear(_:)`. The default implementation does nothing.
    func viewDidDisappear()
    
    /// Called by the view controller in `deinit`. The default implementation does nothing.
    func viewDidDestroy()
}

public extension WKGenericViewControllerPresenter {
    
    /// An alternative `init` internally used to auto-assign the view.
    init(view: View, _: Void) {
        self.init()
        self.view = view
        presenterInitialized()
    }
    
    public func presenterInitialized() {
        // default does nothing
    }
    
    public func viewDidLoad() {
        // default does nothing
    }
    
    public func viewWillAppear() {
        // default does nothing
    }
    
    public func viewDidAppear() {
        // default does nothing
    }
    
    public func viewWillDisappear() {
        // default does nothing
    }
    
    public func viewDidDisappear() {
        // default does nothing
    }
    
    public func viewDidDestroy() {
        // default does nothing
    }
    
}

/// A `WKPresentableView` that is used when a view should update its own state on network changes.
public protocol NetworkObservableView: WKPresentableView {
    
    /// Called by presenter when network become available.
    func networkDidBecomeAvailable()
    
    /// Called by presenter when network become unavailable.
    func networkDidBecomeUnvailable()
}

/// A concrete `WKGenericViewControllerPresenter` that uses the `WKNetworkReachabilityHelper` to observe
/// network changes.
open class WKNetworkObservableViewControllerPresenter: WKGenericViewControllerPresenter, WKNetworkObserver {
    
    public typealias View = NetworkObservableView
    
    open weak var view: NetworkObservableView?
    
    public required init() {
        WKNetworkReachabilityHelper.default.addObserver(self)
    }
    
    /// Called only if `shouldObserveNetworkChanges` is true.
    open func networkStatusDidChange(to status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        if case .reachable = status {
            view?.networkDidBecomeAvailable()
        } else {
            view?.networkDidBecomeUnvailable()
        }
    }
    
    deinit {
        WKNetworkReachabilityHelper.default.removeObserver(self)
    }

}
