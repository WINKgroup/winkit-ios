//
//  WKCollectionView.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 14/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    /// Registers a `WKCollectionViewCell` object as cell if the cell view is into a xib.
    /// This method internally calls the `register(_:forCellWithReuseIdentifier:)` of the `UICollectionView`.
    /// Since it uses a `UINib`, the `nibName` **MUST** be the same of the class name!
    ///
    /// Parameter cell: The `WKCollectionViewCell` to be registered.
    public func register<P>(cell: WKCollectionViewCell<P>.Type) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
}

/// A `WKCollectionView` is basically a `collectionView` with some common behaviours already implemented,
/// like pull to refresh.
open class WKCollectionView: UICollectionView {
    
    // MARK: - Properties
    
    /// Return `true` if you add a pull to refresh behaviour before with
    /// `addPullToRefresh(tintColor:refreshClosure:)`.
    public var isPullToRefreshEnabled: Bool {
        return pullToRefreshHandling != nil
    }
    
    fileprivate var pullToRefreshHandling: WKPullToRefreshClosure?
    
    // MARK: - Methods
    
    /// Automatically create and set a `UIRefreshControl` to the `collectionView`.
    ///
    /// - Parameters:
    ///
    ///     - tintColor: the `UIColor` assigned to the `UIRefreshControl`.
    ///     - refreshClosure: The `WKPullToRefreshClosure` closure that will be run when the `tableView` is pulled.
    public func addPullToRefresh(tintColor: UIColor? = nil, refreshClosure: @escaping WKPullToRefreshClosure) {
        if !subviews.contains(where: { $0 is UIRefreshControl }) {
            let refreshControl = UIRefreshControl()
            if let tintColor = tintColor {
                refreshControl.tintColor = tintColor
            }
            refreshControl.addTarget(self, action: #selector(refreshControlDidChange(_:)), for: .valueChanged)
            addSubview(refreshControl)
            pullToRefreshHandling = refreshClosure
        }
    }
    
    public func removePullToRefresh() {
        subviews.first(where: { $0 is UIRefreshControl})?.removeFromSuperview()
    }
    
    @objc private func refreshControlDidChange(_ sender: UIRefreshControl) {
        pullToRefreshHandling?(sender)
    }
    
}
