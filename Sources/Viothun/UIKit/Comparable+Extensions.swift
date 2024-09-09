//
//  Comparable+Extensions.swift
//
//
//  Created by Anthony on 9/9/24.
//

import Foundation

public extension Comparable {
    
    /// Clamps the value to a specified closed range.
    ///
    /// This method returns the value if it falls within the specified range. If the value is less than the lower bound of the range, it returns the lower bound. If the value is greater than the upper bound, it returns the upper bound.
    ///
    /// - Parameter range: The closed range to clamp the value to.
    /// - Returns: The clamped value.
    func clamp(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
