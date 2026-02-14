 //
//  WelcomeView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI


struct WelcomeView: View {
    let onContinue: () -> Void
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("FadeHero")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, -56)

            Spacer()
                .frame(height: 28)

            Text("how long can you go\nwithout doomscrolling?")
                .font(.ibmPlexMono(size: 14, weight: .bold))
                .foregroundColor(.primaryBrand)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(isAnimating ? 1 : 0)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            // Button with native iOS styling
            Button(action: onContinue) {
                Text("Get Started")
                    .font(.ibmPlexMono(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            //vertical space inside the button
            .controlSize(.large)
            .tint(Color.accentBrand)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            .opacity(isAnimating ? 1 : 0)
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
    WelcomeView(onContinue: {})
}
