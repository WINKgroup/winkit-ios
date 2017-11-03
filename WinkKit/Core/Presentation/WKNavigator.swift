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
/// Navigator object uses the `currentViewController` to push/present other view controllers. The current view controller
/// is set in `viewDidAppear(animated:)` of every WinkKit view controller, for this reason use this object only if you
/// use WinkKit view controllers.
///
/// - Warning: This class should be used only with WinkKit view controllers to avoid messing up everything.
///            If you decide to use Navigator class, you should always use WinkKit view controllers.
open class WKNavigator {
    
    public static let shared = WKNavigator()
    
    internal(set) open var currentViewController: UIViewController?
    
    private init() {}
    
    // - MARK: View Controller methods
    
    /// Show a view controller with a push of navigation controller if exists, otherwise
    /// the view controller is presented modally.
    public func show<P>(viewController: WKViewController<P>, animated: Bool) {
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        } else if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: nil)
        }
    }
    
    /// Present a view controller modally
    public func present<P>(viewController: WKViewController<P>, animated: Bool, completion: (()->Void)?) {
        if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /// Push a view controller if a navigation controller exists.
    public func push<P>(viewController: WKViewController<P>, animated: Bool) {
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        }
    }
    
    // - MARK: TableView controller methods
    
    /// Show a tablwView controller with a push of navigation controller if exists, otherwise
    /// the view controller is presented modally.
    public func show<P>(viewController: WKTableViewController<P>, animated: Bool) {
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        } else if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: nil)
        }
    }
    
    /// Present a tablwView controller modally
    public func present<P>(viewController: WKTableViewController<P>, animated: Bool, completion: (()->Void)?) {
        if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /// Push a tablwView controller if a navigation controller exists.
    public func push<P>(viewController: WKTableViewController<P>, animated: Bool) {
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        }
    }
    
    // - MARK: CollectionView controller methods
    
    /// Show a collectionView controller with a push of navigation controller if exists, otherwise
    /// the view controller is presented modally.
    public func show<P>(viewController: WKCollectionViewController<P>, animated: Bool) {
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        } else if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: nil)
        }
    }
    
    /// Present a collectionView controller modally
    public func present<P>(viewController: WKCollectionViewController<P>, animated: Bool, completion: (()->Void)?) {
        if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /// Push a collectionView controller if a navigation controller exists.
    public func push<P>(viewController: WKCollectionViewController<P>, animated: Bool) {
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        }
    }
}

extension WKNavigator {
    // - MARK: Instantiation and presentation methods of view controller
    
    /// Instantiate and present a `WKViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<P>(ViewController: WKViewController<P>.Type, bundle: Bundle? = nil, animated: Bool, completion: (()->Void)?) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.present(viewController: vc, animated: animated, completion: completion)
    }
    
    /// Instantiate and push or present a `WKViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<P>(ViewController: WKViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, completion: (()->Void)?) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.present(viewController: vc, animated: animated, completion: completion)
    }
    
    /// Instantiate and push or present a `WKViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<P>(ViewController: WKViewController<P>.Type, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.show(viewController: vc, animated: animated)
    }
    
    /// Instantiate and present a `WKViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<P>(ViewController: WKViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.show(viewController: vc, animated: animated)
    }
    
    /// Instantiate and push a `WKViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<P>(ViewController: WKViewController<P>.Type, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.push(viewController: vc, animated: animated)
    }
    
    /// Instantiate and push a `WKViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<P>(ViewController: WKViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.push(viewController: vc, animated: animated)
    }
}


extension WKNavigator {
    // - MARK: Instantiation and presentation methods of tableView controller
    
    /// Instantiate and present a `WKTableViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<P>(ViewController: WKTableViewController<P>.Type, bundle: Bundle? = nil, animated: Bool, completion: (()->Void)?) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.present(viewController: vc, animated: animated, completion: completion)
    }
    
    /// Instantiate and push or present a `WKTableViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<P>(ViewController: WKTableViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, completion: (()->Void)?) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.present(viewController: vc, animated: animated, completion: completion)
    }
    
    /// Instantiate and push or present a `WKTableViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<P>(ViewController: WKTableViewController<P>.Type, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.show(viewController: vc, animated: animated)
    }
    
    /// Instantiate and present a `WKTableViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<P>(ViewController: WKTableViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.show(viewController: vc, animated: animated)
    }
    
    /// Instantiate and push a `WKTableViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<P>(ViewController: WKTableViewController<P>.Type, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.push(viewController: vc, animated: animated)
    }
    
    /// Instantiate and push a `WKTableViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<P>(ViewController: WKTableViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.push(viewController: vc, animated: animated)
    }
}


extension WKNavigator {
    // - MARK: Instantiation and presentation methods of collectionView controller
    
    /// Instantiate and present a `WKCollectionViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<P>(ViewController: WKCollectionViewController<P>.Type, bundle: Bundle? = nil, animated: Bool, completion: (()->Void)?) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.present(viewController: vc, animated: animated, completion: completion)
    }
    
    /// Instantiate and push or present a `WKCollectionViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<P>(ViewController: WKCollectionViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, completion: (()->Void)?) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.present(viewController: vc, animated: animated, completion: completion)
    }
    
    /// Instantiate and push or present a `WKCollectionViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<P>(ViewController: WKCollectionViewController<P>.Type, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.show(viewController: vc, animated: animated)
    }
    
    /// Instantiate and present a `WKCollectionViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<P>(ViewController: WKCollectionViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.show(viewController: vc, animated: animated)
    }
    
    /// Instantiate and push a `WKCollectionViewController` by using its `identifier`. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<P>(ViewController: WKCollectionViewController<P>.Type, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(bundle: bundle)
        self.push(viewController: vc, animated: animated)
    }
    
    /// Instantiate and push a `WKCollectionViewController` by using its `identifier` and specifing a storybaord. You can specify a `Bundle`, deafult value is nil.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<P>(ViewController: WKCollectionViewController<P>.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool) {
        let vc = ViewController.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.push(viewController: vc, animated: animated)
    }
}
