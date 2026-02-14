//
//  AppSelectionView.swift
//  fade
//
//  Created by Josh Mayer on 2/14/26.
//

import SwiftUI

struct AppSelectionView: View {
    let onContinue: () -> Void
    @ObservedObject private var blockedAppStore = BlockedAppStore.shared

    var body: some View {
        VStack(spacing: 0) {
            Text("pick your\nblocked apps")
                .font(.joshThick(size: 52))
                .foregroundColor(.primaryBrand)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            Spacer()
                .frame(height: 12)

            Text("Choose at least one app. You can change this later in settings.")
                .font(.ibmPlexMono(size: 16, weight: .semibold))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

            Spacer()
                .frame(height: 12)

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
                    Text("Pick at least one app to continue.")
                        .foregroundColor(.textMuted)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .listRowSeparatorTint(.borderHairline)
            .background(Color.appBackground.ignoresSafeArea())

            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: onContinue) {
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
            .disabled(blockedAppStore.selection.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
    }
}

#Preview {
    AppSelectionView(onContinue: {})
}
