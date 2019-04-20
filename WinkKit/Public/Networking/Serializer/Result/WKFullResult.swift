//
//  WKFullResult.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// This is the enum result of DataRequest extension. It allows to parse a response body for both success and error cases.
/// Equatable implementation is done without considering the body. So if two results are both `.success`, `==` will return `true`.
public enum WKFullResult<T, E: Decodable> {
    
    /// If success, return the response body already parsed as object,
    case success(T)
    
    /// If failure, returns a `WKApiError`
    case failure(WKApiBodyError<E>)
    
}

extension WKFullResult: Equatable {
    
    public static func ==(lhs: WKFullResult, rhs: WKFullResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success): return true
        case  (.failure(let e), .failure(let e2)): return e.httpCode == e2.httpCode && e.miscCode == e2.miscCode
        default: return false
        }
    }
    
}
