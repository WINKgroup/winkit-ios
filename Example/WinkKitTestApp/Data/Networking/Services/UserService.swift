//
//  UserService.swift
//  CityNews
//
//  Created by Rico on 07/10/16.
//  Copyright © 2016 Wink. All rights reserved.
//

import WinkKit
import Alamofire

struct ApiError: Decodable {
    
}

typealias UserCallback = (WKResult<User>) -> Void

///Class that handle all APIs call related to User object
class UserService: BaseService {
    
    func login(email: String, password: String, completion: @escaping UserCallback) {
        let request = WKRequest(endpoint: "5c0e86b62e00004d00043f27?mocky-delay=2s", params: ["email": email, "password": password])
        enqueue(request).responseJSONToObject(completion: completion)
    }
    
    deinit {
        print("destrying \(self)")
    }
}
