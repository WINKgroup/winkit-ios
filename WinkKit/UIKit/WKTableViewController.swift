//
//  WKTableViewController.swift
//  Pods
//
//  Created by Rico Crescenzio on 04/05/17.
//
//

import UIKit

/// The base TableViewController that will be subclassed in your project instead of subclassing `UITableViewController`.
/// This provides some useful methods like the static instantiation.
open class WKTableViewController: UITableViewController, InstantiableViewController {

    open class var storyboardName: String? {
        return nil
    }
    
    open class var identifier: String? {
        return nil
    }
    
    
}
