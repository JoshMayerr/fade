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
        List {
            Section("Blocked Apps") {
                ForEach(blockedApps, id: \.1) { name, bundleId in
                    HStack {
                        Text(name)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
            
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
