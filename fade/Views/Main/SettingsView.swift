//
//  SettingsView.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var blockedAppStore = BlockedAppStore.shared
    @StateObject private var manager = ScreenTimeManager.shared
    @AppStorage("isBlocking") private var isBlocking = false

    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0"
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section {
                    ForEach(BlockedAppCatalog.catalog) { app in
                        Toggle(isOn: Binding(
                            get: { blockedAppStore.isSelected(app.bundleId) },
                            set: { blockedAppStore.setSelected(app.bundleId, isSelected: $0) }
                        )) {
                            Text(app.name)
                        }
                        .disabled(!blockedAppStore.canDeselect(app.bundleId))
                    }
                } header: {
                    Text("Blocked Apps")
                } footer: {
                    Text("Pick at least one app to block.")
                        .foregroundColor(.textMuted)
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
        .onChange(of: blockedAppStore.selection) { _ in
            if isBlocking {
                manager.blockApps()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
