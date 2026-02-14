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

                // Header
                Text("Done")
                    .font(.joshThick(size: 56))
                    .foregroundColor(.primaryBrand)
                    .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
                    .padding(.horizontal, 40)

                Spacer()
                    .frame(height: 20)

                // Description text
                VStack(alignment: .leading, spacing: 14) {
                    Text("Your selected apps are gone. Seriously go look. They have disappeared!")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.primaryBrand)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 44)
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
                            .background(Color.surface)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                }
                Spacer()
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .presentationDetents([.height(200)])
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
