//
//  WKSimpleResult.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// This is the enum result of DataRequest extension without .
/// Equatable implementation is done without considering the body. So if two results are both `.success`, `==` will return `true`.
public enum WKSimpleResult {
    
    /// If success, return the response body already parsed as object,
    case success
    
    /// If failure, returns a `WKApiError`
    case failure(WKApiSimpleError)
    
}

extension WKSimpleResult: Equatable {
    
    public static func ==(lhs: WKSimpleResult, rhs: WKSimpleResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success): return true
        case  (.failure(let e), .failure(let e2)): return e.httpCode == e2.httpCode && e.miscCode == e2.miscCode
        default: return false
        }
    }
    
}
