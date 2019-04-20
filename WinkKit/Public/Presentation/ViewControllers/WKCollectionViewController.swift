//
//  WKCollectionViewController.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/05/17.
//
//

import UIKit

/// The base CollectionViewController that will be subclassed in your project instead of subclassing `UICollectionViewController`.
/// This provides some useful methods like the static instantiation.
open class WKCollectionViewController<P: WKGenericViewControllerPresenter>: UICollectionViewController, WKBaseViewController {

    /// The presenter that will handle all logic of this viewController.
    open var presenter: P!
    
    public var initObject: P.InitObject!

    /// If your project has a storyboard that contains an instance of the subclass of this view controller,
    /// you can override this property to indicate the name of that storyboard to allow auto-instantiation feature
    open class var storyboardName: String? {
        return nil
    }
    
    /// The identifier that is set in Storybaord. Default value is `defaultStoryboardIdentifier`, which means that
    /// the identifier of the view controller is the view controller class name.
    open class var identifier: String? {
        return defaultStoryboardIdentifier
    }
    
    // - MARK: View Controller life-cycle
    
    open override func viewDidLoad() {
        presenter = initPresenter()
        super.viewDidLoad()
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
    
    deinit {
        presenter.viewDidDestroy()
        ProcessInfoUtils.debugViewControllerDeinit(vc: self)
    }
    
    open func initPresenter() -> P {
        return SharedViewControllerMethods.presenter(for: self)
    }

}
