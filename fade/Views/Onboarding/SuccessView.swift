//
//  SuccessView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct SuccessView: View {
    @ObservedObject var manager: ScreenTimeManager
    let onDone: () -> Void

    @AppStorage("firstBlockDate") private var firstBlockDate: Double = 0
    @AppStorage("isBlocking") private var isBlocking = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 40)

            // Header
            Text("you're all set!")
                .font(.ibmPlexMono(size: 16, weight: .semibold))
                .foregroundColor(.primaryBrand)

            Spacer()
                .frame(height: 30)

            // Description text
            VStack(spacing: 16) {
                Text("it's time! leave short form content behind.")
                    .font(.ibmPlexMono(size: 16, weight: .semibold))
                    .foregroundColor(.primaryBrand)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
                .frame(height: 60)

            // Button with native iOS styling
            Button(action: onDone) {
                Text("Done")
                    .font(.ibmPlexMono(size: 16, weight: .semibold))
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color.accentBrand)
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear {
            // Auto-block apps and set first block date
            manager.blockApps()
            isBlocking = true

            // Set first block date if not already set
            if firstBlockDate == 0 {
                firstBlockDate = Date().timeIntervalSince1970
            }
        }
    }
}

#Preview {
    SuccessView(
        manager: ScreenTimeManager.shared,
        onDone: {}
    )
}
