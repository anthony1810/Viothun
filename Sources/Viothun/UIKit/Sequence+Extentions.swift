import Foundation

public extension Sequence where Element: Identifiable & Equatable {
    
    /// Updates the sequence with a new sequence of elements, keeping the order of the original sequence.
    ///
    /// This method updates elements in the original sequence with those from the new sequence. If an element in the new sequence
    /// matches an element from the original sequence (based on the `id`), the element in the original sequence is replaced by the one
    /// from the new sequence. Any new elements in the new sequence that do not exist in the original sequence are appended.
    ///
    /// - Parameter newSequence: The new sequence containing elements to update.
    /// - Returns: A new sequence with updated elements, keeping the order of the original sequence.
    func updating(with newSequence: [Element]) -> [Element] {
        if newSequence.isEmpty { return [] }
        
        // Create a dictionary from the new sequence for quick lookup
        let newDict = Dictionary(uniqueKeysWithValues: newSequence.map { ($0.id, $0) })

        // Create a set of new IDs for quick lookup
        let newIds = Set(newSequence.map { $0.id })

        // Update the old array while respecting the order
        var updatedArray: [Element] = compactMap { element in
            if let newElement = newDict[element.id] {
                return newElement
            } else if !newIds.contains(element.id) {
                return element
            } else {
                return nil
            }
        }

        // Add new elements that were not in the old array
        for newElement in newSequence {
            if !updatedArray.contains(where: { $0.id == newElement.id }) {
                updatedArray.append(newElement)
            }
        }

        return updatedArray
    }
}

// MARK: - SortDescriptor

/// A structure that defines how to compare two values of a given type.
public struct SortDescriptor<Value> {
    var comparator: (Value, Value) -> ComparisonResult
}

public extension SortDescriptor {
    
    /// Creates a sort descriptor using a key path for a comparable property.
    ///
    /// - Parameter keyPath: The key path to the property that will be used for sorting.
    /// - Returns: A `SortDescriptor` that compares elements based on the key path.
    static func keyPath<T: Comparable>(_ keyPath: KeyPath<Value, T>) -> Self {
        Self { rootA, rootB in
            let valueA = rootA[keyPath: keyPath]
            let valueB = rootB[keyPath: keyPath]

            guard valueA != valueB else {
                return .orderedSame
            }

            return valueA < valueB ? .orderedAscending : .orderedDescending
        }
    }
}

public enum SequenceSortOrder {
    case ascending
    case descending
}

public extension Sequence {
    
    /// Sorts the sequence using a list of sort descriptors.
    ///
    /// - Parameter descriptors: A variadic list of `SortDescriptor` objects.
    /// - Returns: The sorted sequence.
    func sorted(using descriptors: SortDescriptor<Element>...) -> [Element] {
        sorted(using: descriptors, order: .ascending)
    }
    
    /// Sorts the sequence by a specific key path.
    ///
    /// - Parameter keyPath: The key path to a property on which the sequence will be sorted.
    /// - Returns: The sorted sequence.
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
    
    /// Sorts the sequence using an array of sort descriptors and a specified order.
    ///
    /// - Parameters:
    ///   - descriptors: An array of `SortDescriptor` objects.
    ///   - order: The order in which the elements should be sorted (`ascending` or `descending`).
    /// - Returns: The sorted sequence.
    func sorted(using descriptors: [SortDescriptor<Element>], order: SequenceSortOrder) -> [Element] {
        sorted { valueA, valueB in
            for descriptor in descriptors {
                let result = descriptor.comparator(valueA, valueB)

                switch result {
                case .orderedSame:
                    break
                case .orderedAscending:
                    return order == .ascending
                case .orderedDescending:
                    return order == .descending
                }
            }

            return false
        }
    }
}

public extension Sequence where Element: Comparable {
    
    /// Sorts the sequence but ensures that a specific element always appears first.
    ///
    /// - Parameter alwaysFirst: The element that should always be placed at the start of the sorted sequence.
    /// - Returns: The sorted sequence with the specified element at the beginning.
    func sorted(alwaysFirst: Element) -> [Element] {
        sorted { e1, e2 in
            if e1 == alwaysFirst {
                return true
            } else if e2 == alwaysFirst {
                return false
            } else {
                return e1 < e2
            }
        }
    }
}

public extension Sequence where Element: Hashable {
    
    /// Removes duplicate elements from the sequence, keeping only the first occurrence of each element.
    ///
    /// - Returns: A new sequence with duplicate elements removed.
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
