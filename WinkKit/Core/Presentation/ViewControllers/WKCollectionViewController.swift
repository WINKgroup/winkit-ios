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
open class WKCollectionViewController<P>: UICollectionViewController, WKBaseViewController where P: WKGenericViewControllerPresenter {

    /// The presenter that will handle all logic of this viewController.
    open var presenter: P!
    
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
    
    // - MARK: Initializers
    
    /// Initialize view controller and assign the presenter.
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initPresenter()
    }
    
    /// Initialize view controller and assign the presenter.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPresenter()
    }
    
    // - MARK: View Controller life-cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        guard presenter != nil else { fatalError("presenter is nil. it could be possible that you created a custom init for this view controller and you didn't call `initPresenter()`.") }
        
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
    }
    
    // - MARK: Public methods.
    
    /// A method called when the view controller is initialized. This method cannot be overriden,
    /// but if you provide your own `init` (which doesn't override existing ones) you must call it.
    public func initPresenter() {
        if P.self == VoidPresenter.self {
            presenter = VoidPresenter() as! P
        } else if let view = self as? P.View {
            presenter = P.init(view: view, ())
        } else {
            fatalError("\(type(of: self)) doesn't conform to \(type(of: P.View.self))")
        }
    }
}
