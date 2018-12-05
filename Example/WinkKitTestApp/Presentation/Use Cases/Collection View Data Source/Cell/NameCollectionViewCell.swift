//
//  NameCollectionViewCell.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 05/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class NameCollectionViewCell: WKCollectionViewCell<NameForCellPresenter> {
    @IBOutlet private var nameLabel: UILabel!
    
}

extension NameCollectionViewCell: NameForCellView {
    func show(name: String) {
        nameLabel.text = name
    }
}
