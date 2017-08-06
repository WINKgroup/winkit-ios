//
//  WKTableViewDelegate.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 26/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// A concrete 'UITableViewDataSource' & `UITableViewDelegate` that helps you to implement infinite scrolling.
/// Since it's a concrete class, you should override before assignin to
/// a `tableView` to implement your behaviour.
///
/// - Important: Don't forget to retain this object,
/// since the `delegate` property of a `tableView` is weak.
///
open class WKTableViewInfiniteDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Initializers
    
    /// Initialize a `WKTableViewInfiniteDataSourceDelegate` with the given table view.
    ///
    /// - Parameter tableView: The table view that will own this dataSource and delegate. You don't need
    ///                       to set the delegate and the dataSource of the table view with this object,
    ///                       it is done automatically in this init.
    public init(tableView: UITableView) {
        self.tableView = tableView
        self.tableView.register(SpinnerTableViewCell.self, forCellReuseIdentifier: SpinnerTableViewCell.reuseIdentifier)
        
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    // MARK: - Properties
    
    public weak var tableView: UITableView!
    
    /// The color of the `UIActivityIndicatorView` that will be displayed
    /// at the bottom of the section when new page will be requested.
    /// If `nil` the `UIActivityIndicatorView` will be default of style `UIActivityIndicatorViewStyle.gray`.
    /// This property does nothing if you override ` tableView(_:loadingCellForRowAt:) -> UITableViewCell`
    open var spinnerColor: UIColor? {
        return nil
    }
    
    /// The section of the `tableView` in which the `UIActivityIndicatorView` will be displayed.
    /// This is used to tell the `tableView` in which section the infinite scroll will be
    /// applied. Deafult is 0.
    open var loaderSection: Int {
        return 0
    }
    
    /// The number of the current page. Start from 0.
    public fileprivate(set) var currentPage: Int = 0
    
    /// Inidicates if tableView has reached last page and no loader cell will be displayed when scroll to bottom.
    ///
    /// - Important: While this property is `true`, `tableView(_:readyForNextPageInSection:completion:)` won't be called.
    public fileprivate(set) var hasReachedLastPage = false
    
    
    /// If `true`, the loading view is visible. You cannot change the value of this variable;
    /// It is by default set to `false`, when `tableView(_:readyForNextPageInSection:completion:)` is called,
    /// this property is set to `true`, and when the `completion` parameter is called,
    /// this property become again false.
    ///
    /// - Important: While this property is `true`, `tableView(_:readyForNextPageInSection:completion:)` won't be called.
    public fileprivate(set) var isLoading: Bool = false {
        didSet {
            let count = tableView(tableView, numberOfRowsInSection: loaderSection)
            if isLoading {
                tableView.insertRows(at: [IndexPath(row: count - 1, section: loaderSection)], with: .automatic)
            } else {
                tableView.deleteRows(at: [IndexPath(row: count - 1, section: loaderSection)], with: .automatic)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var lastContentOffset = CGPoint(x: 0, y: 0)
    
    // MARK: - Methods
    
    /// Call this method when you want to reset the page counter, for example if the table view clear its elements.
    public func clearPages() {
        currentPage = 0
        hasReachedLastPage = false
    }
    
    
    /// Here's the implemetation of reaching last element. You can override this to do your own stuff.
    ///
    /// - Important: If you override this method, you **MUST** call super or unexpected behavior can occures.
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > lastContentOffset.y && tableView.isDragging,
            let indexPath = tableView.indexPathsForVisibleRows?.first(where: {
                $0.section == loaderSection && $0.row == tableView.numberOfRows(inSection: $0.section) - 1 &&
                    !isLoading && !hasReachedLastPage}) {
            isLoading = true
            self.tableView(tableView, readyForNextPageInSection: indexPath.section) { [unowned self] isLastPage in
                self.tableView.reloadData()
                self.hasReachedLastPage = isLastPage
                self.currentPage += 1
                self.isLoading = false
            }
        }
        
        lastContentOffset = scrollView.contentOffset
    }
    
    /// You can't override this method, it is intended for internal purpose; instead, override `tableView(_:infiniteCellForRowAt:)`.
    public final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == loaderSection && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 && isLoading {
            return self.tableView(tableView, loadingCellForRowAt: indexPath)
        }
        
        return self.tableView(tableView, normalCellForRowAt: indexPath)
    }
    
    /// You can't override this method, it is intended for internal purpose; instead, override `tableView(_:numberOfNormalRowsInSection:)`.
    public final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = self.tableView(tableView, numberOfNormalRowsInSection: section)
        count = section == loaderSection && isLoading ? count + 1 : count
        return count
    }
    
    /// Tells the delegate the table view has reached the last row in and is ready for the next page.
    /// You should override this method and implement your logic. Default does nothing.
    ///
    /// - Parameters:
    ///     - tableView: The tableView object telling is ready for next page.
    ///     - section: An index number identifying a section of tableView.
    ///     - completion: A closure that will end the loading process for you, it takes a Bool to tell the dataSource if this is the last page.
    ///
    /// - Important: You have to call the `completion` closure to end the loading and hide the `UIActivityIndicator`.
    ///              The completion will call for you `tableView.reladData()` and will perform other stuff to make everything working good.
    open func tableView(_ tableView: UITableView, readyForNextPageInSection section: Int, completion: @escaping (_ isLastPage: Bool)->Void) {
        
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    /// The returned UITableViewCell object is frequently one that the application reuses for performance reasons.
    /// You should fetch a previously created cell object that is marked for reuse by sending
    /// a `dequeueReusableCell(withIdentifier:)` message to tableView.
    /// Various attributes of a table cell are set automatically based on whether the cell is
    /// a separator and on information the data source provides, such as for accessory views and editing controls.
    /// The default implementation return a simple `UITableViewCell`, so in your overridden mthod, you can skip
    /// the super call.
    ///
    /// - Parameters:
    ///     - tableView: A table-view object requesting the cell.
    ///     - indexPath: An index path locating a row in tableView.
    ///
    /// - Note: This method is not called for the row that display the loading indicator.
    ///
    /// - Important: This is the `tableView(_:cellForRowAt:)` version of the `WKTableViewInfiniteDataSourceDelegate`,
    ///              so you should override this method instead of the original one.
    open func tableView(_ tableView: UITableView, normalCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    /// Asks the data source for a cell (that display the loading status of the table view)
    /// to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///     - tableView: A table-view object requesting the cell.
    ///     - indexPath: An index path locating a row in tableView.
    ///
    /// - Note: This method provide a default loading cell, override this to show a custom cell loading.
    open func tableView(_ tableView: UITableView, loadingCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpinnerTableViewCell.reuseIdentifier, for: indexPath) as! SpinnerTableViewCell
        cell.configure(withColor: spinnerColor)
        return cell
    }
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    ///
    /// - Parameters:
    ///     - tableView: The table-view object requesting this information.
    ///     - section: An index number identifying a section in tableView.
    open func tableView(_ tableView: UITableView, numberOfNormalRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}
