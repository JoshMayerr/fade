//
//  WelcomeView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            VStack(spacing: 20) {
                Text("fade")
                    .font(.joshFont(size: 64))
                    .foregroundColor(.primaryBrand)

                Text("Break free from distraction")
                    .font(.ibmPlexMono(size: 22))
                    .foregroundColor(.primaryBrand.opacity(0.8))
                    .multilineTextAlignment(.center)

                Text("Take control of your screen time by blocking distracting apps and tracking your progress.")
                    .font(.ibmPlexMono(size: 16))
                    .foregroundColor(.primaryBrand.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()

            Button(action: onContinue) {
                Text("Get Started")
                    .font(.ibmPlexMono(size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentBrand)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
