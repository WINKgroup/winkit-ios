//
//  WKViewController.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//
//

import UIKit

/// The base ViewController that will be subclassed in your project instead of subclassing `UIViewController`.
/// This provides some useful methods like the static instantiation.
///
/// - Important: Please, if your subclassed `WKViewController` is from a `UIStoryboard` and you want
///              to instantiate it by code, **USE** `instantiate(bundle:)` or `instantiate(fromStoryboard:bundle:)`
///              of `WKBaseViewController`.
open class WKViewController<P>: UIViewController, WKBaseViewController where P: WKViewControllerPresenter {
    
    open var presenter: P!
    
    /// A dictionary that can contain passing data between view controllers.
    var userInfo: [String : Any]?
    
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard presenter != nil else { fatalError("presenter is nil. Did you instantiate a WKViewControllerPresenter in your sublcass and assigned to presenter property before calling super.viewDidLoad()?") }
        
        presenter.viewDidLoad()
        initialize(with: userInfo)
        userInfo = nil // clean user info
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        WKNavigator.shared.currentViewController = self
        presenter.viewDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear()
    }
}
