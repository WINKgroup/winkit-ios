//
//  Logger.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 29/10/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

public final class Log {
    
    public static func info(tag: Any, items: Any...) {
        print("INFO: \(tag)" , items);
    }
    
    public static func warning(tag: Any, items: Any...) {
        #if DEBUG
        print("WARNING: \(tag)", items);
        #endif
    }
    
    public static func error(tag: Any, items: Any...) {
        #if DEBUG
        print("ERROR: \(tag)", items);
        #endif
    }
    
    public static func debug(tag: Any, items: Any...) {
        #if DEBUG
        print("DEBUG: \(tag)", items);
        #endif
    }
}

