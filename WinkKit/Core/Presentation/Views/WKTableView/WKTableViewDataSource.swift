//
//  WKTableViewDataSource.swift
//  BuyBack
//
//  Created by Rico Crescenzio on 22/11/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// A concrete `UITableViewDataSource` that has some common method already implemented.
///
/// - Important: This data source handles only 1 section.
open class WKTableViewDataSource<T>: NSObject, UITableViewDataSource {
    
    // - MARK: Properties
    
    /// The array of item that managed by this dataSource.
    internal(set) open var items = [T]()
    
    /// The table view that owns this dataSource.
    internal(set) public unowned var tableView: UITableView
    
    // - MARK: Initializers
    
    /// Create the dataSource and attach it to the given tableView.
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
    }
    
    // - MARK: Methods
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    /// By default it returns item count.
    ///
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    /// The returned UITableViewCell object is frequently one that the application reuses for performance reasons.
    /// You should fetch a previously created cell object that is marked for reuse by sending a dequeueReusableCell(withIdentifier:) message to tableView.
    /// Various attributes of a table cell are set automatically based on whether the cell is a separator and on information the data source provides,
    /// such as for accessory views and editing controls.
    ///
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from UITableViewCell that the table view can use for the specified row. A fatal error if this method is not overriden.
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("tableView(_:cellForItemAt:) not implemented")
    }
    
    
    /// Add an item into data source and update the table view by calling `insertRows(at:with:)`.
    ///
    /// - Parameters:
    ///   - item: The new item that will be inserted in data source.
    ///   - animation: The table view animation of inserting. Default is `automatic`.
    open func add(_ item: T, animation: UITableViewRowAnimation = .automatic) {
        items.append(item)
        tableView.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: animation)
    }
    
    
    /// Remove item at the given index and update table view by calling `deleteRows(at:with:)`.
    ///
    /// - Parameters:
    ///   - index: The index of the item that will be removed from this data source.
    ///   - animation: The table view animation of deleting. Default is `automatic`.
    open func remove(at index: Int, animation: UITableViewRowAnimation = .automatic) {
        items.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: animation)
    }
    
    
    /// Replace the item at the specified index and update table view by calling `insertRows(at:with:)`.
    ///
    /// - Parameters:
    ///   - item: The new item that will be inserted.
    ///   - index: The index of the item that will be replaced.
    ///   - animation: The table view animation of replacing. Default is `automatic`.
    ///
    /// - Important: This method won't do anything if index parameter is not valid.
    open func replace(_ item: T, at index: Int, animation: UITableViewRowAnimation = .automatic) {
        if items.count > index && index >= 0 {
            items[index] = item
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: animation)
        }
    }
    
    /// Replace multiple items at the specified indexes and update table view by calling `reloadRows(at:with:)`.
    ///
    /// - Parameters:
    ///   - items: Array of tuple of item & index.
    ///   - animation: The table view animation of replacing. Default is `automatic`.
    open func replace(items: [(item: T, index: Int)], animation: UITableViewRowAnimation = .automatic) {
        var indexes = [Int]()
        items.forEach { (row: (item: T, index: Int)) -> Void in
            if self.items.count > row.index && row.index >= 0 {
                self.items[row.index] = row.item
                indexes.append(row.index)
            }
        }
        
        tableView.reloadRows(at: indexes.map({ IndexPath(row: $0, section: 0) }), with: animation)
        
    }
    
    /// Empty the data source and reload the table view.
    ///
    /// - Parameter animation: The animation of deleting. Default is `automatic`.
    open func removeAllItems(animation: UITableViewRowAnimation = .automatic) {
        let indexPaths = items.enumerated().map { (arg: (offset: Int, element: T)) in
            return IndexPath(row: arg.offset, section: 0)
        }
        items.removeAll()
        tableView.deleteRows(at: indexPaths, with: animation)
    }
    
    /// Clear and set new items to data source and call `reladData()` on table view.
    ///
    /// - Parameter items: The new array of items.
    open func replaceAll(_ items: [T]) {
        self.items = items
        tableView.reloadData()
    }
    
}

public extension WKTableViewDataSource where T: Equatable {
    
    /// Remove the item from the data source.
    ///
    /// - Parameters:
    ///   - item: The item that will removed if found in data source.
    ///   - animation: The animation of deleting. Default is `automatic`.
    public func remove(_ item: T, animation: UITableViewRowAnimation = .automatic) {
        if let index = items.index(of: item) {
            remove(at: index, animation: animation)
        }
    }
}

