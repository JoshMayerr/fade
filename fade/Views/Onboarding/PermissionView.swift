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
            Text("Quick\npermission\nplease")
                .font(.joshThick(size: 52))
                .foregroundColor(.primaryBrand)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            Spacer()
                .frame(height: 10)

            Text("To make this work, you need to approve the screen time dialog.")
                .font(.ibmPlexMono(size: 16, weight: .semibold))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

            Spacer()
                .frame(height: 100)

            VStack(spacing: 12) {
                Text("1. click approve")
                Text("2. click continue")
            }
            .font(.joshThick(size: 36))
            .foregroundColor(.textMuted)
            .multilineTextAlignment(.center)

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            if manager.isAuthorized {
                Button(action: onPermissionGranted) {
                    Text("Continue")
                        .font(.ibmPlexMono(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color.accentBrand)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
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
                            .progressViewStyle(CircularProgressViewStyle(tint: .onAccent))
                    } else {
                        Text("Approve")
                            .font(.ibmPlexMono(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color.accentBrand)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
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
