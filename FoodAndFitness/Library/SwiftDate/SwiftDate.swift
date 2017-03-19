//
//  SwiftDate.swift
//  FoodAndFitness
//
//  Created by Mylo Ho on 8/25/16.
//  Copyright © 2016 SuHoVan. All rights reserved.
//

import SwiftDate
import SwiftUtils

enum FFDateFormat {
    case Full
    /// yyyy-MM-dd
    case Date
    /// yyyy/M/d
    case DateShort
    /// yyyy-MM-dd hh:mm:ss
    case DateTime
    /// M/d
    case MonthDay
    /// EEE
    case Weekday
    /// hh:mm:ss
    case Time
    /// hh:mm
    case HourMinute
    /// yyyy.M.d H:mm
    case DateTime2

    var dateFormat: DateFormat {
        switch self {
        case .Full:
            return .custom("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        case .Date:
            return .custom("yyyy-MM-dd")
        case .DateShort:
            return .custom("yyyy/M/d")
        case .DateTime:
            return .custom("yyyy-MM-dd HH:mm:ss")
        case .MonthDay:
            return .custom("M/d")
        case .Weekday:
            return .custom("EEE")
        case .Time:
            return .custom("HH:mm:ss")
        case .HourMinute:
            return .custom("HH:mm")
        case .DateTime2:
            return .custom("yyyy.M.d H:mm")
        }
    }
}

// MARK: - DateInRegion
extension DateInRegion {
    func toString(format: FFDateFormat) -> String! {
        return string(format: format.dateFormat)
    }
}

// MARK: - String to Date
extension String {
    func toDate(format: FFDateFormat, region: Region = App.region) -> DateInRegion {
        do {
            return try DateInRegion(string: self, format: format.dateFormat, fromRegion: region)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - NSDateFormatter
extension DateFormatter {
    func setRegion(region: Region) {
        calendar = region.calendar
        timeZone = region.timeZone
        locale = region.locale
    }
}

// MARK: - NSDateComponents
extension NSDateComponents {
    convenience init(time: String) {
        var comps = time.components(separatedBy: ":")
        if comps.count != 3 {
            fatal("Invalid Time `\(time)`, must be `hh:mm:ss`")
            comps = ["0", "0", "0"]
        }
        self.init()
        hour = comps[0].intValue
        minute = comps[1].intValue
        second = comps[2].intValue
    }
}

// MARK: NSDate
extension Date {
    static var null: Date {
        let date: Date! = DateComponents(year: 0, month: 0, day: 0).date
        return date
    }
}
