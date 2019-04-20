//
//  Globals.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 19/04/2019.
//  Copyright © 2019 Wink srl. All rights reserved.
//

import Foundation

/// Returns the type name of the argument using `String(describing:)` and removing generic types if any.
///
///     class MyClass {}
///     let defaultID = plainName(of: MyClass.self)
///     print(defaultID) // prints "MyClass"
///
/// - Important: For types with generic parameters, all generics are ignored in the name.
///
///       class MyTypedClass<T> {}
///       let defaultID = plainName(of: MyTypedClass<Int>)
///       print(defaultID) // prints "MyTypedClass" instead of "MyTypedClass<Int>"
///
public func plainName(of some: Any.Type) -> String {
    return String(String(describing: some).prefix(while: { $0 != "<" }))
}
