//
//  GMGDateFormatter.swift
//  GMGorders
//
//  Created by Mohammed Ajas on 6/1/23.
//

import Foundation
final class GMGDateFormatter {
    static func formatDateToShortDayMonthYearString(_ date: Date) -> String {
        return dateFormatterWith(format: Constants.Formatter.dateFormatter).string(from: date)
    }
    fileprivate static func dateFormatterWith(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
}
