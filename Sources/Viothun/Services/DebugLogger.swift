//
//  DebugLogger.swift
//  ProjectName
//
//  Created by AuthorName ( AuthorWebsite )
//  Copyright © 2024 OrganizationName. All rights reserved.
//
import Foundation
import os.log

public enum LogLevel: String {
    case debug, info, error, fault
}

/// A singleton logger class for debug printing, allowing enabling or disabling logs for specific contexts.
public class DebugLogger {
    
    static let shared: DebugLogger = DebugLogger(enabledContexts: [], showLocation: false)
    
    /// Set of enabled logging contexts
    private var enabledContexts: Set<Context> = []
    
    /// Global flag to enable or disable logging
    var isLoggingEnabled: Bool = true
    
    /// Global flag to show location information
    var showLocation: Bool
    
    /// Initializer to enable specific contexts and set location flag
    init(
        enabledContexts: [Context],
        showLocation: Bool = false
    ) {
        self.enabledContexts = Set(enabledContexts)
        self.showLocation = showLocation
    }
    
    /// Enable logging for a specific context
    /// - Parameter context: The context to enable logging for
    func enable(
        _ context: Context
    ) {
        enabledContexts.insert(context)
    }
    
    /// Disable logging for a specific context
    /// - Parameter context: The context to disable logging for
    func disable(
        _ context: Context
    ) {
        enabledContexts.remove(context)
    }
    
    /// Check if logging is enabled for a specific context
    /// - Parameter context: The context to check
    /// - Returns: Boolean indicating if logging is enabled for the given context
    func isEnabled(
        _ context: Context
    ) -> Bool {
        return enabledContexts.contains(context)
    }
    
    /// Log a message for a specific context using OSLog
    /// - Parameters:
    ///   - context: The context for the log message
    ///   - message: The log message
    ///   - newLine: Boolean indicating if a newline should be added after the message (default is true)
    ///   - level: The log level (default is debug)
    ///   - showLocationOverride: Optional flag to override the global `showLocation` flag
    ///   - file: The file name where the log is called
    ///   - line: The line number where the log is called
    ///   - function: The function name where the log is called
    func log(
        _ context: Context,
        _ message: String,
        newLine: Bool = true,
        level: LogLevel = .debug,
        showLocationOverride: Bool? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        guard isLoggingEnabled, isEnabled(context) else { return }
        
        let locationFlag = showLocationOverride ?? showLocation
        let logMessage = newLine ? "\(message)\n" : message
        let locationInfo = locationFlag ? "[\(sourceFileName(filePath: file)):\(line)] \(function) - " : ""
        let fullMessage = "\(locationInfo)\(logMessage)"
        
        let osLogType: OSLogType
        switch level {
        case .debug:
            osLogType = .debug
        case .info:
            osLogType = .info
        case .error:
            osLogType = .error
        case .fault:
            osLogType = .fault
        }
        
        os_log(
            "%{public}@",
            log: context.osLog,
            type: osLogType,
            fullMessage
        )
    }
    
    /// Log a title for a specific context using OSLog, with special formatting for start or end titles
    /// - Parameters:
    ///   - context: The context for the log title
    ///   - title: The title message
    ///   - newLine: Boolean indicating if a newline should be added after the title (default is true)
    ///   - isStart: Boolean indicating if the title is a start title (default is true). If false, it is treated as an end title.
    ///   - level: The log level (default is debug)
    ///   - showLocationOverride: Optional flag to override the global `showLocation` flag
    ///   - file: The file name where the log is called
    ///   - line: The line number where the log is called
    ///   - function: The function name where the log is called
    func logTitle(
        _ context: Context,
        _ title: String,
        newLine: Bool = true,
        isStart: Bool = true,
        level: LogLevel = .debug,
        showLocationOverride: Bool? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        guard isLoggingEnabled, isEnabled(context) else { return }
        
        let logTitleMessage = isStart ? "⭐️⭐️⭐️ \(title) ⭐️⭐️⭐️" : "🎉🎉🎉 \(title) 🎉🎉🎉"
        log(
            context,
            logTitleMessage,
            newLine: newLine,
            level: level,
            showLocationOverride: showLocationOverride,
            file: file,
            line: line,
            function: function
        )
    }
    
    /// Log a multi-line message for a specific context using OSLog
    /// - Parameters:
    ///   - context: The context for the log message
    ///   - message: The multi-line log message
    ///   - newLine: Boolean indicating if a newline should be added after each line (default is true)
    ///   - level: The log level (default is debug)
    ///   - showLocationOverride: Optional flag to override the global `showLocation` flag
    ///   - file: The file name where the log is called
    ///   - line: The line number where the log is called
    ///   - function: The function name where the log is called
    ///
    /// This method allows logging long messages by splitting them into multiple lines.
    func logMultiLine(
        _ context: Context,
        _ message: String,
        newLine: Bool = true,
        level: LogLevel = .debug,
        showLocationOverride: Bool? = nil,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        guard isLoggingEnabled, isEnabled(context) else { return }
        
        let lines = message.split(separator: "\n")
        for logLine in lines {
            log(
                context,
                String(logLine),
                newLine: newLine,
                level: level,
                showLocationOverride: showLocationOverride,
                file: file,
                line: line,
                function: function
            )
        }
    }
    
    /// Internal struct for defining log contexts
    public struct Context: Hashable, RawRepresentable {
        public let rawValue: String
        let osLog: OSLog
        
        init(
            _ rawValue: String
        ) {
            self.rawValue = rawValue
            self.osLog = OSLog(
                subsystem: Bundle.main.bundleIdentifier ?? "DebugLogger",
                category: rawValue
            )
        }
        
        public init(
            rawValue: String
        ) {
            self.rawValue = rawValue
            self.osLog = OSLog(
                subsystem: Bundle.main.bundleIdentifier ?? "DebugLogger",
                category: rawValue
            )
        }
    }
}

private func sourceFileName(
    filePath: String
) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.isEmpty ? "" : components.last!
}
