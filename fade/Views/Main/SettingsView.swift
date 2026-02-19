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
    @EnvironmentObject private var profileManager: ProfileManager
    @AppStorage("isBlocking") private var isBlocking = false
    @State private var pendingAddApp: BlockableApp?
    @State private var isConfirmingAdd = false
    @State private var displayName = ProfileManager.shared.displayName
    @FocusState private var isNameFocused: Bool

    private func iconName(for app: BlockableApp) -> String? {
        switch app.bundleId {
        case "com.zhiliaoapp.musically":
            return "tiktok"
        case "com.burbn.instagram":
            return "ig"
        case "com.toyopagroup.picaboo":
            return "snap"
        case "com.google.ios.youtube":
            return "yt"
        case "com.atebits.Tweetie2":
            return "x"
        default:
            return nil
        }
    }

    private var appVersion: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "1.0"
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Blocked Apps")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                    VStack(spacing: 20) {
                        ForEach(BlockedAppCatalog.catalog) { app in
                            let isSelected = blockedAppStore.isSelected(app.bundleId)

                            Button {
                                pendingAddApp = app
                                isConfirmingAdd = true
                            } label: {
                            HStack(spacing: 12) {
                                if let iconName = iconName(for: app) {
                                    Image(iconName)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                }

                                Text(app.name)
                                    .font(.ibmPlexMono(size: 16, weight: .semibold))
                                    .foregroundColor(.textPrimary)

                                    Spacer()

                                    if isSelected {
                                        Image("lock")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 14, height: 14)
                                            .foregroundColor(.accentBrand)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                                .background(Color.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(isSelected ? Color.accentBrand.opacity(0.35) : Color.borderHairline, lineWidth: 3)
                                )
                                .cornerRadius(14)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(isSelected)
                            .transaction { $0.animation = nil }
                        }
                    }
                    .padding(.horizontal, 24)

                    Text("You can only add more apps here.")
                        .font(.ibmPlexMono(size: 12, weight: .medium))
                        .foregroundColor(.textMuted)
                        .padding(.horizontal, 24)
                        .padding(.top, 4)

                    Spacer()
                        .frame(height: 12)

                    Text("Your name")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 24)

                    VStack(spacing: 8) {
                        TextField("Display name", text: $displayName)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                            .font(.ibmPlexMono(size: 16, weight: .semibold))
                            .textFieldStyle(.roundedBorder)
                            .focused($isNameFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                Task {
                                    await profileManager.updateDisplayName(displayName)
                                }
                            }

                        Text("This is what friends will see.")
                            .font(.ibmPlexMono(size: 12, weight: .medium))
                            .foregroundColor(.textMuted)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                        .frame(height: 12)

                    Text("About")
                        .font(.ibmPlexMono(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .padding(.horizontal, 24)

                    VStack(spacing: 0) {
                        HStack {
                            Text("Version")
                                .font(.ibmPlexMono(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            Text(appVersion)
                                .font(.ibmPlexMono(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .background(Color.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.borderHairline, lineWidth: 3)
                        )
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 24)

                    Text("by josh mayer")
                        .font(.ibmPlexMono(size: 12))
                        .foregroundColor(.textMuted)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }
                .padding(.vertical, 12)
            }
            .background(Color.appBackground.ignoresSafeArea())
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            displayName = profileManager.displayName
        }
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isNameFocused = false
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
