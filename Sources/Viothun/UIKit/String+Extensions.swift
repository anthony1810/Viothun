//
//  String+Extensions.swift
//
//
//  Created by Anthony on 7/9/24.
//

import Foundation

// MARK: - Date
public extension String {
    
    /// Converts the string to a `Date` using the default format `"MMMM d, yyyy, h:mm a"`.
    ///
    /// - Returns: The `Date` object, or `nil` if conversion fails.
    var toDate: Date? {
        toDate(from: "MMMM d, yyyy, h:mm a")
    }
    
    /// Converts the string to a `Date` using a custom date format.
    ///
    /// - Parameter format: The date format to be used for conversion.
    /// - Returns: The `Date` object, or `nil` if conversion fails.
    func toDate(from format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // Custom format matching "November 14, 2021, 1:30 PM"
        dateFormatter.locale = Locale.current // Use current locale for proper formatting
        
        return dateFormatter.date(from: self)
    }
    
    /// Converts the string into a date string using the specified format.
    ///
    /// - Parameter format: The format to use for the conversion. Defaults to `"EEE, MMM d"`.
    /// - Returns: A formatted date string, or an empty string if the conversion fails.
    func toDateOnly(format: String = "EEE, MMM d") -> String {
        guard let date = toDate(from: format) else { return "" }
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = format
        return convertDateFormatter.string(from: date)
    }
    
    /// Converts the string into a time string using the specified format.
    ///
    /// - Parameter format: The format to use for the conversion. Defaults to `"EEE, MMM d"`.
    /// - Returns: A time string in "HH:mm:ss" format, or an empty string if the conversion fails.
    func toTimeOnly(format: String = "EEE, MMM d") -> String {
        guard let date = toDate(from: format) else { return "" }
        
        var calendar = Calendar.current
        calendar.timeZone = .current

        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return "\(hour):\(minutes):\(seconds)"
    }
}

// MARK: - Convenient Getters
public extension String {
    
    /// Generates a new UUID string.
    ///
    /// - Returns: A `String` representation of a UUID.
    static var uuid: String {
        UUID().uuidString
    }

    /// A Boolean value that indicates whether the string is blank or empty.
    ///
    /// - Returns: `true` if the string contains only whitespace or is empty, otherwise `false`.
    var isBlankOrEmpty: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Filters out characters from the string based on the provided character set.
    ///
    /// - Parameter characterSet: The set of characters to filter out.
    /// - Returns: A new string with the filtered characters removed.
    func filtering(characterSet: CharacterSet) -> String {
        String(unicodeScalars.filter { !characterSet.contains($0) })
    }

    /// Returns an alternative string if the original string is blank or empty.
    ///
    /// - Parameter alternative: The alternative string to return if the original string is blank or empty.
    /// - Returns: The original string if not blank or empty, otherwise the alternative string.
    func ifBlankOrEmpty(_ alternative: String) -> String {
        isBlankOrEmpty ? alternative : self
    }
}

// MARK: - Conversions
public extension String {
    
    /// Converts the string to an `Int`.
    ///
    /// - Returns: An optional `Int` value, or `nil` if the conversion fails.
    func toInt() -> Int? {
        Int(filter("0123456789.".contains))
    }

    /// Converts the string to an `Int` with a default fallback value of 0 if conversion fails.
    ///
    /// - Returns: The converted `Int` or `0` if the conversion fails.
    func toIntV2() -> Int {
        toInt() ?? 0
    }
}

// MARK: - Validation
public extension String {
    
    /// A Boolean value that indicates whether the string is a valid email address.
    ///
    /// - Returns: `true` if the string is a valid email address, otherwise `false`.
    var isValidEmailAddress: Bool {
        var returnValue = true
        let usernameRegEx = "([a-zA-Z0-9]+[_.\\-+])*[a-zA-Z0-9]+" // Characters with separators, ending with characters.
        let domainRegEx = "([a-zA-Z0-9]+[\\-\\+])*([a-zA-Z0-9]+[.])+[a-zA-Z0-9]{2,3}" // Characters with separators, ending with characters, a '.' and 2 or 3 character code.
        let emailRegEx = usernameRegEx + "@{1}" + domainRegEx
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            guard results.count == 1, let firstResult = results.first, firstResult.range.length == self.count else {
                return false
            }
            returnValue = true
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }

    /// A Boolean value that indicates whether the string is a valid phone number.
    ///
    /// - Returns: `true` if the string is a valid phone number (10 digits), otherwise `false`.
    func isValidPhone() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[0-9]).{10}$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        return valid
    }

    /// A Boolean value that indicates whether the string contains only numeric characters.
    ///
    /// - Returns: `true` if the string contains only numeric characters, otherwise `false`.
    func isValidNumber() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9]*$", options: .caseInsensitive)
        let valid = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        return valid
    }
}
