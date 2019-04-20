//
//  WKCode.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 14/04/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import Foundation

/// Define requirement for a representable code.
public protocol WKCode: RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible, Hashable {
    
    associatedtype CodeKind : RawRepresentable
    
    /// The code kind of the current status code.
    var kind: CodeKind { get }
    
    /// If true this code represents an error.
    var isError: Bool { get }
    
}

extension WKCode where Self.RawValue: Hashable {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
}
