//
//  Storyboards.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 10/09/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    
    var name: String {
        return rawValue
    }
    
    var newInstance: UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
}
