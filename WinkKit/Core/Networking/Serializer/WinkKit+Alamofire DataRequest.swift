//
//  Serializer.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 03/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation
import Alamofire

/// By extending DataRequest with your custom implementation of object or array, you can simply return already parsed objects.
public extension DataRequest {
    
    /// Perform the `DataRequest`
    ///
    /// - Parameters:
    ///   - decoder: The `JSONDecoder` used to deserialize data. Default is a simple instance.
    ///   - completion: Closure that
    /// - Returns: The `DataRequest` itself.
    @discardableResult public func responseJSONToObject<T: Decodable, E: Decodable>(decoder: JSONDecoder = JSONDecoder(), completion: @escaping (WKFullResult<T, E>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            printRequest(request: request, response: response, data: data, error: error)

            // If error and no response, the connection failed before communicating with the server
            guard error == nil, let response = response else {
                if let urlError = error as? URLError {
                    return .failure(WKApiBodyError<E>(urlError: urlError))
                }
                else {
                    return .failure(WKApiBodyError<E>(code: .unknown))
                }
            }
            
            // Otherwise the communication worked. Now let's check the server response.
            guard let code = WKStatusCode(rawValue: response.statusCode), code.kind != .unknown else {
                WKLog.error("Found unexpected error code \(response.statusCode). Please open issue in WinkKit repo and add that code to enum.")
                return .failure(WKApiBodyError<E>(code: .unknown))
            }
            
            if code.isError {
                var errorBody: E?
                if let data = data {
                    do {
                        errorBody = try decoder.decode(E.self, from: data)
                    } catch let decodingError as DecodingError {
                        CommandLineHelper.debugHttpRequest("DecodingError \(decodingError)")
                        return .failure(WKApiBodyError<E>(decodingError: decodingError))
                    } catch {
                        return .failure(WKApiBodyError<E>(code: .unknown)) // should never happens
                    }
        
                    if errorBody == nil {
                        return .failure(WKApiBodyError<E>(code: code))
                    }
                }
                
                CommandLineHelper.debugHttpRequest("Decoded error body -> code: \(code) body: \(String(describing: errorBody))")
                return .failure(WKApiBodyError<E>(code: code, body: errorBody))
            } else {
                if let data = data {
                    do {
                        let obj = try decoder.decode(T.self, from: data)
                        CommandLineHelper.debugHttpRequest("Decoded success body -> code: \(code) body: \(String(describing: obj))")
                        return .success(obj)
                    } catch let decodingError as DecodingError {
                        CommandLineHelper.debugHttpRequest("DecodingError \(decodingError)")
                        return .failure(WKApiBodyError<E>(decodingError: decodingError))
                    } catch {
                        return .failure(WKApiBodyError<E>(code: .unknown)) // should never happens
                    }
                    
                } else {
                    CommandLineHelper.debugHttpRequest("Missing expected body of type \(T.self)")
                    return .failure(WKApiBodyError<E>(code: .missingBody))
                }
            }
        }
        
        return response(responseSerializer: responseSerializer) { dataResponse in
            switch dataResponse.result {
            case let .success(o):
                completion(.success(o))
                
            case let .failure(e):
                completion(.failure(e as! WKApiBodyError<E>))
            }
        }
    }
    
    /// Perform the `DataRequest`
    ///
    /// - Parameters:
    ///   - decoder: The `JSONDecoder` used to deserialize data. Default is a simple instance.
    ///   - completion: Closure that
    /// - Returns: The `DataRequest` itself.
    @discardableResult public func responseJSONToObject<T: Decodable>(decoder: JSONDecoder = JSONDecoder(), completion: @escaping (WKResult<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            printRequest(request: request, response: response, data: data, error: error)
            
            // If error and no response, the connection failed before communicating with the server
            guard error == nil, let response = response else {
                if let urlError = error as? URLError {
                    return .failure(WKApiSimpleError(urlError: urlError))
                }
                else {
                    return .failure(WKApiSimpleError(code: .unknown))
                }
            }
            
            // Otherwise the communication worked. Now let's check the server response.
            guard let code = WKStatusCode(rawValue: response.statusCode), code.kind != .unknown else {
                WKLog.error("Found unexpected error code \(response.statusCode). Please open issue in WinkKit repo and add that code to enum.")
                return .failure(WKApiSimpleError(code: .unknown))
            }
            
            if code.isError {
                return .failure(WKApiSimpleError(code: code))
            } else {
                if let data = data {
                    do {
                        let obj = try decoder.decode(T.self, from: data)
                        CommandLineHelper.debugHttpRequest("Decoded success body -> code: \(code) body: \(String(describing: obj))")
                        return .success(obj)
                    } catch let decodingError as DecodingError {
                        CommandLineHelper.debugHttpRequest("DecodingError \(decodingError)")
                        return .failure(WKApiSimpleError(decodingError: decodingError))
                    } catch {
                        return .failure(WKApiSimpleError(code: .unknown)) // should never happens
                    }
                    
                } else {
                    CommandLineHelper.debugHttpRequest("Missing expected body of type \(T.self)")
                    return .failure(WKApiSimpleError(code: .missingBody))
                }
            }
        }
        
        return response(responseSerializer: responseSerializer) { dataResponse in
            switch dataResponse.result {
            case let .success(o):
                completion(.success(o))
                
            case let .failure(e):
                completion(.failure(e as! WKApiSimpleError))
            }
        }
    }
    
    /// Perform the `DataRequest`
    ///
    /// - Parameters:
    ///   - decoder: The `JSONDecoder` used to deserialize data. Default is a simple instance.
    ///   - completion: Closure that
    /// - Returns: The `DataRequest` itself.
    @discardableResult public func responseJSONToObject(decoder: JSONDecoder = JSONDecoder(), completion: @escaping (WKSimpleResult) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Any> { request, response, data, error in
            printRequest(request: request, response: response, data: data, error: error)
            
            // If error and no response, the connection failed before communicating with the server
            guard error == nil, let response = response else {
                if let urlError = error as? URLError {
                    return .failure(WKApiSimpleError(urlError: urlError))
                }
                else {
                    return .failure(WKApiSimpleError(code: .unknown))
                }
            }
            
            // Otherwise the communication worked. Now let's check the server response.
            guard let code = WKStatusCode(rawValue: response.statusCode), code.kind != .unknown else {
                WKLog.error("Found unexpected error code \(response.statusCode). Please open issue in WinkKit repo and add that code to enum.")
                return .failure(WKApiSimpleError(code: .unknown))
            }
            
            if code.isError {
                return .failure(WKApiSimpleError(code: code))
            } else {
                return .success(())
            }
        }
        
        return response(responseSerializer: responseSerializer) { dataResponse in
            switch dataResponse.result {
            case .success:
                completion(.success)
                
            case let .failure(e):
                completion(.failure(e as! WKApiSimpleError))
            }
        }
    }

}

private func printRequest(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) {
    let dataString = "Body: " + (data != nil && data!.count > 0 ? String(data: data!, encoding: .utf8) ?? "empty" : "empty")
    CommandLineHelper.debugHttpRequest(request ?? "No request", response ?? "No response", dataString, error ?? "No error")
}
