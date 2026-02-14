//
//  AppSelectionView.swift
//  fade
//
//  Created by Josh Mayer on 2/14/26.
//

import SwiftUI

struct AppSelectionView: View {
    let onContinue: () -> Void
    @State private var stagedSelection: Set<String> = BlockedAppCatalog.defaultSelection

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
                            get: { stagedSelection.contains(app.bundleId) },
                            set: { isSelected in
                                if isSelected {
                                    stagedSelection.insert(app.bundleId)
                                } else {
                                    stagedSelection.remove(app.bundleId)
                                }
                            }
                        )) {
                            Text(app.name)
                        }
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
            Button(action: {
                BlockedAppStore.shared.setSelection(stagedSelection)
                onContinue()
            }) {
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
            .disabled(stagedSelection.isEmpty)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.ignoresSafeArea())
        .onAppear {
            stagedSelection = BlockedAppStore.shared.selection
        }
    }
}

#Preview {
    AppSelectionView(onContinue: {})
}
