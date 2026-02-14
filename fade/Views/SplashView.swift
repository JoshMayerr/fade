//
//  SplashView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("FadeHero")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, -56)
                .opacity(isAnimating ? 1 : 0)

            Spacer()
                .frame(height: 28)

            Text("how long can you go\nwithout doomscrolling?")
                .font(.ibmPlexMono(size: 14, weight: .bold))
                .foregroundColor(.primaryBrand)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(0)
                .accessibilityHidden(true)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: {}) {
                Text("Get Started")
                    .font(.ibmPlexMono(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color.accentBrand)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            .opacity(0)
            .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    SplashView()
}
