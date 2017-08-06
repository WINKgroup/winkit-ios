//
//  AlamofireResponse.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 06/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation
import Alamofire
import Argo

/// The base protocol `Error` of the web requests of the Framework.
public protocol WKError: Error {
    
}

/// The concrete `Error` of the web requests of the Framework.
struct WKWebError: WKError {
    
    /// The different error types.
    enum WKErrorType {
        
        /// A json decoding fails due to client or server problem.
        case jsonSerializingError
        
        /// The client side error occurred.
        case clientError
        
        /// A server side error occurred.
        case serverError
    }
    
    // MARK: - Properties
    
    /// Indicates the error type.
    let errorType: WKWebError.WKErrorType
    
    /// Textual description of the error or nil.
    let description: String?
    
    /// The error code if available or nil.
    let code: Int?
    
    // MARK: - Initializers
    
    init(error: WKWebError.WKErrorType) {
        self.errorType = error
        self.code = nil
        self.description = nil
    }
    
    init(error: WKWebError.WKErrorType, localizedDescription: String) {
        self.errorType = error
        self.code = nil
        self.description = localizedDescription
    }
    
    init(error: WKWebError.WKErrorType, code: Int) {
        self.errorType = error
        self.code = code
        self.description = nil
    }
    
    init(error: WKWebError.WKErrorType, code: Int, localizedDescription: String) {
        self.errorType = error
        self.code = code
        self.description = localizedDescription
    }

}

extension DataRequest {
    
    @discardableResult func responseObject<T: Argo.Decodable>(completionHandler: @escaping (DataResponse<T>) -> Void) -> Self where T == T.DecodedType {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil, let response = response else {
                let errDesc = error?.localizedDescription ?? "unknown"
                return .failure(WKWebError(error: .clientError, localizedDescription: errDesc))
            }

            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            //Response contains a valid JSON
            case .success(let value):
                let value = value as Any
                
                //Status code 2XX: expecting a resource object
                if case 200 ... 299 = response.statusCode {
                    //Process headers
                    //Check if JSON contains a valid resource object
                    let obj: Decoded<T> = decode(value)
                    switch (obj) {
                    //Object successfully decoded from JSON
                    case let .success(value):
                        return .success(value)
                    //JSON format unexpected
                    case .failure(let err):
                        return .failure(WKWebError(error: .jsonSerializingError, code: response.statusCode, localizedDescription: err.localizedDescription))
                    }
                }
                    //Status code 4XX/5XX: expecting an error object
                else {
                    return .failure(WKWebError(error: .serverError, code: response.statusCode))
                }
                
            //Response does not contain a valid JSON
            case .failure(let err):
                return .failure(WKWebError(error: .jsonSerializingError, code: response.statusCode, localizedDescription: err.localizedDescription))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    
    @discardableResult func responseCollection<T: Argo.Decodable>(arrayName: String = "objects", completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self where T == T.DecodedType {
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            guard error == nil, let response = response else {
                let errDesc = error?.localizedDescription ?? "unknown"
                return .failure(WKWebError(error: .clientError, localizedDescription: errDesc))
            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            //Response contains a valid JSON
            case .success(let value):
                let value = value as AnyObject
                
                //Status code 2XX: expecting a resource object
                if case 200 ... 299 = response.statusCode {
                    //Process headers
                    //Check if JSON contains a valid resource object
                    if let params = value[arrayName], params != nil {
                        let obj: Decoded<[T]> = decode(params!)
                        switch (obj) {
                        //Object successfully decoded from JSON
                        case let .success(value):
                            return .success(value)
                        //JSON format unexpected
                        case .failure(let err):
                            return .failure(WKWebError(error: .jsonSerializingError, code: response.statusCode, localizedDescription: err.localizedDescription))
                        }
                    }
                    return .failure(WKWebError(error: .jsonSerializingError, code: response.statusCode, localizedDescription: "No objects array found"))
                }
                    //Status code 4XX/5XX: expecting an error object
                else {
                    return .failure(WKWebError(error: .serverError, code: response.statusCode))
                }
            //Response does not contain a valid JSON
            case .failure(let err):
                return .failure(WKWebError(error: .jsonSerializingError, code: response.statusCode, localizedDescription: err.localizedDescription))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
