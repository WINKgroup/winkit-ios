//
//  Navigator.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 03/11/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// A useful class that is binded to `WKViewController`, `WKTableViewController` and `WKCollectionViewController`
/// that help you to navigate between view controllers by providing a lot of navigation methods.
/// It is a singleton class that has the current showing view controller.
open class WKNavigator {
    
    /// The shared instance.
    public static let shared = WKNavigator()
    
    /// Current displaying viewController.
    open var currentViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.topMostViewController
    }
    
    // MARK: - View Controller presentation methods
    
    /// Show a view controller with a push of navigation controller if exists, otherwise
    /// the view controller is presented modally.
    ///
    /// - Parameters:
    ///     - viewController: The `WKViewController` that will be presented.
    ///     - animated: If true presentation will be animated.
    public func show<VC>(viewController: VC, animated: Bool) where VC: UIViewController & WKBaseViewController {
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        } else {
            currentViewController?.present(viewController, animated: animated, completion: nil)
        }
    }
    
    public func present<VC>(viewController: VC, animated: Bool, completion: (() -> Void)?) where VC: UIViewController & WKBaseViewController {
        currentViewController?.present(viewController, animated: animated, completion: completion)
    }
    
    /// Push a view controller if a navigation controller exists.
    public func push<VC>(viewController: VC, animated: Bool) where VC: UIViewController & WKBaseViewController {
        currentViewController?.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - View Controller instantiation and presentation methods
    
    /// Instantiate and present modally a `WKViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - initObject: The init object used by the presenter of the view controller to be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<VC>(viewControllerType: VC.Type, with initObject: VC.P.InitObject, bundle: Bundle? = nil, animated: Bool, completion: (()->Void)?)
        where VC: UIViewController & WKBaseViewController {
            let vc = viewControllerType.instantiate(initObject: initObject, bundle: bundle)
            present(viewController: vc, animated: animated, completion: completion)
    }
    
    /// Instantiate and push (if a navigationController exists) or present modally a `WKViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - initObject: The init object used by the presenter of the view controller to be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<VC>(viewControllerType: VC.Type, with initObject: VC.P.InitObject, bundle: Bundle? = nil, animated: Bool)
        where VC: UIViewController & WKBaseViewController {
            let vc = viewControllerType.instantiate(initObject: initObject, bundle: bundle)
            show(viewController: vc, animated: animated)
    }
    
    /// Instantiate and push a `WKViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<VC>(viewControllerType: VC.Type, with initObject: VC.P.InitObject, bundle: Bundle? = nil, animated: Bool)
        where VC: UIViewController & WKBaseViewController {
            let vc = viewControllerType.instantiate(initObject: initObject, bundle: bundle)
            push(viewController: vc, animated: animated)
    }
    
    // MARK: - View Controller with Void init object instantiation and presentation methods
    
    /// Convenience method for view controller whose presenter has Void initObject.
    ///
    /// See `present(viewControllerType:with:bundle:animated:completion:)`
    public func present<VC>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, completion: (() -> Void)?)
        where VC: UIViewController & WKBaseViewController, VC.P.InitObject == Void {
            present(viewControllerType: viewControllerType, with: (), bundle: bundle, animated: animated, completion: completion)
    }
    
    /// Convenience method for view controller whose presenter has Void initObject.
    ///
    /// show(viewControllerType:with:bundle:animated:)
    public func show<VC>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool)
        where VC: UIViewController & WKBaseViewController, VC.P.InitObject == Void {
            show(viewControllerType: viewControllerType, with: (), bundle: bundle, animated: animated)
    }
    
    /// Convenience method for view controller whose presenter has Void initObject.
    ///
    /// See `push(viewControllerType:with:bundle:animated:)`
    public func push<VC>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool)
        where VC: UIViewController & WKBaseViewController, VC.P.InitObject == Void {
           push(viewControllerType: viewControllerType, with: (), bundle: bundle, animated: animated)
    }
    
}
