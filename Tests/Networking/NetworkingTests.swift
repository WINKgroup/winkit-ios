//
//  NetworkingTests.swift
//  Tests
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import XCTest
@testable import WinkKit

class NetworkingTests: XCTestCase {

    let testService = TestService(baseUrl: URL(string: "https://httpbin.org")!)

    func testConnectionTimeout() {
        WKLog.debug([1], [2,  3], testService.baseUrl, "AHAHAHA", [["O", "A"], 5])
        print([1], [2, 3], testService.baseUrl, "AHAHAHA", [["O", "A"], 5])
    }

}
