//
//  FontHelper.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

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
    
    /// Returns Joshfont2 font with specified size
    /// - Parameter size: Font size in points
    /// - Returns: Custom Joshfont2 font, or system font as fallback
    static func joshFont(size: CGFloat) -> Font {
        // Try to load the font by its PostScript name
        let fontNames = [
            "Joshfont2-Regular",
            "Joshfont2",
            "Joshfont2 Regular"
        ]
        
        for fontName in fontNames {
            if let _ = UIFont(name: fontName, size: size) {
                return Font.custom(fontName, size: size)
            }
        }
        
        // Fallback to system font
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
