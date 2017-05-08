//
//  Date.swift
//  WinkKit
//
//  Created by Rico Crescenzio on 08/05/17.
//  Copyright © 2017 Wink srl. All rights reserved.
//

public extension Date {
    
    /// Create a `Date` object with the given `value` and a `dateFormat`, both as `String`.
    /// Useful when a date string is fetched from an API.
    /// 
    /// - Parameters:
    ///     - value: The value that will be converted to `Date`, i.e.: `2017-03-28T09:54:08+02:00`
    ///     - dateFormat: The date format thatt will be used to parse the `value`, i.e: `yyyy-MM-dd'T'HH:mm:ssZ`
    init(value: String, dateFormat: String) {
        self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: value)
        if let date = date {
            self = date
        }
    }
    
    /// Return the start of month as `Date`.
    var wk_startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    /// Return the end of month as `Date`.
    var wk_endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.wk_startOfMonth)!
    }
    
    /// Return the 
    var wk_dayNumberOfWeek: Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    /// Return the week day name as `String` like: "Monday".
    var wk_dayOfWeek: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
        // or use capitalized(with: locale) if you want
    }
    
}
