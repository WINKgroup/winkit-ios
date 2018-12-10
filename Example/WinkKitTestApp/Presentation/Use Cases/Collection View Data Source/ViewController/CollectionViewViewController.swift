//
//  CollectionViewViewController.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 05/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class CollectionViewViewController: CoreViewController<CollectionViewPresenter> {
    
    override class var storyboardName: String {
        return Storyboard.main.name
    }
    @IBOutlet private var separatorHeightConstraints: [NSLayoutConstraint]!
    
    @IBOutlet private var verticalCollectionView: UICollectionView!
    @IBOutlet private var collectionView: UICollectionView!
    
    private var verticalDataSource: NameCollectionViewDataSource!
    private var dataSource: NameCollectionViewDataSource!
    
    override func viewDidLoad() {
        dataSource = NameCollectionViewDataSource(collectionView: collectionView) { [unowned self] in
            self.presenter.addMore()
        }
        verticalDataSource = NameCollectionViewDataSource(collectionView: verticalCollectionView) { [unowned self] in
            self.presenter.addMore()
        }
        super.viewDidLoad()
        separatorHeightConstraints.forEach { $0.constant = 0.5 }
    }
}

extension CollectionViewViewController: CollectionViewView {

    func show(names: [String]) {
        dataSource.replaceAll(names)
        verticalDataSource.replaceAll(names)
    }
    
    func addMoreNames(names: [String]) {
        dataSource.appendNewContents(from: names, isLastPage: false)
        verticalDataSource.appendNewContents(from: names, isLastPage: false)
    }
}
