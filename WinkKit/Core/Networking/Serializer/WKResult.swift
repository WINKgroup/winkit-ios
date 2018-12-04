//
//  WKResult.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// Empty struct for non serializable response body.
public struct WKVoidBody: Decodable {}

/// This is the enum result of DataRequest extension. It allows to parse a response body for both success and error cases.
public enum WKFullResult<T, E: Decodable> {
    /// If success, return the response body already parsed as object,
    case success(T)
    
    /// If failure, returns a `WKApiError`
    case failure(WKApiBodyError<E>)
}

/// This is the enum result of DataRequest extension.
public enum WKResult<T> {
    /// If success, return the response body already parsed as object,
    case success(T)
    
    /// If failure, returns a `WKApiError`
    case failure(WKApiSimpleError)
}

/// This is the enum result of DataRequest extension without .
public enum WKSimpleResult {
    /// If success, return the response body already parsed as object,
    case success
    
    /// If failure, returns a `WKApiError`
    case failure(WKApiSimpleError)
}
