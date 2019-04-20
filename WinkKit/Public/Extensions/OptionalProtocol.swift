//
//  OptionalProtocol.swift
//  Alamofire
//
//  Created by Rico Crescenzio on 07/04/2019.
//

import Foundation

/// A protocol that `Optional` conforms to, used to get the its `Wrapped` type.
public protocol OptionalProtocol {
    
    /// Returns the first wrapped type.
    ///
    ///    ```
    ///    Int??.wrappedType // returns Int? a.k.a. Optional<Int>
    ///
    ///    // Declare an optional that wraps an optional `Int`
    ///    let a: Int?? = 0
    ///    type(of: a).wrappedType // returns Int? a.k.a. Optional<Int>
    ///    ```
    ///
    static var wrappedType: Any.Type { get }
    
    /// Returns the deepest wrapped type for nested optionals.
    ///
    ///    ```
    ///    Int??.deepestWrappedType // returns Int
    ///
    ///    // Declare an optional that wraps another optional with `Int` wrapped type
    ///    let a: Int?? = 0
    ///    type(of: a).deepestWrappedType // returns Int
    ///    ```
    ///
    static var deepestWrappedType: Any.Type { get }

}

extension Optional: OptionalProtocol {
    
    public static var wrappedType: Any.Type {
        return Wrapped.self
    }

    public static var deepestWrappedType: Any.Type {
        if let innerWrapped = Wrapped.self as? OptionalProtocol.Type {
            return innerWrapped.wrappedType
        }
        return Wrapped.self
    }
    
}
