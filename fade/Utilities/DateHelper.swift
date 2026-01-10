//
//  DateHelper.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import Foundation

struct DateHelper {
    /// Calculates the number of days elapsed since the given date
    static func daysSince(date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        return components.day ?? 0
    }
    
    /// Formats a date for display (e.g., "January 10, 2025")
    static func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
