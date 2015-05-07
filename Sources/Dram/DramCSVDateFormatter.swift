// Copyright 2014-2015 Ben Hale. All Rights Reserved


import Foundation

final class DramCSVDateFormatter {
    static let defaultInstance: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter
        }()
}