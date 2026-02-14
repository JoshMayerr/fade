//
//  BlockedAppCatalog.swift
//  fade
//
//  Created by Josh Mayer on 2/14/26.
//

import Foundation

struct BlockableApp: Identifiable, Hashable {
    let name: String
    let bundleId: String

    var id: String { bundleId }
}

enum BlockedAppCatalog {
    static let catalog: [BlockableApp] = [
        BlockableApp(name: "TikTok", bundleId: "com.zhiliaoapp.musically"),
        BlockableApp(name: "Instagram", bundleId: "com.burbn.instagram"),
        BlockableApp(name: "YouTube", bundleId: "com.google.ios.youtube"),
        BlockableApp(name: "Snapchat", bundleId: "com.toyopagroup.picaboo"),
        BlockableApp(name: "Facebook", bundleId: "com.facebook.Facebook")
    ]

    static let defaultSelection: Set<String> = [
        "com.zhiliaoapp.musically",
        "com.burbn.instagram"
    ]

    static let catalogBundleIds: Set<String> = Set(catalog.map { $0.bundleId })
}
