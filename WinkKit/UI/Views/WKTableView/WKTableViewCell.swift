//
//  WKTableViewCell.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 11/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

open class WKTableViewCell<VM: WKViewModel>: UITableViewCell {
    
    /// The reuse identifier accessible before the object instantiation.
    /// If you want to use it, you **MUST** override.
    ///
    /// - Warning: If you try to access this property without overriding it, a `fatalError`
    ///             will be thrown.
    open class var reuseIdentifier: String {
        fatalError("Must override reuse identifier")
    }
    
    /// The `WKViewModel` subclassed owned by the cell.
    open var viewModel: VM?

    /// The method to be called to configure the cell with the `WKViewModel`.
    /// You should override this method to configure the cell to follow the MVVM design pattern correctly.
    /// If you override this method, you **MUST** call super.
    ///
    /// - Parameter viewModel: the `WKViewModel` that will be owned by the cell.
    open func configure(with viewModel: VM) {
        self.viewModel = viewModel
    }
    
}
