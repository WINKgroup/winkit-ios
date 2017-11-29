//
//  WKNavigationController.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 29/11/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// The `WinkKit` navigation controller. It inherits the static instantiation feature, and add other stuff.
@IBDesignable
open class WKNavigationController: UINavigationController, WKInstantiableViewController {
    
    private var _prefersChildStatusBarStyle = false
    
    /// If true, the child view controller will controll the `preferredStatusBarStyle`. Default is `false`.
    @IBInspectable
    public var prefersChildStatusBarStyle: Bool {
        set {
            _prefersChildStatusBarStyle = newValue
        }
        get {
            return _prefersChildStatusBarStyle
        }
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return prefersChildStatusBarStyle ? self.topViewController : nil
    }
    
    /// If your project has a storyboard that contains an instance of the subclass of this view controller,
    /// you can override this property to indicate the name of that storyboard to allow auto-instantiation feature
    open class var storyboardName: String? {
        return nil
    }
    
    /// The identifier that is set in Storybaord. Default value is `String(describing: self)`, which means that
    /// the identifier of the view controller is the view controller class name.
    open class var identifier: String? {
        return String(describing: self)
    }
    
    
}
