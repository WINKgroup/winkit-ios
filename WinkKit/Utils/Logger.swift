//
//  Logger.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 29/10/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

/// Contains methods to log messages.
public final class WKLog {
    
    private enum Level: String {
        case info = "I"
        case warning = "W"
        case error = "E"
        case debug = "D"
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
    public static func info(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        WKLog.log(level: .info, file: file, line: line, column: column, items)
    }
    
    /// Print message with "D" prefixed. This method logs messages only for Debug apps.
    /// Do not provide file and line to have the default ones.
    ///
    /// - Parameters:
    ///   - file: The file where this method is called
    ///   - line: The line where this method is called
    ///   - column: The column where this method is called
    ///   - items: Variadic paramenter that will be print.
    public static func debug(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        #if DEBUG
        WKLog.log(level: .debug, file: file, line: line, column: column, items)
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
    public static func warning(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        #if DEBUG
        WKLog.log(level: .warning, file: file, line: line, column: column, items)
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
    public static func error(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        #if DEBUG
        WKLog.log(level: .error, file: file, line: line, column: column, items)
        #endif
    }
    
    private static func log(level: Level, file: String, line: Int, column: Int, _ items: Any) {
        let file = file.components(separatedBy: "/").last ?? ""
        //debugPrint("\(level.rawValue) >> \(file) at \(line):\(column) \(parseArray(items))")
        print("\(level.rawValue) >> \(file) at \(line):\(column) \(parseArray(items))")
    }

    // This function iterate recursively every inner array to extract the single item as a String
    private static func parseArray(_ items: Any...) -> String {
        func recursiveParse(_ items: [Any]) -> String {
            if let first = items.first as? [Any], items.count == 1 {
                return recursiveParse(first)
            }
            
            return items.compactMap { String(describing: $0) }.joined(separator: "\n")
        }
        
        return recursiveParse(items)
    }
    
}

