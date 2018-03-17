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
