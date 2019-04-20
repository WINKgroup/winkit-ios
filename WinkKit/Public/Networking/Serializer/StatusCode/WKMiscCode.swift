//
//  WKMiscCode.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 14/04/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import Foundation

/// Represent statuses that are non-http.
public enum WKMiscCode : WKCode {
    
    public typealias CodeKind = Kind
    
    /// The kind associated to the code.
    public enum Kind: String {
        
        /// This case is used to avoid problem if a new http status code is added to the official list, but in general it will never be used.
        case unknown
        
        /// Indicates that no error occurred.
        case success
        
        /// Indicates that the connection has been successfully executed, but there are Application error (like http 500 or bad requests).
        case failure
        
        /// All codes that indicate a connection error, such as server not found, connection lost, timeout errors.
        /// Connection error means that the communication failed and no response will be fetched.
        case connectionError
        
        /// All codes that indicate a wrong body parsing error. For example if a body returned in response doesn't match the `Decodable` or if the returned body is not a valid serializable (For instance if you expect a json but the server returns an html page).
        case serializationError
        
    }
    
    /// No error occurred. Code: 0
    case ok
    
    /// HTTP connection went well but an application error occurred. Code: 1
    case failure
    
    /// A connection error occurred, detail is a `URLError`. Code: -1
    case connectionError(detail: URLError)
    
    /// HTTP connection went well but the response/error body has not been decoded successfully, detail is a `DecodingError`. Code: -100
    case jsonDecodingError(detail: DecodingError)
    
    /// HTTP connection went well but there was an empty response/error body. Code: -101
    case missingBody
    
    /// Unknown error happened.
    case unknown
    
    /// The error kind.
    public var kind: Kind {
        switch rawValue {
        case -99 ... -1:
            return .connectionError
        case -199 ... -100:
            return .serializationError
        case 0:
            return .success
        case 1:
            return .failure
        default:
            return .unknown
        }
    }
    
    /// Returns `true` if kind property is not `Kind.success`.
    public var isError: Bool {
        return kind != .success
    }
    
}

public extension WKMiscCode {
    
    typealias RawValue = Int
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case -1: self = .connectionError(detail: URLError(.unknown))
        case -100: self = .jsonDecodingError(detail: .dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Error automatically created by WKStatusCode.init(rawValue:) initializer")))
        case -101: self = .missingBody
        default: self = .unknown
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .ok: return 0
        case .failure: return 1
        case .connectionError: return -1
        case .jsonDecodingError: return -100
        case .missingBody: return -101
        case .unknown: return -10000
        }
    }
    
}

public extension WKMiscCode {
    
    var description: String {
        var desc = "Misc code: \(rawValue)"
        switch self {
        case .connectionError(let detail): desc += " Detail: \(detail)"
        case .jsonDecodingError(let detail): desc += " Detail: \(detail)"
        default: break
        }
        return desc
    }
    
    var debugDescription: String {
        return description
    }
    
}
