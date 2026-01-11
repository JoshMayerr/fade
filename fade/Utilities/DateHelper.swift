//
//  DateHelper.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import Foundation

struct TimeComponents {
    let weeks: Int
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
}

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
    
    /// Calculates weeks, days, hours, minutes, and seconds elapsed since the given date
    /// - Parameters:
    ///   - date: The starting date
    ///   - referenceDate: Optional reference date (defaults to now)
    static func timeComponentsSince(date: Date, referenceDate: Date = Date()) -> TimeComponents {
        // Calculate total time difference in seconds for accurate breakdown
        let totalSeconds = Int(referenceDate.timeIntervalSince(date))
        
        guard totalSeconds >= 0 else {
            return TimeComponents(weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0)
        }
        
        let weeks = totalSeconds / (7 * 24 * 60 * 60)
        let remainingAfterWeeks = totalSeconds % (7 * 24 * 60 * 60)
        let days = remainingAfterWeeks / (24 * 60 * 60)
        let remainingAfterDays = remainingAfterWeeks % (24 * 60 * 60)
        let hours = remainingAfterDays / (60 * 60)
        let remainingAfterHours = remainingAfterDays % (60 * 60)
        let minutes = remainingAfterHours / 60
        let seconds = remainingAfterHours % 60
        
        return TimeComponents(weeks: weeks, days: days, hours: hours, minutes: minutes, seconds: seconds)
    }
}
