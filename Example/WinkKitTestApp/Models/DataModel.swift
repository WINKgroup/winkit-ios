//
//  GenericModelData.swift
//  WinkKitTestApp
//
//  Created by Rico Crescenzio on 27/08/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation
import Argo

/// All model classes of Data layer must conform to this protocol.
protocol DataModel: class, Argo.Decodable, Equatable {
    var id: Int { get }
}

extension DataModel {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
