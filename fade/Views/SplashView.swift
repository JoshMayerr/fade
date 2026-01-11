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
        VStack {
            Spacer()

            Image("FadeLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.accentBrand)
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
                .opacity(isAnimating ? 1 : 0)

            Spacer()
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
