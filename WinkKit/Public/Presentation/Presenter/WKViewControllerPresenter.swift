//
//  WKViewControllerPresenter.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 05/08/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation

/// The base `WKPresenter` that is already bound with ViewController lifecycle.
/// Al methods have default implementation that does nothing, so you can implement
/// only methods you want.
public protocol WKGenericViewControllerPresenter: WKPresenter {
    
    /// Any type of object that will be pased in the initializer of this presenter, to provide some initial data.
    associatedtype InitObject = Void
    
    /// At this time `view` property is still nil. You can perform additional
    ///
    /// - Parameter object: Provide initial data to the presenter. For instance: you show a list of recipes in a view controller and in another one you want to show the detail; to fetch all detail information you need an ID that is passed from the previous screen. The presenter needs that ID to fetch the whole recipe information and you can pass it in this initializer. By default `InitObject` is of `Void` type.
    init(with object: InitObject)
    
    /// Called by the framework after `view` property has been assigned. Here the view is guaranted to be not nil. Default does nothing.
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
    init(view: View, initObject: InitObject) {
        self.init(with: initObject)
        self.view = view
        presenterInitialized()
    }
    
    func presenterInitialized() {
        // default does nothing
    }
    
    func viewDidLoad() {
        // default does nothing
    }
    
    func viewWillAppear() {
        // default does nothing
    }
    
    func viewDidAppear() {
        // default does nothing
    }
    
    func viewWillDisappear() {
        // default does nothing
    }
    
    func viewDidDisappear() {
        // default does nothing
    }
    
    func viewDidDestroy() {
        // default does nothing
    }
    
}
