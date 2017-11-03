//
//  WKBaseViewController.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 05/08/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation

/// All `WKViewController`, `WKTableViewController`, `WKCollectionViewController` conform to this protocol
/// to achieve some new features.
public protocol WKBaseViewController: class {
    
    associatedtype P = WKViewControllerPresenter
    
    /// The `WKViewControllerPresenter` owned by this class.
    var presenter: P! { get set }
    
    var navigator: WKNavigator! { get }
    
    /// The storyboard name in which the sbuclassed `WKViewController` is created (if the viewController is
    /// defined into a `UIStoryboard` instead of a xib). You must override this property
    /// if this viewController exists in a storyboard to call `instantiate(budle:) -> WKViewController?`.
    static var storyboardName: String? { get }
    
    /// Override this variable with the identifier that you will assign in the `UIStoryboard`
    /// in which the subclass of `WKViewController` is created.
    static var identifier: String? { get }
    
}

public extension WKBaseViewController where Self : UIViewController  {
    
    /// You can call this function to instantiate the `WKViewController` from code if the
    /// `viewController` is in a `UIStoryboard`; This method will automatically create a `UIStoryboard`
    /// with the name of the class property `storyboardName` and the `Bundle` object passed as argument.
    /// If you want to specify a different `UIStoryboard` instead of the overriden property, you can
    /// use `instantiate(fromStoryboard:bundle:)` that accept a param which is the storybaord name.
    ///
    /// - Parameters:
    ///     - bundle: the `Bundle` that can be pass when the `UIStoryboard` will be created. Default is nil.
    /// - Warning: If `identifier` or `storyboardName` are not overriden in the subclass
    ///            this method will throw a `fatalError`!
    public static func instantiate(bundle: Bundle? = nil) -> Self {
        guard let storyboard = storyboardName, let identifier = identifier else {
            fatalError("Cannot invoke instantiate: you did not override `storyboardName` or `identifier` in \(self)")
        }
        
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
        
    }
    
    /// You can call this function to instantiate the `WKViewController` from code if the
    /// `viewController` is in a `UIStoryboard`; This method will automatically create a `UIStoryboard`
    /// with the name of the argument `storyboardName` and the `Bundle` object passed as argument.
    /// If you want to specify a different `UIStoryboard` instead of the overriden property, you can
    /// use `instantiate(bundle:)` that accept a param which is the storybaord name.
    ///
    /// - Parameters:
    ///     - storyboardName: the name of the `UIStoryboard` that will be created.
    ///     - bundle: the `Bundle` that can be pass when the `UIStoryboard` will be created. Default is nil.
    /// - Warning: If `identifier` is not overriden in the subclass this method will throw a `fatalError`!
    public static func instantiate(fromStoryboard storyboardName: String, bundle: Bundle? = nil) -> Self {
        guard let identifier = identifier else {
            fatalError("Cannot invoke instantiate: you did not override or `identifier` in \(self)")
        }
        
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
    }
    
}
