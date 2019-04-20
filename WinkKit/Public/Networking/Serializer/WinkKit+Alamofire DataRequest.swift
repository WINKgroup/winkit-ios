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
    @discardableResult func responseJSONToObject<T: Decodable, E: Decodable>(decoder: JSONDecoder = JSONDecoder(), completion: @escaping (WKFullResult<T, E>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in

            // If error and no response, the connection failed before communicating with the server
            guard error == nil, let response = response else {
                printRequest(request: request, response: nil, data: data, error: error, otherInfo: nil)
                if let urlError = error as? URLError {
                    return .failure(WKApiBodyError<E>(urlError: urlError))
                }
                else {
                    return .failure(WKApiBodyError<E>.unknown)
                }
            }
            
            // Otherwise the communication worked. Now let's check the server response.
            guard let code = HTTPStatusCode(rawValue: response.statusCode), code.kind != .unknown else {
                WKLog.error("Found unexpected error code \(response.statusCode). Please open issue in WinkKit repo and add that code to enum.")
                return .failure(WKApiBodyError<E>.unknown)
            }
            
            if code.isError {
                if let data = data, data.count > 0 {
                    do {
                        let errorBody = try decoder.decode(E.self, from: data)
                        printRequest(request: request, response: response, data: data, error: error,
                                     otherInfo: "Decoded error body: \(String(describing: errorBody))")
                        return .failure(WKApiBodyError<E>(miscCode: .failure, httpCode: code, body: errorBody))
                    } catch let decodingError as DecodingError {
                        printRequest(request: request, response: response, data: data, error: error, otherInfo:
                            """
                            Could not decode error body: \(String(data: data, encoding: .utf8) ?? "data non convertible to string"),
                            DecodingError: \(decodingError)
                            response error: \(code)
                            """
                        )
                        return .failure(WKApiBodyError<E>(miscCode: .jsonDecodingError(detail: decodingError), httpCode: code))
                    } catch {
                        return .failure(WKApiBodyError<E>.unknown) // should never happens
                    }
                }
                printRequest(request: request, response: response, data: data, error: error, otherInfo: "No error body to decode")
                return .failure(WKApiBodyError<E>(miscCode: .failure, httpCode: code))
            } else {
                if let data = data, data.count > 0 {
                    do {
                        let obj = try decoder.decode(T.self, from: data)
                        
                        printRequest(request: request, response: response, data: data, error: error,
                                     otherInfo: "Decoded success body: \(String(describing: obj))")
                        
                        return .success(obj)
                    } catch let decodingError as DecodingError {
                        printRequest(request: request, response: response, data: data, error: error, otherInfo:
                            """
                            Could not decode response body: \(String(data: data, encoding: .utf8) ?? "data non convertible to string"),
                            DecodingError: \(decodingError)
                            response error: \(code)
                            """
                        )
                        return .failure(WKApiBodyError<E>(decodingError: decodingError, httpCode: code))
                    } catch {
                        return .failure(WKApiBodyError<E>.unknown) // should never happens
                    }
                    
                } else {
                    printRequest(request: request, response: response, data: data, error: error,
                                 otherInfo: "Missing expected body of type \(T.self)")
                    return .failure(WKApiBodyError<E>(miscCode: .missingBody, httpCode: code))
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
    @discardableResult func responseJSONToObject<T: Decodable>(decoder: JSONDecoder = JSONDecoder(), completion: @escaping (WKResult<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            
            // If error and no response, the connection failed before communicating with the server
            guard error == nil, let response = response else {
                printRequest(request: request, response: nil, data: data, error: error, otherInfo: nil)
                if let urlError = error as? URLError {
                    return .failure(WKApiSimpleError(urlError: urlError))
                }
                else {
                    return .failure(WKApiSimpleError.unknown)
                }
            }
            
            // Otherwise the communication worked. Now let's check the server response.
            guard let code = HTTPStatusCode(rawValue: response.statusCode), code.kind != .unknown else {
                WKLog.error("Found unexpected error code \(response.statusCode). Please open issue in WinkKit repo and add that code to enum.")
                return .failure(WKApiSimpleError.unknown)
            }
            
            if code.isError {
                printRequest(request: request, response: response, data: data, error: error, otherInfo: nil)
                return .failure(WKApiSimpleError(miscCode: .failure, httpCode: code))
            } else {
                if let data = data, data.count > 0 {
                    do {
                        let obj = try decoder.decode(T.self, from: data)
                        printRequest(request: request, response: response, data: data, error: error,
                                     otherInfo: "Decoded success body: \(String(describing: obj))")
                        return .success(obj)
                    } catch let decodingError as DecodingError {
                        printRequest(request: request, response: response, data: data, error: error, otherInfo:
                            """
                            Could not decode response body: \(String(data: data, encoding: .utf8) ?? "data non convertible to string"),
                            DecodingError: \(decodingError)
                            response error: \(code)
                            """
                        )
                        return .failure(WKApiSimpleError(decodingError: decodingError, httpCode: code))
                    } catch {
                        return .failure(WKApiSimpleError.unknown) // should never happens
                    }
                    
                } else {
                    printRequest(request: request, response: response, data: data, error: error,
                                 otherInfo: "Missing expected body of type \(T.self)")
                    return .failure(WKApiSimpleError(miscCode: .missingBody, httpCode: code))
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
    @discardableResult func responseJSONToObject(decoder: JSONDecoder = JSONDecoder(), completion: @escaping (WKSimpleResult) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Any> { request, response, data, error in
            
            // If error and no response, the connection failed before communicating with the server
            guard error == nil, let response = response else {
                printRequest(request: request, response: nil, data: data, error: error, otherInfo: nil)
                if let urlError = error as? URLError {
                    return .failure(WKApiSimpleError(urlError: urlError))
                }
                else {
                    return .failure(WKApiSimpleError.unknown)
                }
            }
            
            // Otherwise the communication worked. Now let's check the server response.
            guard let code = HTTPStatusCode(rawValue: response.statusCode), code.kind != .unknown else {
                WKLog.error("Found unexpected error code \(response.statusCode). Please open issue in WinkKit repo and add that code to enum.")
                return .failure(WKApiSimpleError.unknown)
            }
            
            printRequest(request: request, response: response, data: data, error: error, otherInfo: nil)
            
            if code.isError {
                return .failure(WKApiSimpleError(miscCode: .failure, httpCode: code))
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

private func printRequest(line: Int = #line, column: Int = #column,
                          request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?, otherInfo: String?) {
    let dataString = "Body: " + (data != nil && data!.count > 0 ? String(data: data!, encoding: .utf8) ?? "empty" : "empty")
    ProcessInfoUtils.debugHttpRequest(line: line, column: column, request ?? "No request", response ?? "No response", dataString, error ?? "No connection error", otherInfo ?? "")
    
}
