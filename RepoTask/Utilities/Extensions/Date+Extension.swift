//
//  Date+Extension.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-20.
//

import Foundation

extension Date {
    /// To Check The Creation Date Then Update The Date To String Format
    /// - Returns: Date Format Changed
    func formatDateSinceCreationDate() -> String {
        let sixMonthsTimeInterval: TimeInterval = 60 * 60 * 24 * 30 * 6
        let now = Date()
        let interval = now.timeIntervalSince(self)
        
        let formatter = DateFormatter()
        if interval > sixMonthsTimeInterval {
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            return formatter.string(from: self)
        } else {
            let years = Int(interval / (60 * 60 * 24 * 365))
            let months = Int(interval / (60 * 60 * 24 * 30))
            if years > 0 {
                return "\(years) year\(years == 1 ? "" : "s") ago"
            } else {
                return "\(months) month\(months == 1 ? "" : "s") ago"
            }
        }
    }
}
