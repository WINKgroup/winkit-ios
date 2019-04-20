//
//  WKResult.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// This is the enum result of DataRequest extension.
/// Equatable implementation is done without considering the body. So if two results are both `.success`, `==` will return `true`.
public enum WKResult<T> {
    
    /// If success, return the response body already parsed as object,
    case success(T)
    
    /// If failure, returns a `WKApiError`
    case failure(WKApiSimpleError)
    
}

extension WKResult: Equatable {
    
    public static func ==(lhs: WKResult, rhs: WKResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success): return true
        case  (.failure(let e), .failure(let e2)): return e.httpCode == e2.httpCode && e.miscCode == e2.miscCode
        default: return false
        }
    }
    
}
