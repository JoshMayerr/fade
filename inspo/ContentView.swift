//
//  ContentView.swift
//  antifog
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject private var manager = ScreenTimeManager.shared
    @AppStorage("isBlocking") private var isBlocking = false
    @AppStorage("isAuthorized") private var isAuthorized = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Block TikTok & Instagram")
                .font(.largeTitle)
                .bold()
            
            if !isAuthorized {
                VStack(spacing: 15) {
                    Text("Grant permission to block apps")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Button("Grant Permission") {
                        Task {
                            await manager.requestAuthorization()
                            // Save the authorization state
                            isAuthorized = manager.isAuthorized
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            } else {
                VStack(spacing: 20) {
                    Text("✓ Permission Granted")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Toggle("Block Apps", isOn: $isBlocking)
                        .toggleStyle(.switch)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onChange(of: isBlocking) { _, newValue in
                            if newValue {
                                manager.blockApps()
                            } else {
                                manager.unblockApps()
                            }
                        }
                    
                    if isBlocking {
                        Text("TikTok and Instagram are blocked")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // Re-apply blocks if they were on when app closed
            if isAuthorized && isBlocking {
                manager.blockApps()
            }
        }
    }
}
