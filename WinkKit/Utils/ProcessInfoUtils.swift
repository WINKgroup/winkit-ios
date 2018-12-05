//
//  CommandLineArguments.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 04/12/2018.
//  Copyright © 2018 Wink srl. All rights reserved.
//

import Foundation

struct ProcessInfoUtils {
    
    private static var debugHttpRequestsEnabled: Bool {
        return ProcessInfo.processInfo.arguments.contains("-WKDebugHttpRequests")
    }
    
    static func debugHttpRequest(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        if debugHttpRequestsEnabled {
            WKLog.debug(file: file, line: line, column: column, items, separator: "\n")
        }
    }
    
    static func errorHttpRequest(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        if debugHttpRequestsEnabled {
            WKLog.error(file: file, line: line, column: column, items, separator: "\n")
        }
    }
    
    static func warningHttpRequest(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        if debugHttpRequestsEnabled {
            WKLog.warning(file: file, line: line, column: column, items, separator: "\n")
        }
    }
    
    static func infoHttpRequest(file: String = #file, line: Int = #line, column: Int = #column, _ items: Any...) {
        if debugHttpRequestsEnabled {
            WKLog.info(file: file, line: line, column: column, items, separator: "\n")
        }
    }
    
}
