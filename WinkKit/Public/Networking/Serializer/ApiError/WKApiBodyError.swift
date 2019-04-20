//
//  WKApiBodyError.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// Implementation of `WKApiError` that can contain a body too.
public struct WKApiBodyError<Body: Decodable>: WKApiError {
    
    public static var unknown: WKApiBodyError {
        return WKApiBodyError(miscCode: .unknown, httpCode: .unknown, body: nil)
    }
    
    public let httpCode: HTTPStatusCode?
    public let miscCode: WKMiscCode
    
    /// An optional error body.
    ///
    /// Useful for additional info, for instance a 400 Bad Request error, may contain a json that explains what's the problem.
    /// If you don't care about this value, you can use `WKApiSimpleError` instead of this.
    public let body: Body?
    
    /// Create an error.
    ///
    /// - Parameters:
    ///   - httpCode: The code that identifies this error.
    ///   - body: An optional body.
    public init(miscCode: WKMiscCode, httpCode: HTTPStatusCode?, body: Body? = nil) {
        self.miscCode = miscCode
        self.httpCode = httpCode
        self.body = body
    }
    
    /// Create an error starting from a `URLError`.
    ///
    /// - Parameter urlError: the `URLError`.
    init(urlError: URLError) {
        body = nil
        httpCode = nil
        miscCode = .connectionError(detail: urlError)
    }
    
    
    /// Create an error starting from a `DecodingError`.
    ///
    /// - Parameter decodingError: The `DecodingError` that caused the error.
    init(decodingError: DecodingError, httpCode: HTTPStatusCode) {
        self.httpCode = httpCode
        body = nil
        miscCode = .jsonDecodingError(detail: decodingError)
    }
}
