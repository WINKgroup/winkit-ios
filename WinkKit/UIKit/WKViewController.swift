//
//  WKViewController.swift
//  Pods
//
//  Created by Rico Crescenzio on 04/05/17.
//
//

import UIKit

/// Global func helpful to instantiate a viewController
func instantiateFromStoryboard<T>(storyboardName: String, viewControllerIdentifier: String, bundle: Bundle?) -> T {
    return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentifier) as! T
}

/// The base ViewController that will be subclassed in your project instead of subclassing `UIViewController`.
/// This provides some useful methods like the instantiation.
open class WKViewController: UIViewController {
    
    /// The storyboard name in which the sbuclassed `WKViewController` is created (if the viewController is
    /// defined into a `UIStoryboard` instead of a xib). You must override this property
    /// if this viewController exists in a storyboard to call `instantiate(budle:) -> WKViewController?`;
    open class var storyboardName: String? {
        return nil
    }
    
    /// Override this variable with the identifier that you will assign in the `UIStoryboard`
    /// in which the subclass of `WKViewController` is created; .
    open class var identifier: String? {
        return nil
    }
    
    /// You can call this function to instantiate the `WKViewController` from code. Return nil if `identifier` and `storyboardName`
    /// properties were not overriden in the subclass.
    public class func instantiate(bundle: Bundle? = nil) -> Self {
        guard let storyboard = storyboardName, let identifier = identifier else {
            fatalError("Cannot invoke instantiate: you did not override `storyboardName` or `identifier` in \(self)")
        }
        
        return instantiateFromStoryboard(storyboardName: storyboard, viewControllerIdentifier: identifier, bundle: bundle)
    }

    
}
