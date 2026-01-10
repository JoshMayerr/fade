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
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.green)
                
                Text("You're all set!")
                    .font(.title)
                    .bold()
                
                Text("TikTok and Instagram are now blocked. Your journey to better focus starts now.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            Button(action: onDone) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
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
