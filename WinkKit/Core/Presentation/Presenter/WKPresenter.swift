//
//  WKPresenter.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 09/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation

/// Every `WKViewController`, `WKTableViewController`, `WKCollectionViewController` needs a `WKPresenter` to properly works.
public protocol WKPresenter {
    
}

/// When you don't need a presenter, use this one.
public class VoidPresenter: WKViewControllerPresenter {
    
}
