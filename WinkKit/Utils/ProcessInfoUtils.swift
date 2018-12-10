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
    
    private static var debugViewControllerDeinitEnabled: Bool {
        return ProcessInfo.processInfo.arguments.contains("-WKDebugViewControllerDeinit")
    }
    
    static func debugHttpRequest(line: Int = #line, column: Int = #column, _ items: Any...) {
        if debugHttpRequestsEnabled {
            WKLog.custom(prefix: "🌍", file: nil, line: line, column: column, items, separator: "\n")
        }
    }
    
    static func debugViewControllerDeinit(vc: UIViewController) {
        if debugViewControllerDeinitEnabled {
            WKLog.custom(prefix: "⚡️", file: nil, line: nil, column: nil, "Deinitialized", vc)
        }
    }
    
}
