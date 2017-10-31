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
    
    public var presenter: P!
        
    open class var storyboardName: String? {
        return nil
    }
    
    open class var identifier: String? {
        return nil
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard presenter != nil else { fatalError("presenter is nil. Did you instantiate a WKViewControllerPresenter in your sublcass and assigned to presenter property before calling super.viewDidLoad()?") }
        
        presenter.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
