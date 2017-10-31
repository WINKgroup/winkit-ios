//
//  Queue.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 01/09/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

/// A queue is a list where you can only insert new items at the back and remove items from the front.
/// This ensures that the first item you enqueue is also the first item you dequeue. First come, first serve!
/// In many algorithms you want to add objects to a temporary list and pull them off this list later. Often the order in which you add and remove these objects matters.
/// A queue gives you a FIFO or first-in, first-out order. The element you inserted first is the first one to come out.
public struct Queue<E> {
    
    private var list = [E]()
    
    /// A Boolean value indicating whether the collection is empty.
    ///
    /// When you need to check whether your collection is empty, use the
    /// `isEmpty` property instead of checking that the `count` property is
    /// equal to zero. For collections that don't conform to
    /// `RandomAccessCollection`, accessing the `count` property iterates
    /// through the elements of the collection.
    ///
    ///     let horseName = "Silver"
    ///     if horseName.isEmpty {
    ///         print("I've been through the desert on a horse with no name.")
    ///     } else {
    ///         print("Hi ho, \(horseName)!")
    ///     }
    ///     // Prints "Hi ho, Silver!")
    ///
    /// - Complexity: O(1)
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    /// The number of elements in the array.
    public var count: Int {
        return list.count
    }
    
    /// Add an element in tail of the queue. It calls `append(_:)` of array method.
    public mutating func enqueue(_ element: E) {
        list.append(element)
    }
    
    /// Dequeue the first element if exists, otherwise nil. It calls `first` of array computed property to
    /// fetch the element and then `removeFirst()` to remove it.
    /// A dequeue operation will remove the element from the queue automatically.
    public mutating func dequeue() -> E? {
        guard let element = list.first else { return nil }
        
       list.removeFirst()
        
        return element
    }
    
    /// Get the first element of the queue if exists, without removing it from queue.
    public func peek() -> E? {
        return list.first
    }
}
