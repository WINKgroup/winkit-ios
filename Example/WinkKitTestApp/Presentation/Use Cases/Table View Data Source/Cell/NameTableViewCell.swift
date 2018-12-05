//
//  NameTableViewCell.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 04/10/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class NameTableViewCell: WKTableViewCell<NamePresenter> {
    
    @IBOutlet private var nameLabel: UILabel!
    
}

extension NameTableViewCell: NameView {
    
    func show(name: String) {
        nameLabel.text = name
    }
    
}
