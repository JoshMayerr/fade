//
//  OnboardingContainerView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentStep = 0
    @StateObject private var manager = ScreenTimeManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isAuthorized") private var isAuthorized = false
    
    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeView(onContinue: {
                withAnimation {
                    currentStep = 1
                }
            })
            .tag(0)
            
            PermissionView(
                manager: manager,
                onPermissionGranted: {
                    withAnimation {
                        currentStep = 2
                    }
                },
                onPermissionDenied: {
                    // Permission denied - PermissionView handles UI state
                }
            )
            .tag(1)
            
            SuccessView(
                manager: manager,
                onDone: {
                    hasCompletedOnboarding = true
                }
            )
            .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    OnboardingContainerView()
}
