//
//  ScreenTimeManager.swift
//  fade
//
//  Created by Josh Mayer on 1/10/26.
//

import SwiftUI
import FamilyControls
import ManagedSettings

class ScreenTimeManager: ObservableObject {
    static let shared = ScreenTimeManager()
    let store = ManagedSettingsStore()

    @Published var isAuthorized = false

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            await updateAuthorizationStatus()
        } catch {
            print("Failed to authorize: \(error)")
        }
    }

    @MainActor
    func updateAuthorizationStatus() {
        isAuthorized = AuthorizationCenter.shared.authorizationStatus == .approved
    }

    func blockApps() {
        let selection = BlockedAppStore.shared.selection
        let bundleIds = selection.isEmpty ? BlockedAppCatalog.defaultSelection : selection
        let blockedApps: Set<Application> = Set(bundleIds.map { Application(bundleIdentifier: $0) })

        store.application.blockedApplications = blockedApps
        print("Apps blocked")
    }

    func unblockApps() {
        store.application.blockedApplications = nil
        print("Apps unblocked")
    }
}
