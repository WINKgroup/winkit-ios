//
//  IBDesignableViewController.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 07/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit

class IBDesignableViewController : WKTableViewController<VoidPresenter> {
    
    override class var storyboardName: String {
        return Storyboard.main.name
    }
    
}
