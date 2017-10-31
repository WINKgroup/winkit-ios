//
//  BaseService.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 01/09/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Alamofire

/// A `WKService` is the class that performs http calls. It must use `Alamofire` to do it.
/// This class is intended to be subclassed. A tipical implementation could be a PostService class
/// for a social network app. PostService will have methods like `createPost(_:completion:)`, `fetchPosts(completion:)`
/// that create `DataRequest` and use `enqueue(_:)` method to start the request.
open class WKService {

    public init() {}

    /// All `DataRequest` managed by this service. It doesn't contains finished requests.
    private(set) public var requests = [DataRequest]()
    
    /// Cancel all `DataRequest` created by this `WKService`. It doesn't cancel
    /// all Alamofire's `SessionManager` requests.
    public func cancelAllRequests() {
        requests.forEach({ $0.cancel() })
        requests.removeAll()
    }
    
    /// Enqueue the given request: the request will be stored in `requests` array and will
    /// perform http call. When request finishes, it's removed from array.
    ///
    /// - Parameter urlRequest: The `URLRequestConvertible` that will be enqueued nd stored.
    ///
    public func enqueue(_ urlRequest: URLRequestConvertible) -> DataRequest {
        let request = SessionManager.default.request(urlRequest)
        requests.append(request)
        let index = requests.count - 1
        return request.response() { res in
            self.requests.remove(at: index)
        }
    }
    
    deinit {
        cancelAllRequests()
    }
    
}
