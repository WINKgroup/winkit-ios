//
//  BaseService.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import WinkKit
import Alamofire

class BaseService: WKService {
    
    init() {
        super.init(baseUrl: Config.baseUrl)
    }

}
