//
//  WKApiError.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 14/04/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import Foundation

/// The protocol that defines base requirements for http calls.
/// There are two different codes to know what went wrong with the http request.
/// The `HTTPStatusCode` is the status code of the http protocol (200, 400, 500...).
/// The `WKMiscCode` is a generic code that represent a non-http error, like connection errors, body parsing errors.
/// You can check both to show to the user the most proper message.
public protocol WKApiError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// The http status code of this error.
    ///
    /// This property is `nil` if there's a problem in communication, for instance if there's no internet or
    /// a request timeout occurred.
    var httpCode: HTTPStatusCode? { get }
    
    /// Code non related to http status. It's useful to handle connection errors or body decoding errors.
    var miscCode: WKMiscCode { get }
    
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

public extension WKApiError {
    
    var description: String {
        return miscCode.description + " " + (httpCode?.description ?? "")
    }
    
    var debugDescription: String {
        return httpCode.debugDescription
    }
    
}
