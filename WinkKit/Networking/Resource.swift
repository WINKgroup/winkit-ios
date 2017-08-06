//
//  Resource.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 06/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

/// This enum is used to map a server response; is tipically used as argument of a closure.
/// For example if an http call returns 200 and a json in the body is successfully decoded into object,
/// that object will be passed in case `found(T)`. Otherwise some `WKError` will be passed in case `notFound(E)`.
/// 
/// - Parameter T:
public enum Resource<Object, Error: WKError> {
    case found(Object)
    case notFound(Error)
}
