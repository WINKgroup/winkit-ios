//
//  TestModels.swift
//  Tests
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

struct TestModel: Decodable {
    let a: Int
}

struct TestErrorBody: Decodable {
    let a: Int
}
