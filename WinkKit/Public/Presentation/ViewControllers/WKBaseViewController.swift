//
//  WKBaseViewController.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 05/08/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation

/// All `WKViewController`, `WKTableViewController`, `WKCollectionViewController` conform to this protocol
/// to follow MVP pattern.
public protocol WKBaseViewController {
    
    associatedtype P: WKGenericViewControllerPresenter
    
    /// The storyboard name in which the sbuclassed `WKViewController` is created (if the viewController is
    /// defined into a `UIStoryboard` instead of a xib). You must override this property
    /// if this viewController exists in a storyboard to call `instantiate(budle:) -> WKViewController?`.
    static var storyboardName: String? { get }
    
    /// Override this variable with the identifier that you will assign in the `UIStoryboard`
    /// in which the subclass of `WKViewController` is created.
    static var identifier: String? { get }
    
    /// The `WKViewControllerPresenter` owned by this class.
    var presenter: P! { get set }
    
    /// The object that will be used by the presenter initializer. It is inteded for internal purposes.
    /// This object is set to nil after the presenter has been instantiated successfully. You should not use this
    /// for any other reason which is not instantiating the presenter.
    var initObject: P.InitObject! { get set }
    
    /// Returns the presenter for the current view controller.
    ///
    /// If the view controller is instantiated using
    /// `instantiate(bundle:initObject:)` (or in general with one of the static `instantiate` methods
    /// provided by `WinkKit`, you don't need to implement this method because it's done by the framework.
    ///
    /// If you don't instantiate the view controller with `instantiate` (for instance, using a storyboard segue or
    /// manually using `UIStoryboard.instantiateViewController(withIdentifier:)`) you must override this method and
    /// return a proper presenter, otherwise the `presenter` attribute will be nil which will lead on a crash.
    func initPresenter() -> P
    
}

// MARK: - View controller instantiation

public extension WKBaseViewController where Self: UIViewController {
    
    /// You can call this function to instantiate the `WKViewController` from code if the
    /// `viewController` is in a `UIStoryboard`; This method will automatically create a `UIStoryboard`
    /// with the name of the class property `storyboardName` and the `Bundle` object passed as argument.
    ///
    /// - Parameters:
    ///     - initObject: the object that will be used to initialize the presenter.
    ///     - bundle: the `Bundle` that can be pass when the `UIStoryboard` will be created. Default is nil.
    /// - Warning: If `identifier` or `storyboardName` are not overriden in the subclass
    ///            this method will throw a `fatalError`!
    static func instantiate(initObject: P.InitObject, bundle: Bundle? = nil) -> Self {
        guard let storyboard = storyboardName, let identifier = identifier else {
            fatalError("Cannot invoke instantiate: you did not override `storyboardName` or `identifier` in \(self)")
        }
        var vc = UIStoryboard(name: storyboard, bundle: bundle).instantiateViewController(withIdentifier: identifier) as! Self
        vc.initObject = initObject
        return vc
    }
    
}

public extension WKBaseViewController where Self: UIViewController, P.InitObject == Void {
    
    /// Convenience method that calls `instantiate(bundle:initObject:)` for presenter that doesn't need init object.
    static func instantiate(bundle: Bundle? = nil) -> Self {
        return instantiate(initObject: (), bundle: bundle)
    }
    
}

public extension UIViewController {
    
    /// Default storyboard identifier of this view controller
    ///
    /// Returns the class name of this view controller using `name(of:)`.
    static var defaultStoryboardIdentifier: String {
        return plainName(of: self)
    }
    
}
