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
/// When a service get destroyed, every request enqueued with `enqueue(_:)` method is cancelled.
open class WKService {
    
    /// Class that manages an array of requests that need to be executed sequencially.
    open class RequestChain {
    
        public typealias CompletionHandler = (_ success: Bool, _ errorResult: ErrorResult?) -> Void
        
        /// Contains info about an error thrown by a request.
        public struct ErrorResult {
            
            /// The dataRequest that failed.
            public let request: DataRequest?
            
            /// The associated error.
            public let error: Error?
        }
        
        /// All requests of the current chain.
        private(set) public var requests: [DataRequest]
        
        
        /// Create a `RequestChain` with the given requests.
        ///
        /// - Parameter requests: The array of `DataRequests` to be enqueued.
        public init(requests: [DataRequest]) {
            self.requests = requests
        }
        
        
        /// Start the chain enqueue.
        ///
        /// - Parameter completion: A closure called when all request succeed or when one fails.
        public func start(_ completion: @escaping CompletionHandler) {
            if let request = requests.first {
                request.response { (response: DefaultDataResponse) in
                    if let error = response.error {
                        completion(false, ErrorResult(request: request, error: error))
                        return
                    }
                    
                    self.requests.removeFirst()
                    self.start(completion)
                }
                request.resume()
            } else {
                completion(true, nil)
                return
            }
            
        }
        
        /// Cancel all requests of this chain.
        public func cancelAllRequests() {
            requests.forEach { $0.cancel() }
            requests.removeAll()
        }
    }
    
    public init() {}
    
    /// All `DataRequest` managed by this service. It doesn't contains finished requests.
    /// This array is filled when `enqueue(urlRequest:)` gets called.
    private(set) public var requests = [DataRequest]()
    
    /// All `RequestChain` managed by this service. It doesn't contains finished requests.
    /// This array is filled when `enqueueChain(urlRequests:)` gets called.
    private(set) public var requestChains = [RequestChain]()
    
    /// Enqueue the given request: the request will be stored in `requests` array and will
    /// perform http call. When request finishes, it's removed from array.
    ///
    /// - Parameter urlRequest: The `URLRequestConvertible` that will be enqueued nd stored.
    /// - Returns: The created `DataRequest` to add a response.
    @discardableResult
    public func enqueue(urlRequest: URLRequestConvertible) -> DataRequest {
        let request = SessionManager.default.request(urlRequest)
        requests.append(request)
        let index = requests.count - 1
        return request.response() { res in
            self.requests.remove(at: index)
        }
    }
    
    
    /// Enqueue a chain of requests
    ///
    /// - Parameter urlRequests: The array of url request convertible to be enqueued.
    /// - Returns: The `RequestChain` object created.
    public func enqueueChain(urlRequests: [URLRequestConvertible]) -> RequestChain {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = SessionManager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        let chain = RequestChain(requests: urlRequests.map { SessionManager.default.request($0) })
        
        self.requestChains.append(chain)
        let index = requestChains.count - 1

        chain.start { done, error in
            self.requestChains.remove(at: index)
        }
        
        return chain
    }
    
    /// Cancel all requests and chainRequests created by this `WKService`. It doesn't cancel
    /// all Alamofire's `SessionManager` requests.
    public func cancelAllRequests() {
        requests.forEach({ $0.cancel() })
        requests.removeAll()
        
        requestChains.forEach { $0.cancelAllRequests() }
    }
    
    deinit {
        cancelAllRequests()
    }
    
}
