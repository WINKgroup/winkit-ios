//
//  WKRequest.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 03/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation
import Alamofire

/// Define a request of an API call. An instance of a `WKRequest` must be used by a `WKService` using the `enqueue(_:)` or `enqueueChain(requests:)` methods.
public struct WKRequest {
    
    /// The endpoint of this API. This is automatically appended to the base url.
    public let endpoint: String
    
    /// The http method.
    public let method: HTTPMethod
    
    /// The parameter encoding type. Default is `Alamofire.URLEncoding`.
    public let encoding: ParameterEncoding
    
    /// A dictionary containing the params of this request.
    public let params: [String: Any]?
    
    /// A dictionary containing headers of this request.
    private(set) public var headers: HTTPHeaders
    
    /// The timeoutInterval for the request. Default is taken from the `URLSessionConfiguration` default instance.
    internal(set) public var timeoutInterval: TimeInterval
    
    var baseUrl: URL!
    
    /// Create an API route with the given arguments.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint of the calling api; this will be automatically appended to the base url. I.e "api/users/123"
    ///   - method: The HTTP method. Default is `get`.
    ///   - encoding: The parameter encoding. Default is `URLEncoding`.
    ///   - params: The params that will be econded.
    ///   - headers: The `HTTPHeaders`. The content-type of the request is automatically assigned based on the `encoding` param. For instance, if the encoding is `JSONEncoding` the content-type will be `MimeType.json`. However, if you add the content-type in this dictionary, your value will override the default one.
    public init(endpoint: String, method: HTTPMethod = .get, encoding: ParameterEncoding = URLEncoding.default, params: [String: Any]? = nil, headers: HTTPHeaders? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.encoding = encoding
        self.params = params
        
        var contentType = ""
        switch encoding {
        case is JSONEncoding:
            contentType = MimeType.json.string
        case is PropertyListEncoding:
            contentType = MimeType.plist.string
        default:
            contentType = MimeType.urlEncoded.string
        }
        
        self.headers = ["Content-Type" : contentType]
        self.headers.merge(headers ?? [:]) { $1 } // this will override content type if passed.

        timeoutInterval = URLSessionConfiguration.default.timeoutIntervalForRequest
    }
    
    /// Create an API route with the given arguments.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint of the calling api; this will be automatically appended to the base url. I.e "api/users/123"
    ///   - method: The HTTP method. Default is `get`.
    ///   - encoding: The parameter encoding. Default is `URLEncoding`.
    ///   - object: The `Encodable` object that will be econded as params for the request.
    ///   - headers: The `HTTPHeaders`. The content-type of the request is automatically assigned based on the `encoding` param. For instance, if the encoding is `JSONEncoding` the content-type will be `MimeType.json`. However, if you add the content-type in this dictionary, your value will override the default one.
    public init<T: Encodable>(endpoint: String, method: HTTPMethod = .get, encoding: ParameterEncoding = URLEncoding.default, object: T? = nil, headers: HTTPHeaders? = nil) {
        var params: [String: Any]?
        if let o = object, let data = try? JSONEncoder().encode(o) {
            params = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
        }
        

        self.init(endpoint: endpoint, method: method, encoding: encoding, params: params, headers: headers)
    }
    
}

extension WKRequest: URLRequestConvertible {
    
    public func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: baseUrl.appendingPathComponent(endpoint), method: method, headers: headers)
        request.timeoutInterval = timeoutInterval
        if let params = params {
            request = try encoding.encode(request, with: params)
        }
        return request
    }

}
