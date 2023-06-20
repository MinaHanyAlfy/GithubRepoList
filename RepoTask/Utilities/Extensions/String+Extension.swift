//
//  String+Extension.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-20.
//

import Foundation

extension String {
    /// Computed Property To Change String Date To Date
    var getDateValue: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "en_DZ") as Locale
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            return dateFormatter.date(from: self)
    }
}
