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
    @AppStorage("shouldShowSuccessModal") private var shouldShowSuccessModal = false
    
    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeView(onContinue: {
                withAnimation {
                    currentStep = 1
                }
            })
            .tag(0)

            AppSelectionView(onContinue: {
                withAnimation {
                    currentStep = 2
                }
            })
            .tag(1)

            PermissionView(
                manager: manager,
                onPermissionGranted: {
                    hasCompletedOnboarding = true
                    shouldShowSuccessModal = true
                },
                onPermissionDenied: {
                    // Permission denied - PermissionView handles UI state
                }
            )
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.appBackground.ignoresSafeArea())
    }
}


#Preview {
    OnboardingContainerView()
}
