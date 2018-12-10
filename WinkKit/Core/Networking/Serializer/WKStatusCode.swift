//
//  StatusCode.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

/// Define requirement for a representable error.
public protocol WKCode: RawRepresentable, CustomStringConvertible, CustomDebugStringConvertible, Hashable {
    associatedtype CodeKind : RawRepresentable
    
    /// The code kind of the current status code.
    var kind: CodeKind { get }
    
    /// If true this code represents an error.
    var isError: Bool { get }
}

extension WKCode where Self.RawValue == Int {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
}

// MARK: HTTP Code
/// Map all common HTTP status codes in enum.
/// See https://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml for better explanations of each code.
/// `Equatable` and `Hashable` implementation are done by using the `rawValue`.
public enum HTTPStatusCode : WKCode {
    
    public typealias CodeKind = HTTPStatusCode.Kind
    
    /// The kind associated to each http status code.
    public enum Kind: String {
        /// This case is used to avoid problem if a new http status code is added to the official list, but in general it will never be used.
        case unknown
        
        /// All status codes between 100 and 199. Request received, continuing process.
        case informational
        
        /// All status codes between 200 and 299. The action was successfully received, understood, and accepted.
        case success
        
        /// All status codes between 300 and 399. Further action must be taken in order to complete the request.
        case redirection
        
        /// All status codes between 400 and 499. The request contains bad syntax or cannot be fulfilled.
        case clientError
        
        /// All status codes between 500 and 599. The server failed to fulfill an apparently valid request.
        case serverError
    }
    
    // MARK: HTTP Status Codes
    case `continue`
    case switchingProtocols
    case processing
    case earlyHints
    case ok
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case imUsed
    case multipleChoices
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case temporaryRedirect
    case permanentRedirect
    case badRequest
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case requestUriTooLong
    case unsupportedMediaType
    case requestedRangeNotSatisfiable
    case expectationFailed
    case iMATeapot
    case misdirectedRequest
    case unprocessableEntity
    case locked
    case failedDependency
    case upgradeRequired
    case preconditionRequired
    case tooManyRequests
    case requestHeaderFieldsTooLarge
    case connectionClosedWithoutResponse
    case unavailableForLegalReasons
    case clientClosedRequest
    case internalServerError
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case httpVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended
    case networkAuthenticationRequired
    
    case unknown
    
    /// The `Kind` of the current status code.
    public var kind: Kind {
        switch rawValue {
        case 100 ... 199:
            return .informational
        case 200 ... 299:
            return .success
        case 300 ... 399:
            return .redirection
        case 400 ... 499:
            return .clientError
        case 500 ... 599:
            return .serverError
        default:
            return .unknown
        }
    }
    
    public var isError: Bool {
        return kind != .success
    }
    
}

public extension HTTPStatusCode {
    
    public typealias RawValue = Int
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case 100: self = .`continue`
        case 101: self = .switchingProtocols
        case 102: self = .processing
        case 103: self = .earlyHints
            
            
        case 200: self = .ok
        case 201: self = .created
        case 202: self = .accepted
        case 203: self = .nonAuthoritativeInformation
        case 204: self = .noContent
        case 205: self = .resetContent
        case 206: self = .partialContent
        case 207: self = .multiStatus
        case 208: self = .alreadyReported
        case 226: self = .imUsed
            
            
        case 300: self = .multipleChoices
        case 301: self = .movedPermanently
        case 302: self = .found
        case 303: self = .seeOther
        case 304: self = .notModified
        case 305: self = .useProxy
        case 307: self = .temporaryRedirect
        case 308: self = .permanentRedirect
            
            
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 402: self = .paymentRequired
        case 403: self = .forbidden
        case 404: self = .notFound
        case 405: self = .methodNotAllowed
        case 406: self = .notAcceptable
        case 407: self = .proxyAuthenticationRequired
        case 408: self = .requestTimeout
        case 409: self = .conflict
        case 410: self = .gone
        case 411: self = .lengthRequired
        case 412: self = .preconditionFailed
        case 413: self = .payloadTooLarge
        case 414: self = .requestUriTooLong
        case 415: self = .unsupportedMediaType
        case 416: self = .requestedRangeNotSatisfiable
        case 417: self = .expectationFailed
        case 418: self = .iMATeapot
        case 421: self = .misdirectedRequest
        case 422: self = .unprocessableEntity
        case 423: self = .locked
        case 424: self = .failedDependency
        case 426: self = .upgradeRequired
        case 428: self = .preconditionRequired
        case 429: self = .tooManyRequests
        case 431: self = .requestHeaderFieldsTooLarge
        case 444: self = .connectionClosedWithoutResponse
        case 451: self = .unavailableForLegalReasons
        case 499: self = .clientClosedRequest
            
            
        case 500: self = .internalServerError
        case 501: self = .notImplemented
        case 502: self = .badGateway
        case 503: self = .serviceUnavailable
        case 504: self = .gatewayTimeout
        case 505: self = .httpVersionNotSupported
        case 506: self = .variantAlsoNegotiates
        case 507: self = .insufficientStorage
        case 508: self = .loopDetected
        case 510: self = .notExtended
        case 511: self = .networkAuthenticationRequired
            
        default: self = .unknown
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .`continue`: return 100
        case .switchingProtocols: return 101
        case .processing: return 102
        case .earlyHints: return 103
            
            
        case .ok: return 200
        case .created: return 201
        case .accepted: return 202
        case .nonAuthoritativeInformation: return 203
        case .noContent: return 204
        case .resetContent: return 205
        case .partialContent: return 206
        case .multiStatus: return 207
        case .alreadyReported: return 208
        case .imUsed: return 226
            
            
        case .multipleChoices: return 300
        case .movedPermanently: return 301
        case .found: return 302
        case .seeOther: return 303
        case .notModified: return 304
        case .useProxy: return 305
        case .temporaryRedirect: return 307
        case .permanentRedirect: return 308
            
            
        case .badRequest: return 400
        case .unauthorized: return 401
        case .paymentRequired: return 402
        case .forbidden: return 403
        case .notFound: return 404
        case .methodNotAllowed: return 405
        case .notAcceptable: return 406
        case .proxyAuthenticationRequired: return 407
        case .requestTimeout: return 408
        case .conflict: return 409
        case .gone: return 410
        case .lengthRequired: return 411
        case .preconditionFailed: return 412
        case .payloadTooLarge: return 413
        case .requestUriTooLong: return 414
        case .unsupportedMediaType: return 415
        case .requestedRangeNotSatisfiable: return 416
        case .expectationFailed: return 417
        case .iMATeapot: return 418
        case .misdirectedRequest: return 421
        case .unprocessableEntity: return 422
        case .locked: return 423
        case .failedDependency: return 424
        case .upgradeRequired: return 426
        case .preconditionRequired: return 428
        case .tooManyRequests: return 429
        case .requestHeaderFieldsTooLarge: return 431
        case .connectionClosedWithoutResponse: return 444
        case .unavailableForLegalReasons: return 451
        case .clientClosedRequest: return 499
            
            
        case .internalServerError: return 500
        case .notImplemented: return 501
        case .badGateway: return 502
        case .serviceUnavailable: return 503
        case .gatewayTimeout: return 504
        case .httpVersionNotSupported: return 505
        case .variantAlsoNegotiates: return 506
        case .insufficientStorage: return 507
        case .loopDetected: return 508
        case .notExtended: return 510
        case .networkAuthenticationRequired: return 511
            
        case .unknown: return -9999
        }
    }
    
}

public extension HTTPStatusCode {
    
    public var description: String {
        return "HTTP code: \(rawValue)"
    }
    
    public var debugDescription: String {
        return description
    }
}

// MARK: Other status code

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
    
    // MARK: Connection trouble status codes
    /// A connection error occurred, detail is a `URLError`. Code: -1
    case connectionError(detail: URLError)
    
    // MARK: Parsing errors
    /// HTTP connection went well but the response/error body has not been decoded successfully, detail is a `DecodingError`. Code: -100
    case jsonDecodingError(detail: DecodingError)
    
    /// HTTP connection went well but there was an empty response/error body. Code: -101
    case missingBody
    
    case unknown
    
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
    
    public var isError: Bool {
        return kind != .success
    }
}

public extension WKMiscCode {
    
    public typealias RawValue = Int
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case -1: self = .connectionError(detail: URLError(.unknown))
        case -100: self = .jsonDecodingError(detail: .dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Error automatically created by WKStatusCode.init(rawValue:) initializer")))
        case -101: self = .missingBody
        default: self = .unknown
        }
    }
    
    public var rawValue: RawValue {
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
    
    public var description: String {
        var desc = "Misc code: \(rawValue)"
        switch self {
        case .connectionError(let detail):
            desc += " Detail: \(detail)"
            
        case .jsonDecodingError(let detail):
            desc += " Detail: \(detail)"
        default:
            break
        }
        return desc
    }
    
    public var debugDescription: String {
        return description
    }
}
