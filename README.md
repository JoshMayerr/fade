# fade

iOS app that blocks distracting apps and tracks time since you started your digital detox.

## Features

- Block apps using Screen Time API
- Track time elapsed (weeks, days, hours, minutes, seconds)
- Simple, minimal interface

## Blocking APIs

The app uses Apple's Screen Time APIs to block applications:

- **FamilyControls**: Used for requesting user authorization via `AuthorizationCenter.shared.requestAuthorization(for: .individual)`. This requires the user to grant Screen Time permissions in Settings.

- **ManagedSettings**: Used to actually block apps through `ManagedSettingsStore`. The store's `application.blockedApplications` property is set with a `Set<Application>` containing the bundle identifiers of apps to block.

- **Entitlements**: Requires the `com.apple.developer.family-controls` entitlement in the app's entitlements file.

The blocking works at the system level - once apps are added to `blockedApplications`, iOS prevents them from launching until they are removed from the set or the app is uninstalled.

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Screen Time authorization (user must grant permission)
- Family Controls entitlement

## Building

Open `fade.xcodeproj` in Xcode and build. Ensure the Family Controls capability is enabled in the project settings.
