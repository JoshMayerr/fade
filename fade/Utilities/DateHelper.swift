//
//  DateHelper.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import Foundation

struct TimeComponents {
    let years: Int
    let months: Int
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
    
    /// Calculates years, months, days, hours, minutes, and seconds elapsed since the given date
    /// - Parameters:
    ///   - date: The starting date
    ///   - referenceDate: Optional reference date (defaults to now)
    static func timeComponentsSince(date: Date, referenceDate: Date = Date()) -> TimeComponents {
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date,
            to: referenceDate
        )
        
        let years = max(0, components.year ?? 0)
        let months = max(0, components.month ?? 0)
        let days = max(0, components.day ?? 0)
        let hours = max(0, components.hour ?? 0)
        let minutes = max(0, components.minute ?? 0)
        let seconds = max(0, components.second ?? 0)
        
        return TimeComponents(
            years: years,
            months: months,
            days: days,
            hours: hours,
            minutes: minutes,
            seconds: seconds
        )
    }
}
