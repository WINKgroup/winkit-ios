//
//  WKApiBodyError.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// The protocol that defines base requirements for http calls.
/// There are two different codes to know what went wrong with the http request.
/// The `HTTPStatusCode` is the status code of the http protocol (200, 400, 500...).
/// The `WKMiscCode` is a generic code that represent a non-http error, like connection errors, body parsing errors.
/// You can check both to show to the user the most proper message.
public protocol WKApiError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// The http status code of this error. This property is `nil` if there's a problem in communication, for instance if there's no internet or
    /// a request timeout occurred.
    var httpCode: HTTPStatusCode? { get }
    
    /// Code non related to http status. It's useful to handle connection errors or body decoding errors.
    var miscCode: WKMiscCode { get }
}

public extension WKApiError {
    public var description: String {
        return miscCode.description + " " + (httpCode?.description ?? "")
    }
    
    public var debugDescription: String {
        return httpCode.debugDescription
    }
}

/// Simple implementation of `WKApiError`.
public struct WKApiSimpleError: WKApiError {
    
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

/// Implementation of `WKApiError` that can contain a body too.
public struct WKApiBodyError<Body: Decodable>: WKApiError {
    
    public static var unknown: WKApiBodyError {
        return WKApiBodyError(miscCode: .unknown, httpCode: .unknown, body: nil)
    }
    
    public let httpCode: HTTPStatusCode?
    public let miscCode: WKMiscCode
    
    /// An optional body. Useful for additional info, for instance a 400 Bad Request error, may contain a json that explains what's the problem.
    /// If you don't care about this value, you can
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
