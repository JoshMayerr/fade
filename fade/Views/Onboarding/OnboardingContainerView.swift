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
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.appBackground.ignoresSafeArea())
        .overlay(alignment: .bottom) {
            // Page indicator for WelcomeView and PermissionView
            CustomPageIndicator(numberOfPages: 2, currentPage: currentStep)
                .padding(.bottom, 20)
        }
    }
}


#Preview {
    OnboardingContainerView()
}
