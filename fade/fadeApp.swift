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
    @StateObject private var profileManager = ProfileManager.shared

    init() {
        UIView.appearance().overrideUserInterfaceStyle = .light
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(profileManager)
                .preferredColorScheme(.light)
                .tint(.accentBrand)
                .task {
                    await profileManager.ensureProfile()
                }
                .onOpenURL { url in
                    Task {
                        await profileManager.handleDeepLink(url)
                    }
                }
        }
    }
}
