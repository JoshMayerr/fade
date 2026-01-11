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
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 40)

            // Header: "welcome to" + logo
            HStack(spacing: 8) {
                Text("welcome to")
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBrand)

                Image("FadeLogo")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.accentBrand)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
            }

            Spacer()
                .frame(height: 30)

            // Description text (custom text to be provided)
            VStack(spacing: 14) {
                Text("social media is not the problem, short-form content is.")
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBrand)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Text("""
                it seems kinda like cigarettes back in the day. people know it's bad, but it's fun! and it's already so woven into society that it's hard to avoid.
                """)
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBrand)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Text("""
                this app is meant to be an way just to rip it out of your life and move on.
                """)
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBrand)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)


                Text("""
                it is exploiting your brain, see what happens when you fade it away.
                """)
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBrand)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

            }

            Spacer()
                .frame(height: 60)

            // Button with native iOS styling
            Button(action: onContinue) {
                Text("Get Started").font(.ibmPlexMono(size: 16, weight: .semibold))
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color.accentBrand)
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    WelcomeView(onContinue: {})
}
