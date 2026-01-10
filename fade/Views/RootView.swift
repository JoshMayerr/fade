//
//  RootView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingContainerView()
            }
        }
    }
}

#Preview {
    RootView()
}
