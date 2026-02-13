//
//  fadeApp.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI
import UIKit

@main
struct fadeApp: App {
    init() {
        UIView.appearance().overrideUserInterfaceStyle = .light
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .preferredColorScheme(.light)
                .tint(.accentBrand)
        }
    }
}
