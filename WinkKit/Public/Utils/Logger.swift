//
//  Logger.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 29/10/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

/// Contains methods to log messages.
public final class WKLog {
    
    private enum Level {
        case info
        case warning
        case error
        case debug
        case custom(String)
        
        var prefix: String {
            switch self {
            case .info:
                return "ℹ️"
            case .warning:
                return "⚠️"
            case .error:
                return "❌"
            case .debug:
                return "☣️"
            case .custom(let p):
                return p
            }
        }
        
    }
    
    /// Print message with "I" prefixed. This method logs messages even for Release apps.
    ///
    /// - Parameters:
    ///   - tag: A tag to identify the log
    ///   - items: Variadic paramenter that will be print.
    @available(*, deprecated, message: "please use info(_:) instead.")
    public static func info(tag: Any, items: Any...) {
        print("I: \(tag)" , items)
    }
    
    /// Print message with "W" prefixed. This method logs messages only for Debug apps.
    ///
    /// - Parameters:
    ///   - tag: A tag to identify the log
    ///   - items: Variadic paramenter that will be print.
    @available(*, deprecated, message: "please use warning(_:) instead.")
    public static func warning(tag: Any, items: Any...) {
        #if DEBUG
        print("W: \(tag)", items)
        #endif
    }
    
    /// Print message with "E" prefixed. This method logs messages only for Debug apps.
    ///
    /// - Parameters:
    ///   - tag: A tag to identify the log
    ///   - items: Variadic paramenter that will be print.
    @available(*, deprecated, message: "please use error(_:) instead.")
    public static func error(tag: Any, items: Any...) {
        #if DEBUG
        print("E: \(tag)", items)
        #endif
    }
        
    /// Print message with "D" prefixed. This method logs messages only for Debug apps.
    ///
    /// - Parameters:
    ///   - tag: A tag to identify the log
    ///   - items: Variadic paramenter that will be print.
    @available(*, deprecated, message: "please use debug(_:) instead.")
    public static func debug(tag: Any, items: Any...) {
        #if DEBUG
        print("D: \(tag)", items)
        #endif
    }
    
    /// Print message with "I" prefixed.
    /// Do not provide file and line to have the default ones.
    ///
    /// - Parameters:
    ///   - file: The file where this method is called
    ///   - line: The line where this method is called
    ///   - column: The column where this method is called
    ///   - items: Variadic paramenter that will be print.
    public static func info(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any..., separator: String = " ") {
        WKLog.log(level: .info, file: file, line: line, column: column, items, separator: separator)
    }
    
    /// Print message with "D" prefixed. This method logs messages only for Debug apps.
    /// Do not provide file and line to have the default ones.
    ///
    /// - Parameters:
    ///   - file: The file where this method is called
    ///   - line: The line where this method is called
    ///   - column: The column where this method is called
    ///   - items: Variadic paramenter that will be print.
    public static func debug(file: String? = #file, line: Int? = #line, column: Int? = #column, _ items: Any..., separator: String = " ") {
        #if DEBUG
        WKLog.log(level: .debug, file: file, line: line, column: column, items, separator: separator)
        #endif
    }
    
    /// Print message with "W" prefixed. This method logs messages only for Debug apps.
    /// Do not provide file and line to have the default ones.
    ///
    /// - Parameters:
    ///   - file: The file where this method is called
    ///   - line: The line where this method is called
    ///   - column: The column where this method is called
    ///   - items: Variadic paramenter that will be print.
    public static func warning(file: String? = #file, line: Int? = #line, column: Int? = #column, _ items: Any..., separator: String = " ") {
        #if DEBUG
        WKLog.log(level: .warning, file: file, line: line, column: column, items, separator: separator)
        #endif
    }
    
    /// Print message with "E" prefixed. This method logs messages only for Debug apps.
    /// Do not provide file and line to have the default ones.
    ///
    /// - Parameters:
    ///   - file: The file where this method is called
    ///   - line: The line where this method is called
    ///   - column: The column where this method is called
    ///   - items: Variadic paramenter that will be print.
    public static func error(file: String? = #file, line: Int? = #line, column: Int? = #column, _ items: Any..., separator: String = " ") {
        #if DEBUG
        WKLog.log(level: .error, file: file, line: line, column: column, items, separator: separator)
        #endif
    }
    
    /// Print message with the given prefixe string. This method logs messages only for Debug apps.
    /// Do not provide file and line to have the default ones.
    ///
    /// - Parameters:
    ///   - prefix: The prefix that will be applied.
    ///   - file: The file where this method is called
    ///   - line: The line where this method is called
    ///   - column: The column where this method is called
    ///   - items: Variadic paramenter that will be print.
    public static func custom(prefix: String, file: String? = #file, line: Int? = #line, column: Int? = #column, _ items: Any..., separator: String = " ") {
        #if DEBUG
        WKLog.log(level: .custom(prefix), file: file, line: line, column: column, items, separator: separator)
        #endif
    }
    
    private static func log(level: Level, file: String?, line: Int?, column: Int?, _ items: Any, separator: String = " ") {
        var file = file?.components(separatedBy: "/").last ?? ""
        if file.count > 0 {
            file = " " + file
        }
        var at = " at"
        if let line = line {
            at.append(" \(line)")
        }
        if let column = column {
            at.append(":\(column)")
        }
        
        if at == " at" {
            at = ""
        }
        
        print("\(level.prefix)\(file)\(at) \(parseArray(items, separator: separator))", terminator: "\n\n")
    }

    // This function iterate recursively every inner array to extract the single item as a String
    private static func parseArray(_ items: Any..., separator: String) -> String {
        func recursiveParse(_ items: [Any]) -> String {
            if let first = items.first as? [Any], items.count == 1 {
                return recursiveParse(first)
            }
            
            return items.compactMap { String(describing: $0) }.joined(separator: separator)
        }
        
        return recursiveParse(items)
    }
    
}

