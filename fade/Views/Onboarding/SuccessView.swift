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

            // check mark icon
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.accentBrand)
                .font(.system(size: 30))

            // Header
            Text("done!")
                .padding(.top, 10)
                .font(.ibmPlexMono(size: 14, weight: .semibold))
                .foregroundColor(.primaryBrand)

            Spacer()
                .frame(height: 30)

            // Description text
            VStack(spacing: 14) {
                Text("tiktok and instagram are gone. seriously go look. they have disappeared.")
                    .font(.ibmPlexMono(size: 16, weight: .semibold))
                    .foregroundColor(.primaryBrand)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
                .frame(height: 60)

            // Button with native iOS styling
            Button(action: onDone) {
                Text("Continue")
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
