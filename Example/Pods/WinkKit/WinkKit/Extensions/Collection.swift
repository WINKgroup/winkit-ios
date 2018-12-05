//
//  Collection.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 08/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

public extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
