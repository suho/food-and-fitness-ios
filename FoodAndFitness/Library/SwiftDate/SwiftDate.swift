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
    /// yyyy-MM-dd'T'HH:mm:ss.SSS'Z'
    case full
    /// yyyy-MM-dd
    case date
    /// yyyy/M/d
    case dateShort
    /// yyyy-MM-dd hh:mm:ss
    case dateTime
    /// M/d
    case monthDay
    /// EEE
    case weekday
    /// hh:mm:ss
    case time
    /// hh:mm
    case hourMinute
    /// yyyy.M.d H:mm
    case dateTime2

    var dateFormat: DateFormat {
        switch self {
        case .full:
            return .custom("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        case .date:
            return .custom("yyyy-MM-dd")
        case .dateShort:
            return .custom("yyyy/M/d")
        case .dateTime:
            return .custom("yyyy-MM-dd HH:mm:ss")
        case .dateTime2:
            return .custom("yyyy.M.d H:mm")
        case .monthDay:
            return .custom("M/d")
        case .weekday:
            return .custom("EEE")
        case .time:
            return .custom("HH:mm:ss")
        case .hourMinute:
            return .custom("HH:mm")
        }
    }
}

// MARK: - DateInRegion
extension DateInRegion {

    convenience init(timeIntervalSince1970: TimeInterval) {
        self.init(absoluteDate: Date(timeIntervalSince1970: timeIntervalSince1970))
    }

    func toString(format: FFDateFormat) -> String {
        return string(format: format.dateFormat)
    }

    func ffDate(format: FFDateFormat = .date) -> DateInRegion {
        let dateString = self.toString(format: format)
        do {
            return try DateInRegion(string: dateString, format: format.dateFormat)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - String to Date
extension String {
    func toDate(format: FFDateFormat) -> DateInRegion {
        do {
            return try DateInRegion(string: self, format: format.dateFormat)
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
