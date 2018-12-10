//
//  NetworkingTests.swift
//  Tests
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import XCTest
import Alamofire
@testable import WinkKit

class NetworkingTests: XCTestCase {

    let testService = WKService(baseUrl: URL(string: "https://httpbin.org")!)

    func testRequestCreation() {
        let endpoint = "get"
        let request = WKRequest(endpoint: endpoint, method: .post, encoding: JSONEncoding.default, params: nil, headers: nil)
        XCTAssertEqual(request.endpoint, endpoint)
        XCTAssertEqual(request.method, .post)
        XCTAssertNil(request.params)
        XCTAssertNotNil(request.headers) // headers must have default content
        XCTAssert(request.encoding is JSONEncoding)
        
        let dataRequest = testService.enqueue(request) // the enqueue will append endpoint to base url
        
        XCTAssertNotNil(dataRequest.request)
        XCTAssertEqual(dataRequest.request!.url, testService.baseUrl.appendingPathComponent(endpoint))
    }
    
    // MARK: Error tests
    
    private func makeRequestForErrorTest(callerMethod: String = #function, request: WKRequest, assertClosure: @escaping (WKApiError) -> Void) {
        let exp = expectation(description: callerMethod)
        testService.enqueue(request).responseJSONToObject { (result: WKSimpleResult) in
            switch result {
            case .success:
                XCTFail("Could not be success")
            case .failure(let e):
                assertClosure(e)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
    
    func testNotFound() {
        let request = WKRequest(endpoint: "notFound")
        makeRequestForErrorTest(request: request) { (e) in
            XCTAssertEqual(e.httpCode, .notFound)
        }
    }

    func testBadRequest() {
        let request = WKRequest(endpoint: "status/400", method: .post)
        makeRequestForErrorTest(request: request) { e in
            XCTAssertEqual(e.httpCode, .badRequest)
        }
    }
    
    func testUnauthorized() {
        let request = WKRequest(endpoint: "status/401", method: .post)
        makeRequestForErrorTest(request: request) { e in
            XCTAssertEqual(e.httpCode, .unauthorized)
        }
    }
    
    func testForbidden() {
        let request = WKRequest(endpoint: "status/403", method: .post)
        makeRequestForErrorTest(request: request) { e in
            XCTAssertEqual(e.httpCode, .forbidden)
        }
    }
    
    func testMethodNotAllowed() {
        let request = WKRequest(endpoint: "status/405", method: .post)
        makeRequestForErrorTest(request: request) { e in
            XCTAssertEqual(e.httpCode, .methodNotAllowed)
        }
    }
    
    func testUnprocessableEntity() {
        let request = WKRequest(endpoint: "status/422", method: .post)
        makeRequestForErrorTest(request: request) { e in
            XCTAssertEqual(e.httpCode, .unprocessableEntity)
        }
    }
    
    func testServerError() {
        let request = WKRequest(endpoint: "status/500", method: .post)
        makeRequestForErrorTest(request: request) { e in
            XCTAssertEqual(e.httpCode, .internalServerError)
        }
    }
    
    func testServiceUnavailable() {
        let request = WKRequest(endpoint: "status/503", method: .post)
        makeRequestForErrorTest(request: request) { e in
            XCTAssertEqual(e.httpCode, .serviceUnavailable)
        }
    }
    
    func testJsonBadSyntax() {
        let exp = expectation(description: #function)
        
        let request = WKRequest(endpoint: "html")
        testService.enqueue(request).responseJSONToObject { (result: WKResult<TestModel<EmptyJson>>) in
            switch result {
            case .success:
                XCTFail("Could not be success")
            case .failure(let e):
                switch e.miscCode {
                case .jsonDecodingError(let detail):
                    switch detail {
                    case .dataCorrupted:
                        break
                    default:
                        XCTFail("Wrong decoding error")
                    }
                    
                default:
                    XCTFail("Wrong error code")
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
    
    func testJsonWrongBody() {
        let exp = expectation(description: #function)
        
        let request = WKRequest(endpoint: "get")
        testService.enqueue(request).responseJSONToObject { (result: WKResult<WrongModel>) in
            switch result {
            case .success:
                XCTFail("Could not be success")
            case .failure(let e):
                switch e.miscCode {
                case .jsonDecodingError(let detail):
                    switch detail {
                    case .dataCorrupted:
                        XCTFail("Wrong decoding error")
                    default:
                        break
                    }
                    
                default:
                    XCTFail("Wrong error code")
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
    
    func testRequestTimeout() {
        var request = WKRequest(endpoint: "delay/2") // 3 seconds of delay
        request.timeoutInterval = 1
        makeRequestForErrorTest(request: request) { e in
            switch e.miscCode {
            case .connectionError(let detail):
                XCTAssertEqual(detail.code, URLError.Code.timedOut)
            default:
                XCTFail("Wrong error code")
            }
        }
    }
    
    // MARK: Success tests
    
    func testGetSimple() {
        let exp = expectation(description: "testGetSimple")
        
        let request = WKRequest(endpoint: "get")
        
        testService.enqueue(request).responseJSONToObject { (result: WKSimpleResult) in
            XCTAssertEqual(result, .success)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
    
    func testGet() {
        let exp = expectation(description: #function)
        let request = WKRequest(endpoint: "get")
        testService.enqueue(request).responseJSONToObject { (result: WKResult<TestModel<EmptyJson>>) in
            switch result {
            case .success:
                break
            case .failure(let e):
                XCTFail("Failed with code \(e)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }
    
    func testGetFull() {
        let exp = expectation(description: #function)
        let request = WKRequest(endpoint: "get")
        testService.enqueue(request).responseJSONToObject { (result: WKFullResult<TestModel<EmptyJson>, TestErrorModel>) in
            switch result {
            case .success:
                break
            case .failure(let e):
                XCTFail("Failed with code \(e)")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)
    }

}
