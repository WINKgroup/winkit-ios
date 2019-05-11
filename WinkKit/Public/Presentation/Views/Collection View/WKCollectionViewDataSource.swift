//
//  WKCollectionViewDataSource.swift
//  BuyBack
//
//  Created by Rico Crescenzio on 22/11/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// A concrete `UICollectionViewDataSource` that has some common method already implemented.
///
/// - Important: This data source handles only 1 section.
open class WKCollectionViewDataSource<T>: NSObject, UICollectionViewDataSource {
    
    // - MARK: Properties
    
    /// The array of item that managed by this dataSource.
    internal(set) open var items = [T]()
    
    /// The collection view that owns this dataSource.
    internal(set) public weak var collectionView: UICollectionView!
    
    // - MARK: Initializers
    
    /// Create the dataSource and attach it to the given collection view.
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
    }
    
    // - MARK: Methods
    
    /// Asks your data source object for the number of items in the specified section.
    /// Default returns items count.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information..
    ///   - section: An index number identifying a section in collectionView. This index value is 0-based.
    /// - Returns: The number of rows in section.
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    /// Your implementation of this method is responsible for creating, configuring, and returning the appropriate cell for the given item. You do this by calling the dequeueReusableCell(withReuseIdentifier:for:) method of the collection view and passing the reuse identifier that corresponds to the cell type you want. That method always returns a valid cell object. Upon receiving the cell, you should set any properties that correspond to the data of the corresponding item, perform any additional needed configuration, and return the cell.
    ///    You do not need to set the location of the cell inside the collection view’s bounds. The collection view sets the location of each cell automatically using the layout attributes provided by its layout object.
    ///    If isPrefetchingEnabled on the collection view is set to true then this method is called in advance of the cell appearing. Use the collectionView(_:willDisplay:forItemAt:) delegate method to make any changes to the appearance of the cell to reflect its visual state such as selection.
    ///    This method must always return a valid view object.
    ///
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path that specifies the location of the item.
    /// - Returns: A configured cell object. A fatal error is thrown if this method is not overriden.
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("collectionView(_:cellForItemAt:) not implemented")
    }
    
    
    /// Add an item into data source and update the collection view.
    ///
    /// - Parameters:
    ///   - item: The new item that will be inserted in data source.
    open func append(_ item: T) {
        items.append(item)
        collectionView.insertItems(at: [IndexPath(row: items.count - 1, section: 0)])
    }
    
    
    ///  Remove item at index from data source and update the collection view.
    ///
    /// - Parameter index: The index of the item to be removed.
    open func remove(at index: Int) {
        items.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    
    /// Replce the item in data source at specified index with new one.
    ///
    /// - Parameters:
    ///   - item: The new item that will replace the old one.
    ///   - index: The index of the old item.
    open func replace(_ item: T, at index: Int) {
        if items.count > index && index >= 0 {
            items[index] = item
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    
    /// Replace multiple items at the specified indexes and update collection view`.
    ///
    /// - Parameter items: Array of tuple of item & index.
    open func replace(items: [(item: T, index: Int)]) {
        var indexes = [Int]()
        items.forEach { (row: (item: T, index: Int)) -> Void in
            if self.items.count > row.index && row.index >= 0 {
                self.items[row.index] = row.item
                indexes.append(row.index)
            }
        }
        
        collectionView.reloadItems(at: indexes.map { IndexPath(row: $0, section: 0) })
        
    }
    
    
    /// Empty the data source and reload the collection view.
    open func removeAllItems() {
        let indexPaths = items.enumerated().map { (arg: (offset: Int, element: T)) in
            return IndexPath(row: arg.offset, section: 0)
        }
        items.removeAll()
        collectionView.deleteItems(at: indexPaths)
    }
    
    
    /// Clear and set new items to data source and call `reladData()` on collection view.
    ///
    /// - Parameter items: The new array of items.
    open func replaceAll(_ items: [T]) {
        self.items = items
        collectionView.reloadData()
    }
    
}

public extension WKCollectionViewDataSource where T: Equatable {
    
    /// Remove the item from the data source.
    ///
    /// - Parameter item: The item that will removed if found in data source.
    func remove(_ item: T) {
        if let index = items.index(of: item) {
            remove(at: index)
        }
    }
}
