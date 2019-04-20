//
//  CGColor.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 19/06/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation
import CoreFoundation

extension CGColor {
    
    static func conditionallyCast<T>(_ value: T) -> CGColor? {
        guard CFGetTypeID(value as CFTypeRef) == CGColor.typeID else {
            return nil
        }
        return (value as! CGColor)
    }
    
}
