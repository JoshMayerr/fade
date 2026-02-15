//
//  AppSelectionView.swift
//  fade
//
//  Created by Josh Mayer on 2/14/26.
//

import SwiftUI

struct AppSelectionView: View {
    let onContinue: () -> Void
    @State private var stagedSelection: Set<String>
    @StateObject private var store = BlockedAppStore.shared

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

    init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
        _stagedSelection = State(initialValue: BlockedAppStore.shared.selection)
    }

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
                .frame(height: 24)

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(spacing: 20) {
                        ForEach(BlockedAppCatalog.catalog) { app in
                            let isSelected = stagedSelection.contains(app.bundleId)

                            Button(action: {
                                if isSelected {
                                    stagedSelection.remove(app.bundleId)
                                } else {
                                    stagedSelection.insert(app.bundleId)
                                }
                            }) {
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
                        }
                    }
                    .padding(.horizontal, 24)

                }
                .padding(.vertical, 12)
            }
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
        .onChange(of: store.selection) { _, newValue in
            var transaction = Transaction()
            transaction.animation = nil
            withTransaction(transaction) {
                stagedSelection = newValue
            }
        }
    }
}

#Preview {
    AppSelectionView(onContinue: {})
}
