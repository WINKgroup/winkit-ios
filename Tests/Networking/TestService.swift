//
//  TestService.swift
//  Tests
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation
import Alamofire
@testable import WinkKit

typealias TestModelFullCallback = (WKFullResult<TestModel, TestErrorBody>) -> Void
typealias TestModelCallback = (WKResult<TestModel>) -> Void
typealias TestModelSimpleCallback = (WKSimpleResult) -> Void

class TestService: WKService {
    
    func getFull(completion: @escaping TestModelFullCallback) {
        let route = WKRequest(endpoint: "")
        enqueue(urlRequest: route).responseJSONToObject(completion: completion)
    }
    
    func get(completion: @escaping TestModelCallback) {
        let route = WKRequest(endpoint: "")
        enqueue(urlRequest: route).responseJSONToObject(completion: completion)
    }
    
    func getSimple(completion: @escaping TestModelSimpleCallback) {
        let route = WKRequest(endpoint: "")
        enqueue(urlRequest: route).responseJSONToObject(completion: completion)
    }
    
}
