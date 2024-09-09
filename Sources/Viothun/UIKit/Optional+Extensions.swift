public extension Optional {
    
    /// Returns the wrapped value if it exists, or a provided default value if it does not.
    ///
    /// - Parameter defaultValue: A closure that provides a default value if the `Optional` is `nil`.
    /// - Returns: The wrapped value if `self` is not `nil`, otherwise the result of the `defaultValue` closure.
    /// - Throws: Rethrows any error thrown by the `defaultValue` closure.
    func wrapped(or defaultValue: @autoclosure () throws -> Wrapped) rethrows -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return try defaultValue()
        }
    }
}

public extension Optional where Wrapped == String {
    
    /// Returns the wrapped string if it exists, or an empty string (`""`) if it does not.
    ///
    /// - Parameter defaultValue: A default string to use if the `Optional` is `nil`. Defaults to an empty string.
    /// - Returns: The wrapped string if `self` is not `nil`, otherwise the `defaultValue`.
    func orBlank(or defaultValue: String = "") -> String! {
        return wrapped(or: defaultValue)
    }

    /// Returns the wrapped string if it exists, or a default black hex color string (`"#000000"`) if it does not.
    ///
    /// - Parameter defaultValue: A default string to use if the `Optional` is `nil`. Defaults to `"#000000"`.
    /// - Returns: The wrapped string if `self` is not `nil`, otherwise the `defaultValue`.
    func orBlackHex(or defaultValue: String = "#000000") -> String! {
        return wrapped(or: defaultValue)
    }
}

public extension Optional where Wrapped == Int {
    
    /// Returns the wrapped integer if it exists, or `0` if it does not.
    ///
    /// - Parameter defaultValue: A default integer to use if the `Optional` is `nil`. Defaults to `0`.
    /// - Returns: The wrapped integer if `self` is not `nil`, otherwise the `defaultValue`.
    func orZero(or defaultValue: Int = 0) -> Int {
        return wrapped(or: defaultValue)
    }
}

public extension Optional where Wrapped == Bool {
    
    /// Returns the wrapped boolean if it exists, or `false` if it does not.
    ///
    /// - Parameter defaultValue: A default boolean to use if the `Optional` is `nil`. Defaults to `false`.
    /// - Returns: The wrapped boolean if `self` is not `nil`, otherwise the `defaultValue`.
    func orFalse(or defaultValue: Bool = false) -> Bool {
        return wrapped(or: defaultValue)
    }
}
