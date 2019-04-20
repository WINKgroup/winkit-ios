//
//  WKTableView.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 11/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

public typealias WKPullToRefreshClosure = (UIRefreshControl)-> Void

public extension UITableView {
    
    /// Registers a `WKTableViewCell` object as cell if the cell view is into a xib.
    /// This method internally calls the `register(_:forCellReuseIdentifier:)` of the `UITableVIew`.
    /// Since it uses a `UINib`, the `nibName` **must** be the same of the class name!
    ///
    ///         register(cell: MyCustomCell.self)
    ///
    /// - Parameter cell: The `WKTableViewCell` to be registered.
    func register<P>(cell: WKTableViewCell<P>.Type) {
        register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    
    /// Dequeue a specialized `WKTableViewCell` based on given type.
    ///
    /// - Parameters:
    ///   - type: The type of the cell that will be dequeued.
    ///   - indexPath: The index path
    /// - Returns: The cell already casted.
    func dequeueReusableCell<C, P>(ofType type: C.Type, for indexPath: IndexPath) -> C where C: WKTableViewCell<P> {
        return dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! C
    }

}


/// A `WKTableView` is basically a `tableView` with some common behaviours already implemented,
/// like pull to refresh.
open class WKTableView: UITableView {
    
    // MARK: - Properties
    
    /// Return `true` if you add a pull to refresh behaviour before with
    /// `addPullToRefresh(tintColor:refreshClosure:)`.
    public var isPullToRefreshEnabled: Bool {
        return pullToRefreshHandling != nil
    }
    
    fileprivate var pullToRefreshHandling: WKPullToRefreshClosure?
    
    // MARK: - Methods
    
    /// Automatically create and set a `UIRefreshControl` to the `tableView`.
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
    
    /// Remove the `UIRefreshControl` added to this `tableView` if exists, otherwise do nothing.
    public func removePullToRefresh() {
        subviews.first(where: { $0 is UIRefreshControl})?.removeFromSuperview()
    }
    
    @objc private func refreshControlDidChange(_ sender: UIRefreshControl) {
        pullToRefreshHandling?(sender)
    }
    
    
    
}
