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
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 40)

            // Header
            Text("Screen Time Permission")
                .font(.ibmPlexMono(size: 14, weight: .semibold))
                .foregroundColor(.primaryBrand)

            Spacer()
                .frame(height: 30)

            // Description text
            VStack(spacing: 16) {
                Text("ready to remove tiktok and instagram from your life? we just need to ask for permission to block them.")
                    .font(.ibmPlexMono(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBrand)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
                .frame(height: 60)

            // Dialog indicator rectangle
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primaryBrand.opacity(0.3), lineWidth: 2)
                .frame(width: 280, height: 200)
                .overlay(
                    VStack(spacing: 16) {
                        Text("Dialog will appear here")
                            .font(.ibmPlexMono(size: 12, weight: .regular))
                            .foregroundColor(.primaryBrand.opacity(0.5))
                        Image(systemName: "arrow.down")
                            .foregroundColor(.primaryBrand.opacity(0.5))

                    }
                )
                .padding(.bottom, 20)

            Spacer()
                .frame(height: 20)

            if manager.isAuthorized {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Permission Granted")
                            .font(.ibmPlexMono(size: 16, weight: .semibold))
                            .foregroundColor(.green)
                    }

                    Button(action: onPermissionGranted) {
                        Text("Continue")
                            .font(.ibmPlexMono(size: 16, weight: .semibold))
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(Color.accentBrand)
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
                    if isRequesting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Grant Permission")
                            .font(.ibmPlexMono(size: 16, weight: .semibold))
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color.accentBrand)
                .padding(.horizontal, 40)
                .disabled(isRequesting)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
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
