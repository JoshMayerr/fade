//
//  FontHelper.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI
import UIKit
import CoreText

extension Font {
    /// Returns IBMPlexMono font with specified size
    /// - Parameter size: Font size in points
    /// - Returns: Custom IBMPlexMono font, or system font as fallback
    static func ibmPlexMono(size: CGFloat) -> Font {
        // Try to load the font by its PostScript name
        // Common PostScript names for IBM Plex Mono Medium
        let fontNames = [
            "IBMPlexMono-Medium",
            "IBM Plex Mono Medium",
            "IBMPlexMono"
        ]

        for fontName in fontNames {
            if let _ = UIFont(name: fontName, size: size) {
                return Font.custom(fontName, size: size)
            }
        }

        // Fallback to system monospace font
        return Font.system(size: size, design: .monospaced)
    }

    /// Returns Joshthick font with specified size (for counter digits, headings)
    /// - Parameter size: Font size in points
    /// - Returns: Custom Joshthick font, or system font as fallback
    static func joshFont(size: CGFloat) -> Font {
        joshThick(size: size)
    }

    /// Joshthick-Regular.otf — used for counter digits and other display text
    static func joshThick(size: CGFloat) -> Font {
        let fontNames = [
            // PostScript names are case-sensitive; include both variants seen across tools.
            "Joshthick-Regular",
            "JoshthickRegular",
            "Joshthick",
            "Joshthick Regular"
        ]
        for fontName in fontNames {
            if let _ = UIFont(name: fontName, size: size) {
                return Font.custom(fontName, size: size)
            }
        }

        if let fontURL = Bundle.main.url(forResource: "Joshthick-Regular", withExtension: "otf") {
            var registrationError: Unmanaged<CFError>?
            let registered = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &registrationError)
            if registered {
                for fontName in fontNames {
                    if let _ = UIFont(name: fontName, size: size) {
                        return Font.custom(fontName, size: size)
                    }
                }
            }
        }

        return Font.system(size: size)
    }

    /// Returns IBMPlexMono font with specified size and weight
    /// - Parameters:
    ///   - size: Font size in points
    ///   - weight: Font weight
    /// - Returns: Custom IBMPlexMono font, or system font as fallback
    static func ibmPlexMono(size: CGFloat, weight: Font.Weight) -> Font {
        let fontNames = [
            "IBMPlexMono-Medium",
            "IBM Plex Mono Medium",
            "IBMPlexMono"
        ]

        for fontName in fontNames {
            if let _ = UIFont(name: fontName, size: size) {
                return Font.custom(fontName, size: size)
            }
        }

        // Fallback to system monospace font with weight
        return Font.system(size: size, weight: weight, design: .monospaced)
    }
}
