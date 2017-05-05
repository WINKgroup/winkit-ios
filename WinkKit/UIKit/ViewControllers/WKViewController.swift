//
//  WKViewController.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//
//

import UIKit

/// All `WKViewController`, `WKTableViewController`, `WKCollectionViewController` conform to this protocol
/// to achieve the static instantiation feature.
public protocol InstantiableViewController: class {
    
    /// The storyboard name in which the sbuclassed `WKViewController` is created (if the viewController is
    /// defined into a `UIStoryboard` instead of a xib). You must override this property
    /// if this viewController exists in a storyboard to call `instantiate(budle:) -> WKViewController?`.
    static var storyboardName: String? { get }
    
    /// Override this variable with the identifier that you will assign in the `UIStoryboard`
    /// in which the subclass of `WKViewController` is created.
    static var identifier: String? { get }
    
}

public extension InstantiableViewController where Self : WKViewController {
    
    /// You can call this function to instantiate the `WKViewController` from code if the
    /// `viewController` is in a `UIStoryboard`; This method will automatically create a `UIStoryboard`
    /// with the name of the class property `storyboardName` and the `Bundle` object passed as argument.
    /// If you want to specify a different `UIStoryboard` instead of the overriden property, you can
    /// use `instantiate(fromStoryboard:bundle:)` that accept a param which is the storybaord name.
    ///
    /// - Parameter bundle: the `Bundle` that can be pass when the `UIStoryboard` will be created. Default is nil.
    /// - Warning: If `identifier` or `storyboardName` are not overriden in the subclass
    /// this method will throws a `fatalError`!
    static func instantiate(bundle: Bundle? = nil) -> Self {
        guard let storyboard = storyboardName, let identifier = identifier else {
            fatalError("Cannot invoke instantiate: you did not override `storyboardName` or `identifier` in \(self)")
        }
        
        return instantiateFromStoryboard(storyboardName: storyboard, viewControllerIdentifier: identifier, bundle: bundle)
    }
    
    /// You can call this function to instantiate the `WKViewController` from code if the
    /// `viewController` is in a `UIStoryboard`; This method will automatically create a `UIStoryboard`
    /// with the name of the argument `storyboardName` and the `Bundle` object passed as argument.
    /// If you want to specify a different `UIStoryboard` instead of the overriden property, you can
    /// use `instantiate(fromStoryboard:bundle:)` that accept a param which is the storybaord name.
    ///
    /// - Parameter storyboardName: the name of the `UIStoryboard` that will be created.
    /// - Parameter bundle: the `Bundle` that can be pass when the `UIStoryboard` will be created. Default is nil.
    /// - Warning: If `identifier` is not overriden in the subclass this method will throws a `fatalError`!
    static func instantiate(fromStoryboard storyboardName: String, bundle: Bundle? = nil) -> Self {
        guard let identifier = identifier else {
            fatalError("Cannot invoke instantiate: you did not override or `identifier` in \(self)")
        }
        
        return instantiateFromStoryboard(storyboardName: storyboardName, viewControllerIdentifier: identifier, bundle: bundle)
    }
    
    /// Helpful to instantiate a viewController with the returned type of the deeper subclass.
    internal static func instantiateFromStoryboard<T>(storyboardName: String, viewControllerIdentifier: String, bundle: Bundle?) -> T {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier) as! T
    }
    
}


/// The base ViewController that will be subclassed in your project instead of subclassing `UIViewController`.
/// This provides some useful methods like the static instantiation.
open class WKViewController: UIViewController, InstantiableViewController {
    
    open class var storyboardName: String? {
        return nil
    }
    
    open class var identifier: String? {
        return nil
    }
    
}
