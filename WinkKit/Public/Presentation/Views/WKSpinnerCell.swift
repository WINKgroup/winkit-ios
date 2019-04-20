//
//  WKSpinnerTableViewCell.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 30/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import UIKit

/// Represents a `UIView` that conforms to `WKLoadableSpinnerView`.
public typealias WKLoadableUIView = UIView & WKLoadableSpinnerView

/// Simple table view cell that displays a centered `UIActivityIndicatorView`
class WKSpinnerTableViewCell: UITableViewCell {

    static let reuseIdentifier = "WinkKit.WKSpinnerTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
    }
    
    func configure(with view: WKLoadableUIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            ])
    }

}

/// Simple collection view cell that displays a centered `UIActivityIndicatorView`
class WKSpinnerCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "WKSpinnerCollectionViewCell"
    
    func configure(with view: WKLoadableUIView) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            ])
    }
    
}


/// Every view that will show the loading status of an infinite scroll must conform to this protocol.
///
/// - SeeAlso: `WKCollectionViewInfiniteDataSourceDelegate`
/// - SeeAlso: `WKTableViewInfiniteDataSourceDelegate`
public protocol WKLoadableSpinnerView {
    
    /// Called when the infinite data source will show the loadable view.
    /// For example, if the loadable view contains an activity indicator view, in this method `activityIndicatorView.startAnimating()` should be called.
    func startAnimating()
}


/// Default loadable view to show in tableView or collectionView with infinite data source.
public class WKSpinnerView: WKLoadableUIView {
    
    let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    func setup() {
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            activityIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    
    public func startAnimating() {
        activityIndicatorView.startAnimating()
    }

}
