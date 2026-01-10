//
//  ColorHelper.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

extension Color {
    /// Primary brand color - near black (#010101) in light mode, white in dark mode
    static var primaryBrand: Color {
        Color("Primary")
    }
    
    /// App background color - light gray (#E0DEE3) in light mode, dark gray in dark mode
    static var appBackground: Color {
        Color("Background")
    }
    
    /// Accent color - blue (#1C01CC) in light mode, lighter blue in dark mode
    static var accentBrand: Color {
        Color("Accent")
    }
}
