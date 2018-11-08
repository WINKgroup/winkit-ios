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
@available(*, deprecated: 1.0, message: "Use Coordinator pattern instead.")
open class WKNavigator {
    
    /// The shared instance.
    public static let shared = WKNavigator()
    
    /// Current displaying viewController.
    open var currentViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.topMostViewController
    }
    
    private init() {}
    
    // - MARK: View Controller methods
    
    /// Show a view controller with a push of navigation controller if exists, otherwise
    /// the view controller is presented modally.
    ///
    /// - Parameters
    ///     - viewController: The `WKViewController` that will be presented.
    ///     - animated: If true presentation will be animated.
    ///     - configuration: A closure that allows initial configuration of the viewController. This
    ///                      closure is called **before** viewController is pushed/presented.
    public func show<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKViewController<P> {
        configuration?(viewController)
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        } else if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: nil)
        }
    }
    
    
    public func present<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKViewController<P> {
        configuration?(viewController)
        if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /// Push a view controller if a navigation controller exists.
    public func push<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKViewController<P> {
        configuration?(viewController)
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        }
    }
    
    // - MARK: TableView controller methods
    
    /// Show a tablwView controller with a push of navigation controller if exists, otherwise
    /// the view controller is presented modally.
    public func show<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKTableViewController<P> {
        configuration?(viewController)
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        } else if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: nil)
        }
    }
    
    /// Present a tablwView controller modally
    public func present<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKTableViewController<P>{
        configuration?(viewController)
        if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /// Push a tablwView controller if a navigation controller exists.
    public func push<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKTableViewController<P> {
        configuration?(viewController)
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        }
    }
    
    // - MARK: CollectionView controller methods
    
    /// Show a collectionView controller with a push of navigation controller if exists, otherwise
    /// the view controller is presented modally.
    public func show<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKCollectionViewController<P> {
        configuration?(viewController)
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        } else if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: nil)
        }
    }
    
    /// Present a collectionView controller modally
    public func present<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKCollectionViewController<P> {
        configuration?(viewController)
        if let vc = currentViewController {
            vc.present(viewController, animated: animated, completion: completion)
        }
    }
    
    /// Push a collectionView controller if a navigation controller exists.
    public func push<VC, P>(viewController: VC, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKCollectionViewController<P> {
        configuration?(viewController)
        if let nVc = currentViewController?.navigationController {
            nVc.pushViewController(viewController, animated: animated)
        }
    }
    
    // - MARK: Instantiation and presentation methods of view controller
    
    /// Instantiate and present modally a `WKViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKViewController<P> {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.present(viewController: vc, animated: animated, configuration: configuration, completion: completion)
    }

    /// Instantiate and present modally a `WKViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKViewController<P>  {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.present(viewController: vc, animated: animated, configuration: configuration, completion: completion)
    }


    /// Instantiate and push (if a navigationController exists) or present modally a `WKViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKViewController<P>  {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.show(viewController: vc, animated: animated, configuration: configuration)
    }

    /// Instantiate and push (if a navigationController exists) or present modally a `WKViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKViewController<P> {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.show(viewController: vc, animated: animated, configuration: configuration)
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
    public func push<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKViewController<P> {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.push(viewController: vc, animated: animated, configuration: configuration)
    }

    /// Instantiate and push a `WKViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKViewController<P> {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.push(viewController: vc, animated: animated, configuration: configuration)
    }
    
    // - MARK: Instantiation and presentation methods of tableView controller
    
    /// Instantiate and present modally a `WKTableViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKTableViewController<P> {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.present(viewController: vc, animated: animated, configuration: configuration, completion: completion)
    }
    
    /// Instantiate and present modally a `WKTableViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKTableViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKTableViewController<P>  {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.present(viewController: vc, animated: animated, configuration: configuration, completion: completion)
    }
    
    
    /// Instantiate and push (if a navigationController exists) or present modally a `WKTableViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKTableViewController<P>  {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.show(viewController: vc, animated: animated, configuration: configuration)
    }
    
    /// Instantiate and push (if a navigationController exists) or present modally a `WKTableViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKTableViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKTableViewController<P> {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.show(viewController: vc, animated: animated, configuration: configuration)
    }
    
    /// Instantiate and push a `WKTableViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKTableViewController<P> {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.push(viewController: vc, animated: animated, configuration: configuration)
    }
    
    /// Instantiate and push a `WKTableViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKTableViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKTableViewController<P> {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.push(viewController: vc, animated: animated, configuration: configuration)
    }
    
    // - MARK: Instantiation and presentation methods of collectionView controller
    
    /// Instantiate and present modally a `WKCollectionViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKCollectionViewController<P> {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.present(viewController: vc, animated: animated, configuration: configuration, completion: completion)
    }
    
    /// Instantiate and present modally a `WKCollectionViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKCollectionViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func present<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil, completion: (()->Void)?) where VC: WKCollectionViewController<P>  {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.present(viewController: vc, animated: animated, configuration: configuration, completion: completion)
    }
    
    
    /// Instantiate and push (if a navigationController exists) or present modally a `WKCollectionViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKCollectionViewController<P>  {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.show(viewController: vc, animated: animated, configuration: configuration)
    }
    
    /// Instantiate and push (if a navigationController exists) or present modally a `WKCollectionViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKCollectionViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func show<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKCollectionViewController<P> {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.show(viewController: vc, animated: animated, configuration: configuration)
    }
    
    /// Instantiate and push a `WKCollectionViewController` by specifing its type.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<VC, P>(viewControllerType: VC.Type, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKCollectionViewController<P> {
        let vc = viewControllerType.instantiate(bundle: bundle)
        self.push(viewController: vc, animated: animated, configuration: configuration)
    }
    
    /// Instantiate and push a `WKCollectionViewController` by specifing its type and the storyboard name.
    ///
    /// - Parameters:
    ///   - viewControllerType: The type of the viewController that will be instantiated.
    ///   - storyboardName: The storyboard name. A `WKCollectionViewController` already has a `storyboardName` class var, but when using this paramter,
    ///                     that var is ignored.
    ///   - bundle: The bundle or nil.
    ///   - animated: True to animate the presentation.
    ///   - configuration: A closure called before viewController presentation to allow initial config.
    ///                    This method is called before `viewDidLoad()` viewController's method.
    ///   - completion: Closure called after presentation.
    ///
    /// - Warning: Make sure to ovrride `identifier` class var in the view controller you are presenting!
    public func push<VC, P>(viewControllerType: VC.Type, fromStoryboard storyboardName: String, bundle: Bundle? = nil, animated: Bool, configuration: ((VC) -> Void)? = nil) where VC: WKCollectionViewController<P> {
        let vc = viewControllerType.instantiate(fromStoryboard: storyboardName, bundle: bundle)
        self.push(viewController: vc, animated: animated, configuration: configuration)
    }
    
    // - MARK: Instantiation and presentation methods of navigationController
    
    /// This method will instantiate and present modally a navigationController from a storyboard.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the navigationController set in storyboard
    ///   - storyboardName: The storyboard name
    ///   - bundle: The bundle or nil.
    ///   - configuration: A closure called before presentation to allow initial config.
    ///   - animated: True to animate the presentation.
    ///   - completion: Closure called after the navigationController has been presented.
    public func presentNavigationController(with identifier: String, fromStoryboard storyboardName: String, bundle: Bundle? = nil, configuration: ((UINavigationController) -> Void)? = nil, animated: Bool, completion: (()->Void)?) {
        let vc = UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewController(withIdentifier: identifier) as! UINavigationController
        configuration?(vc)
        currentViewController?.present(vc, animated: animated, completion: completion)
    }
}
