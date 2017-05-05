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
open class WKCollectionViewController: UICollectionViewController, InstantiableViewController {

    open class var storyboardName: String? {
        return nil
    }
    
    open class var identifier: String? {
        return nil
    }
    
}
