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
    @State private var pendingAddApp: BlockableApp?
    @State private var isConfirmingAdd = false

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
                            set: { isSelected in
                                if isSelected {
                                    pendingAddApp = app
                                    isConfirmingAdd = true
                                }
                            }
                        )) {
                            Text(app.name)
                        }
                        .disabled(blockedAppStore.isSelected(app.bundleId))
                    }
                } header: {
                    Text("Blocked Apps")
                } footer: {
                    Text("You can only add more apps here.")
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
        .alert("Add to blocked apps?", isPresented: $isConfirmingAdd, presenting: pendingAddApp) { app in
            Button("Add") {
                blockedAppStore.setSelected(app.bundleId, isSelected: true)
                pendingAddApp = nil
            }
            Button("Cancel", role: .cancel) {
                pendingAddApp = nil
            }
        } message: { app in
            Text("\(app.name) will be blocked from now on. You can't remove it later.")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
