//
//  Resource.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 06/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

import Foundation

public enum Resource<T, E: WKError> {
    case found(T)
    case notFound(E)
}
