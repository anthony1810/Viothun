//
//  RandomAccessCollection+Extensions.swift
//
//
//  Created by Anthony on 7/9/24.
//

import Foundation

public extension RandomAccessCollection {
    
    /// Safely accesses the element at the specified index, if it exists.
    ///
    /// This subscript returns the element at the given index if the index is within bounds, or `nil` if the index is out of bounds.
    ///
    /// - Parameter index: The index of the element to access.
    /// - Returns: The element at the given index, or `nil` if the index is out of bounds.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
