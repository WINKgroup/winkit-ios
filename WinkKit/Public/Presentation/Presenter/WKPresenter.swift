//
//  WKPresenter.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 09/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation
import UIKit

/// All view handled by a presenter must conform to this protocol.
public protocol WKPresentableView: AnyObject {}

/// The base presenter protocol.
public protocol WKPresenter: AnyObject {
    
    /// Every presenter can manage a view, which must conform to `WKPresentableView`
    associatedtype View = WKPresentableView
    
    /// The view managed by this presenter.
    ///
    /// - Important: To avoid retain-cycle, you must declare this var weak/unowned in conformed class.
    var view: View? { get set }
    
}

/// En empty view used to be the `VoidPresenter` view.
public class VoidView: WKPresentableView {
    
    public init() {}
    
}

/// When you don't need a presenter in a view controller, use this one.
public final class VoidPresenter: WKGenericViewControllerPresenter {
    
    public typealias View = VoidView
    
    public weak var view: VoidView?
    
    public required init(with object: Void = ()) {
        let view = VoidView()
        self.view = view
    }
    
}
