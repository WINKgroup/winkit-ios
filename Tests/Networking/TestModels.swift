//
//  TestModels.swift
//  Tests
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation
import Alamofire

// Here are all struct that match the https://httpbin.org/#/Response_formats json.

// It's just a way to pass empty struct to TestModel type parameter.
struct EmptyJson: Decodable {}

// MARK: Body
struct TestModel<T: Decodable>: Decodable {
    let args: [String: String]
    let headers: [String: String]
    let url: String
    let origin: String
    let json: T?
}

// MARK: Wrong Body to test failures
struct WrongModel: Decodable {
    let a: String
    let b: String?
    let c: Int
    let d: Bool
}

// MARK: Error
struct TestErrorModel: Decodable {
    
}


/*
 
 {
 "args": {},
 "headers": {
 "Accept": "application/json",
 "Accept-Encoding": "gzip, deflate, br",
 "Accept-Language": "en-US,en;q=0.9,it-IT;q=0.8,it;q=0.7,es;q=0.6",
 "Connection": "close",
 "Cookie": "_gauges_unique_day=1; _gauges_unique_month=1; _gauges_unique_year=1; _gauges_unique=1",
 "Host": "httpbin.org",
 "Referer": "https://httpbin.org/",
 "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.110 Safari/537.36"
 },
 "origin": "94.39.9.191",
 "url": "https://httpbin.org/get"
 }
 
 */
