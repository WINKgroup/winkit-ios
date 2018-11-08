//
//  WKCollectionViewInfiniteDataSourceDelegate.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 20/07/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// A data source and delegate that handle pagination for collection view. It is build using the flow layout.
open class WKCollectionViewInfiniteDataSourceDelegate<T>: WKCollectionViewDataSource<T>, UICollectionViewDelegateFlowLayout {
    
    // - MARK: Initializers
    
    public override init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView)
        collectionView.register(WKSpinnerCollectionViewCell.self, forCellWithReuseIdentifier: WKSpinnerCollectionViewCell.reuseIdentifier)
        if collectionView.collectionViewLayout is UICollectionViewFlowLayout {
            collectionView.delegate = self
        } else {
            fatalError("WKCollectionViewInfiniteDataSourceDelegate can be used only with flow layout. Did you set a UICollectionViewFlowLayout for this collecttion view?")
        }
    }
    
    // - MARK: Properties
    
    var flowLayout: UICollectionViewFlowLayout {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout
        } else {
            fatalError("WKCollectionViewInfiniteDataSourceDelegate can be used only with flow layout. Did you set a UICollectionViewFlowLayout for this collecttion view?")
        }
    }
    
    private lazy var spinnerView: WKSpinnerView = {
        return WKSpinnerView()
    }()
    
    /// The color of the `UIActivityIndicatorView` that will be displayed
    /// at the bottom of the section when new page will be requested.
    /// If `nil` the `UIActivityIndicatorView` will be default of style `UIActivityIndicatorViewStyle.gray`.
    /// This property does nothing if you override ` collectionView(_:loadingCellForItemAt:) -> UICollectionViewCell`
    open var spinnerColor: UIColor? {
        return nil
    }
    
    private var loaderSection: Int {
        return 0
    }
    
    /// The number of the current page. Start from 0.
    public private(set) var currentPage: Int = 0
    
    /// Inidicates if collectionView has reached last page and no loader cell will be displayed when scroll to end.
    ///
    /// - Important: While this property is `true`, `collectionView(_:readyForNextPageInSection:completion:)` won't be called.
    public private(set) var hasReachedLastPage = false
    
    
    /// If `true`, the loading view is visible. You cannot change the value of this variable;
    /// It is by default set to `false`; when `collectionView(_:readyForNextPageInSection:completion:)` is called
    /// this property is set to `true`; finally when the `completion` parameter is called
    /// this property become again false.
    ///
    /// - Important: While this property is `true`, `collectionView(_:readyForNextPageInSection:completion:)` won't be called.
    public private(set) var isLoading: Bool = false {
        didSet {
            let count = collectionView(collectionView, numberOfItemsInSection: loaderSection)
            guard count != 0 && count != collectionView(collectionView, numberOfNormalItemsInSection: loaderSection) else {
                return
            }
            
            if isLoading {
                collectionView.insertItems(at: [IndexPath(row: count - 1, section: loaderSection)])
            } else {
                collectionView.deleteItems(at: [IndexPath(row: count - 1, section: loaderSection)])
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var lastContentOffset = CGPoint(x: 0, y: 0)
    
    // - MARK: Methods
    
    /// Call this method when you want to reset the page counter, for example if the collection view clear its elements.
    public func clearPages() {
        currentPage = 0
        hasReachedLastPage = false
    }
    
    /// Here's the implemetation of reaching last element. You can override this to do your own stuff.
    ///
    /// - Important: If you override this method, you **MUST** call super or unexpected behavior can occures.
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = flowLayout.scrollDirection == .vertical ? scrollView.contentOffset.y : scrollView.contentOffset.x
        let lastOffset = flowLayout.scrollDirection == .vertical ? lastContentOffset.y : lastContentOffset.x
        
        if currentOffset > lastOffset && collectionView.isDragging,
            let indexPath = collectionView.indexPathsForVisibleItems.first(where: {
                $0.section == loaderSection && $0.row == collectionView.numberOfItems(inSection: $0.section) - 1 &&
                    !isLoading && !hasReachedLastPage}) {
            isLoading = true
            self.collectionView(collectionView, readyForNextPageInSection: indexPath.section)
        }
        
        lastContentOffset = scrollView.contentOffset
    }
    
    // - MARK: Final methods
    
    /// You can't override this method, it is intended for internal purpose; instead, override `collectionView(_:normalCellForItemAt:)`.
    public final override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == loaderSection && indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 && isLoading {
            return self.collectionView(collectionView, loadingCellForItemAt: indexPath)
        }
        
        return self.collectionView(collectionView, normalCellForItemAt: indexPath)
    }
    
    /// You can't override this method, it is intended for internal purpose; instead, override `collectionView(_:numberOfNormalItemsInSection:)`.
    public final override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = self.collectionView(collectionView, numberOfNormalItemsInSection: section)
        count = section == loaderSection && isLoading ? count + 1 : count
        return count
    }
    
    /// You can't override this methods, it is intended for internal purpose.
    public final func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == loaderSection && indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 && isLoading {
            return self.collectionView(collectionView, layout: collectionViewLayout, sizeForLoadingItemAt: indexPath)
        }
        
        return self.collectionView(collectionView, layout: collectionViewLayout, sizeForNormalItemAt: indexPath)
    }
    
    
    // - MARK: Infinite scroll methods
    
    /// Tells the delegate the collection view has reached the last item in and is ready for the next page.
    /// You should override this method and implement your logic. Default does nothing.
    ///
    /// - Parameters:
    ///     - collectionView: The collectionView object telling is ready for next page.
    ///     - section: An index number identifying a section of collectionView.
    open func collectionView(_ collectionView: UICollectionView, readyForNextPageInSection section: Int) {
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForNormalItemAt indexPath: IndexPath) -> CGSize {
        return flowLayout.itemSize
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForLoadingItemAt indexPath: IndexPath) -> CGSize {
        return flowLayout.scrollDirection == .vertical ?
            CGSize(width: collectionView.bounds.width, height: 50) :
            CGSize(width: 50, height: collectionView.bounds.height)
    }
    
    /// Asks the data source for a cell to insert in a particular location of the collection view.
    /// The returned UICollectionViewCell object is frequently one that the application reuses for performance reasons.
    /// You should fetch a previously created cell object that is marked for reuse by sending
    /// a `dequeueReusableCell(withIdentifier:)` message to collectionView.
    /// Various attributes of a collection cell are set automatically based on whether the cell is
    /// a separator and on information the data source provides, such as for accessory views and editing controls.
    /// The default implementation return a simple `UICollectionViewCell`, so in your overridden method, you can skip
    /// the super call.
    ///
    /// - Parameters:
    ///     - collectionView: A collection-view object requesting the cell.
    ///     - indexPath: An index path locating a item in collectionView.
    ///
    /// - Note: This method is not called for the item that display the loading indicator.
    ///
    /// - Important: This is the `collectionView(_:cellForItemAt:)` version of the `WKCollectionViewInfiniteDataSourceDelegate`,
    ///              so you should override this method instead of the original one.
    open func collectionView(_ collectionView: UICollectionView, normalCellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Must override")
    }
    
    /// Asks the data source for a cell (that display the loading status of the collection view)
    /// to insert in a particular location of the collection view.
    ///
    /// - Parameters:
    ///     - collectionView: A collection-view object requesting the cell.
    ///     - indexPath: An index path locating a item in collectionView.
    ///
    /// - Note: This method provide a default loading cell, override this to show a custom cell loading.
    open func collectionView(_ collectionView: UICollectionView, loadingCellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WKSpinnerCollectionViewCell.reuseIdentifier, for: indexPath) as! WKSpinnerCollectionViewCell
        let view = loadingViewForCollectionView(collectionView)
        view.startAnimating()
        cell.configure(with: view)
        return cell
    }
    
    open func loadingViewForCollectionView(_ collectionView: UICollectionView) -> WKLoadableUIView {
        let view = spinnerView
        spinnerView.activityIndicatorView.color = spinnerColor
        return view
    }
    
    /// Tells the data source to return the number of items in a given section of a collection view.
    ///
    /// - Parameters:
    ///     - collectionView: The collection-view object requesting this information.
    ///     - section: An index number identifying a section in collectionView.
    open func collectionView(_ collectionView: UICollectionView, numberOfNormalItemsInSection section: Int) -> Int {
        return items.count
    }
    
    /// Tells the collection view in which section should appear the loading view. Default is section 0.
    ///
    /// - Parameter collectionView: The collection view object requesting this information
    /// - Returns: An index number identifying the section in which the loader will appear.
    open func loaderSectionInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 0
    }
    
    // - MARK: Add/remove methods
    
    override open func removeAllItems() {
        super.removeAllItems()
        clearPages()
    }
    
    override open func replaceAll(_ items: [T]) {
        super.replaceAll(items)
        clearPages()
    }
    
    /// Tells the collection view to add new elements and hide the loading cell and increment page count.
    ///
    /// - Parameters:
    ///     - items: Array of items to be added.
    ///     - isLastPage: If true, the collection view will not call `collectionView(_:readyForNextPageInSection:completion:)` when reaches last item.
    open func appendNewContents(from items: [T], isLastPage: Bool) {
        self.items.append(contentsOf: items)
        self.collectionView.reloadData()
        self.hasReachedLastPage = isLastPage
        self.currentPage += 1
        self.isLoading = false
    }
    
}
