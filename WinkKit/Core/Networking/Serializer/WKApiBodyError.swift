//
//  WKApiBodyError.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// The protocol that defines base requirements for http calls.
public protocol WKApiError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// The status code of this error.
    var code: WKStatusCode { get }
}

public extension WKApiError {
    public var description: String {
        return code.description
    }
    
    public var debugDescription: String {
        return code.debugDescription
    }
}

/// Simple implementation of `WKApiError`.
public struct WKApiSimpleError: WKApiError {
    
    public static var unknown: WKApiSimpleError {
        return WKApiSimpleError(code: .unknown)
    }

    public let code: WKStatusCode
    
    /// Create an error.
    ///
    /// - Parameters:
    ///   - code: The code that identifies this error.
    public init(code: WKStatusCode) {
        self.code = code
    }
    
    /// Create an error starting from `URLError`.
    ///
    /// - Parameter urlError: the `URLError`.
    init(urlError: URLError) {
        code = .connectionError(detail: urlError)
    }
    
    /// Create an error starting from a `DecodingError`.
    ///
    /// - Parameter decodingError: The `DecodingError` that caused the error.
    init(decodingError: DecodingError) {
        code = .jsonDecodingError(detail: decodingError)
    }
}

/// Implementation of `WKApiError` that can contain a body too.
public struct WKApiBodyError<Body: Decodable>: WKApiError {
    
    public static var unknown: WKApiBodyError {
        return WKApiBodyError(code: .unknown, body: nil)
    }
    
    public let code: WKStatusCode
    
    /// An optional body. Useful for additional info, for instance a 400 Bad Request error, may contain a json that explains what's the problem.
    /// If you don't care about this value, you can
    public let body: Body?
    
    
    /// Create an error.
    ///
    /// - Parameters:
    ///   - code: The code that identifies this error.
    ///   - body: An optional body.
    public init(code: WKStatusCode, body: Body? = nil) {
        self.code = code
        self.body = body
    }
    
    /// Create an error starting from a `URLError`.
    ///
    /// - Parameter urlError: the `URLError`.
    init(urlError: URLError) {
        body = nil
        code = .connectionError(detail: urlError)
    }
    
    
    /// Create an error starting from a `DecodingError`.
    ///
    /// - Parameter decodingError: The `DecodingError` that caused the error.
    init(decodingError: DecodingError) {
        body = nil
        code = .jsonDecodingError(detail: decodingError)
    }
}
