//
//  WKCollectionViewCell.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 14/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

open class WKCollectionViewCell<P: WKPresenter>: UICollectionViewCell {
    
    /// The reuse identifier accessible before the object instantiation.
    /// If you want to use it, you **MUST** override.
    ///
    /// - Warning: If you try to access this property without overriding it, a `fatalError`
    ///             will be thrown.
    open class var reuseIdentifier: String {
        fatalError("Must override reuse identifier")
    }
    
    /// The `WKPresenter` subclassed owned by the cell.
    open var presenter: P?
    
    /// The method to be called to configure the cell with the `WKPresenter`.
    /// You should override this method to configure the cell to follow the MVP design pattern correctly.
    /// If you override this method, you **MUST** call super.
    ///
    /// - Parameter presenter: the `WKPresenter` that will be owned by the cell.
    open func configure(with presenter: P) {
        // Override to custom configuration
        self.presenter = presenter
    }
    
}
