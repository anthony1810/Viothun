//
//  Date+Extensions.swift
//
//
//  Created by Anthony on 7/9/24.
//

import Foundation

public extension Date {
    
    /// Adds 100 years to the current date.
    ///
    /// - Returns: A new `Date` that is 100 years after the current date.
    func adding100Years() -> Date {
        addMoreTime(component: .year, value: 100)
    }
    
    /// Adds a specified time component and value to the current date.
    ///
    /// - Parameters:
    ///   - component: The `Calendar.Component` to add (e.g., `.year`, `.month`).
    ///   - value: The number of units to add to the specified component.
    /// - Returns: A new `Date` with the added time component, or the current date if the calculation fails.
    func addMoreTime(component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: component, value: value, to: self) ?? Date()
    }
    
    /// Adds a specified time component and value, then resets smaller components based on the component added.
    ///
    /// For example, adding years will reset the month, day, hour, minute, and second to default values.
    ///
    /// - Parameters:
    ///   - component: The `Calendar.Component` to add.
    ///   - value: The number of units to add to the specified component.
    /// - Returns: A new `Date` with the added and reset components, or the current date if the calculation fails.
    func addTimeAndReset(component: Calendar.Component, value: Int) -> Date {
        let calendar = Calendar.current
        
        guard let newDate = calendar.date(byAdding: component, value: value, to: self) else {
            return Date()
        }
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
        
        switch component {
        case .year:
            components.month = 1
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .month:
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .day:
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .hour:
            components.minute = 0
            components.second = 0
        case .minute:
            components.second = 0
        default:
            break
        }
        
        return calendar.date(from: components) ?? Date()
    }
    
    /// Formats the date to a string using the default format `"MMMM d, yyyy, h:mm a"`.
    ///
    /// - Returns: A formatted date string.
    var formattedString: String {
        formatted(with: "MMMM d, yyyy, h:mm a")
    }
    
    /// Formats the date to a string using the specified format.
    ///
    /// - Parameter format: The format string for the `DateFormatter`.
    /// - Returns: A formatted date string.
    func formatted(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: self)
    }
    
    /// Adjusts a base date by adding or subtracting time based on a string input.
    ///
    /// The input string should be in the format `x y z` (e.g., "2 hours after" or "3 minutes before").
    ///
    /// - Parameters:
    ///   - addedDateTimeString: A string representing the amount of time and direction to adjust (e.g., "2 hours after").
    ///   - baseDate: The base date to adjust.
    /// - Returns: A new `Date` with the adjusted time, or the base date if the input string is invalid.
    static func adjustDateTime(from addedDateTimeString: String, baseDate: Date) -> Date {
        let components = addedDateTimeString.components(separatedBy: " ")
        
        guard components.count == 3,
              let value = Int(components[0]),
              let timeUnit = components[safe: 1]?.lowercased(),
              let direction = components[safe: 2]?.lowercased() else {
            return baseDate
        }

        var calendarComponent: Calendar.Component?
        switch timeUnit {
        case "second", "seconds":
            calendarComponent = .second
        case "minute", "minutes", "min", "mins":
            calendarComponent = .minute
        case "hour", "hours":
            calendarComponent = .hour
        default:
            break
        }

        guard let component = calendarComponent else {
            return baseDate
        }

        let adjustmentValue = (direction == "before" ? -value : value)
        return baseDate.addTimeAndReset(component: component, value: adjustmentValue)
    }
    
    /// Returns a string describing the time difference between two dates in the format "x y z" (e.g., "2 hours after").
    ///
    /// - Parameters:
    ///   - addedDate: The date to compare to the base date.
    ///   - baseDate: The base date for the comparison.
    /// - Returns: A string describing the time difference (e.g., "2 hours after").
    static func timeDifferenceString(from addedDate: Date, to baseDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: baseDate, to: addedDate)
        
        if let hours = components.hour, hours != 0 {
            let z = hours > 0 ? "after" : "before"
            let x = abs(hours)
            let y = x == 1 ? "hour" : "hours"
            return "\(x) \(y) \(z)"
        } else if let minutes = components.minute, minutes != 0 {
            let z = minutes > 0 ? "after" : "before"
            let x = abs(minutes)
            let y = x == 1 ? "min" : "mins"
            return "\(x) \(y) \(z)"
        } else if let seconds = components.second, seconds != 0 {
            let z = seconds > 0 ? "after" : "before"
            let x = abs(seconds)
            let y = x == 1 ? "second" : "seconds"
            return "\(x) \(y) \(z)"
        } else {
            return "0 seconds after"
        }
    }
}
