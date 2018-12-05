//
//  NameCollectionViewDataSource.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 05/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class NameCollectionViewDataSource: WKCollectionViewInfiniteDataSourceDelegate<String> {
    
    let paginationHandler: () -> Void
    
    init(collectionView: UICollectionView, paginationHandler: @escaping () -> Void) {
        self.paginationHandler = paginationHandler
        super.init(collectionView: collectionView)
        collectionView.register(cell: NameCollectionViewCell.self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, normalCellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: NameCollectionViewCell.self, for: indexPath)
        
        let presenter = NameForCellPresenter(view: cell, name: items[indexPath.row])
        cell.configure(with: presenter)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, readyForNextPageInSection section: Int) {
        paginationHandler()
    }
    
}
