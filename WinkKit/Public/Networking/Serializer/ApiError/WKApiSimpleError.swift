//
//  WKApiSimpleError.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 14/04/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import Foundation

/// Simple implementation of `WKApiError`.
public struct WKApiSimpleError: WKApiError {
    
    /// Return an instance representing an unknown error.
    ///
    /// Basically it calls for you `WKApiSimpleError(miscCode: .unknown, httpCode: .unknown)`.
    public static var unknown: WKApiSimpleError {
        return WKApiSimpleError(miscCode: .unknown, httpCode: .unknown)
    }
    
    public let httpCode: HTTPStatusCode?
    public let miscCode: WKMiscCode
    
    /// Create an error.
    ///
    /// - Parameters:
    ///   - code: The code that identifies this error.
    public init(miscCode: WKMiscCode, httpCode: HTTPStatusCode?) {
        self.miscCode = miscCode
        self.httpCode = httpCode
    }
    
    /// Create an error starting from `URLError`.
    ///
    /// - Parameter urlError: the `URLError`.
    init(urlError: URLError) {
        miscCode = .connectionError(detail: urlError)
        httpCode = nil
    }
    
    /// Create an error starting from a `DecodingError`.
    ///
    /// - Parameter decodingError: The `DecodingError` that caused the error.
    init(decodingError: DecodingError, httpCode: HTTPStatusCode) {
        miscCode = .jsonDecodingError(detail: decodingError)
        self.httpCode = httpCode
    }
    
}
