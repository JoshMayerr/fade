//
//  SettingsView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct SettingsView: View {
    private let blockedApps = [
        ("TikTok", "com.zhiliaoapp.musically"),
        ("Instagram", "com.burbn.instagram")
    ]

    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0"
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section("Blocked Apps") {
                    ForEach(blockedApps, id: \.1) { name, bundleId in
                        HStack {
                            Text(name)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.success)
                        }
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .listRowSeparatorTint(.borderHairline)
            .background(Color.appBackground.ignoresSafeArea())

            // Attribution text
            Text("by josh mayer")
                .font(.ibmPlexMono(size: 12))
                .foregroundColor(.textMuted)
                .padding(.bottom, 20)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
