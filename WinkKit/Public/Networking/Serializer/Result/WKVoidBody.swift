//
//  WKVoidBody.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// Empty struct for non serializable response body.
///
/// Every `WKVoidBody` represent an empty body; this means that every instance of this is implicitly equals to any other.
public struct WKVoidBody: Decodable {}

extension WKVoidBody: Equatable {
    
    public static func ==(lhs: WKVoidBody, rhs: WKVoidBody) -> Bool {
        return true
    }
    
}
