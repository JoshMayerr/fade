//
//  PermissionView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct PermissionView: View {
    @ObservedObject var manager: ScreenTimeManager
    let onPermissionGranted: () -> Void
    let onPermissionDenied: () -> Void
    
    @State private var isRequesting = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.accentColor)
                
                Text("Screen Time Permission")
                    .font(.title)
                    .bold()
                
                Text("fade needs Screen Time permission to block distracting apps. This permission is required for the app to function.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            if manager.isAuthorized {
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Permission Granted")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    
                    Button(action: onPermissionGranted) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                }
            } else {
                Button(action: {
                    isRequesting = true
                    Task {
                        await manager.requestAuthorization()
                        isRequesting = false
                        if manager.isAuthorized {
                            onPermissionGranted()
                        } else {
                            onPermissionDenied()
                        }
                    }
                }) {
                    HStack {
                        if isRequesting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Grant Permission")
                                .font(.headline)
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .disabled(isRequesting)
            }
            
            Spacer()
                .frame(height: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Check authorization status on appear
            Task {
                await manager.updateAuthorizationStatus()
            }
        }
    }
}

#Preview {
    PermissionView(
        manager: ScreenTimeManager.shared,
        onPermissionGranted: {},
        onPermissionDenied: {}
    )
}
