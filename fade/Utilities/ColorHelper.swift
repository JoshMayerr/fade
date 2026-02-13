//
//  ColorHelper.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

enum AppPalette {
    static let primary = Color("Primary")
    static let background = Color("Background")
    static let accent = Color("Accent")

    static let textPrimary = primary
    static let textSecondary = primary.opacity(0.7)
    static let textSubtle = primary.opacity(0.6)
    static let textMuted = primary.opacity(0.5)

    static let surface = Color.white
    static let surfaceStrong = Color.white

    static let borderSubtle = primary.opacity(0.3)
    static let borderHairline = primary.opacity(0.2)

    static let success = Color(red: 0.16, green: 0.64, blue: 0.33)
    static let warning = Color(red: 0.96, green: 0.57, blue: 0.14)
    static let onAccent = Color.white
}

extension Color {
    /// Primary brand color (#010101)
    static var primaryBrand: Color { AppPalette.primary }

    /// App background color (#E0DEE3)
    static var appBackground: Color { AppPalette.background }

    /// Accent color (#1C01CC)
    static var accentBrand: Color { AppPalette.accent }

    static var textPrimary: Color { AppPalette.textPrimary }
    static var textSecondary: Color { AppPalette.textSecondary }
    static var textSubtle: Color { AppPalette.textSubtle }
    static var textMuted: Color { AppPalette.textMuted }
    static var surface: Color { AppPalette.surface }
    static var surfaceStrong: Color { AppPalette.surfaceStrong }
    static var borderSubtle: Color { AppPalette.borderSubtle }
    static var borderHairline: Color { AppPalette.borderHairline }
    static var success: Color { AppPalette.success }
    static var warning: Color { AppPalette.warning }
    static var onAccent: Color { AppPalette.onAccent }
}
