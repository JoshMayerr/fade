//
//  BlockedAppStore.swift
//  fade
//
//  Created by Josh Mayer on 2/14/26.
//

import Foundation
import SwiftUI

final class BlockedAppStore: ObservableObject {
    static let shared = BlockedAppStore()

    private let defaultsKey = "blockedAppBundleIds"

    @Published private(set) var selection: Set<String>

    private init() {
        if let stored = UserDefaults.standard.stringArray(forKey: defaultsKey), !stored.isEmpty {
            let filtered = Set(stored).intersection(BlockedAppCatalog.catalogBundleIds)
            if filtered.isEmpty {
                selection = BlockedAppCatalog.defaultSelection
                persist()
            } else {
                selection = filtered
            }
        } else {
            selection = BlockedAppCatalog.defaultSelection
            persist()
        }
    }

    func isSelected(_ bundleId: String) -> Bool {
        selection.contains(bundleId)
    }

    func setSelected(_ bundleId: String, isSelected: Bool) {
        guard isSelected else { return }
        var next = selection
        next.insert(bundleId)
        updateSelection(next)
    }

    func setSelection(_ next: Set<String>) {
        let filtered = next.intersection(BlockedAppCatalog.catalogBundleIds)
        let committed = filtered.isEmpty ? BlockedAppCatalog.defaultSelection : filtered
        updateSelection(committed)
    }

    private func updateSelection(_ next: Set<String>) {
        selection = next
        persist()
    }

    private func persist() {
        UserDefaults.standard.set(Array(selection), forKey: defaultsKey)
    }
}
