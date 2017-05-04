//
//  WKTableViewController.swift
//  Pods
//
//  Created by Rico Crescenzio on 04/05/17.
//
//

import UIKit

open class WKTableViewController: UITableViewController {
    
    /// The storyboard name in which the sbuclassed `WKTableViewController` is created (if the viewController is
    /// defined into a `UIStoryboard` instead of a xib). You must override this property
    /// if this viewController exists in a storyboard to call `instantiate(budle:) -> WKViewController?`;
    open class var storyboardName: String? {
        return nil
    }
    
    /// Override this variable with the identifier that you will assign in the `UIStoryboard`
    /// in which the subclass of `WKTableViewController` is created; .
    open class var identifier: String? {
        return nil
    }
    
    /// You can call this function to instantiate the `WKTableViewController` from code. Return nil if `identifier` and `storyboardName`
    /// properties were not overriden in the subclass.
    public class func instantiate(bundle: Bundle? = nil) -> Self {
        guard let storyboard = storyboardName, let identifier = identifier else {
            fatalError("Cannot invoke instantiate: you did not override `storyboardName` or `identifier` in \(self)")
        }
        
        return instantiateFromStoryboard(storyboardName: storyboard, viewControllerIdentifier: identifier, bundle: bundle)
    }
    

}
