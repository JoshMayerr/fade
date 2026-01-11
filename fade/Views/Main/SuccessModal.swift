//
//  SuccessModal.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct SuccessModal: View {
    @ObservedObject var manager: ScreenTimeManager
    @Binding var isPresented: Bool

    @AppStorage("firstBlockDate") private var firstBlockDate: Double = 0
    @AppStorage("isBlocking") private var isBlocking = false

    var body: some View {
        ZStack {
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
                    Text("tiktok and instagram are gone. seriously go look. they have disappeared!")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.primaryBrand)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)

            // X button in top right
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primaryBrand)
                            .frame(width: 32, height: 32)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }
                Spacer()
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .presentationDetents([.height(250)])
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
    SuccessModal(
        manager: ScreenTimeManager.shared,
        isPresented: .constant(true)
    )
}
