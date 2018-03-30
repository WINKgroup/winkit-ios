//
//  WKPresenter.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 09/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation

/// The base presenter protocol.
public protocol WKPresenter: class {
    /// Every presenter can manage a view, which must conform to `PresentableView`
    associatedtype View = PresentableView
    
    /// The view managed by this presenter.
    ///
    /// - Important: To avoid retain-cycle, you must declare this var weak/unowned in conformed class.
    var view: View? { get set }
    
    /// Required an empty initializer. At this time `view` property is still nil. You can perform additional
    /// initialization here.
    init()
}

/// En empty view used to be the `VoidPresenter` view.
public class VoidView: PresentableView {}

/// When you don't need a presenter in a view controller, use this one.
public final class VoidPresenter: WKGenericViewControllerPresenter {
    
    public typealias View = VoidView
    
    public weak var view: VoidView?
    
    public required init() {
        view = VoidView()
    }
}
