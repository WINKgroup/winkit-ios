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
public protocol WKViewControllerPresenter: WKPresenter {
    
    func viewDidLoad()
    
    func viewWillAppear()
    
    func viewDidAppear()
    
    func viewWillDisappear()
    
    func viewDidDisappear()
    
}

/// Default implementation with nothing done.
public extension WKViewControllerPresenter {
    
    func viewDidLoad() { /* does nothing */ }
    
    func viewWillAppear() { /* does nothing */ }
    
    func viewDidAppear() { /* does nothing */ }
    
    func viewWillDisappear() { /* does nothing */ }
    
    func viewDidDisappear() { /* does nothing */ }
    
}
