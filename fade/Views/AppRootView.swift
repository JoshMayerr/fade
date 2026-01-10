//
//  AppRootView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct AppRootView: View {
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView()
            } else {
                RootView()
            }
        }
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                showSplash = false
            }
        }
    }
}

#Preview {
    AppRootView()
}
