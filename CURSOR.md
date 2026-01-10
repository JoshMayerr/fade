# CURSOR.md

## Quick Reference

- **Platform**: iOS 17+
- **Language**: Swift 6.0
- **UI Framework**: SwiftUI
- **Architecture**: MVVM with @Observable

## Coding Standards

### Swift Style

- Use Swift 6 strict concurrency
- Use `async/await` for all async operations
- Follow Apple's Swift API Design Guidelines
- Use `guard` for early exits
- Prefer value types (structs) over reference types (classes)

### SwiftUI Patterns

- Extract views when they exceed 100 lines
- Use `@State` for local view state only
- Use `@Environment` for dependency injection
- Prefer `NavigationStack` over deprecated `NavigationView`
- Use `@Bindable` for bindings to @Observable objects

### Error Handling

```swift
// Always use typed errors
enum AppError: LocalizedError {
    case networkError(underlying: Error)
    case validationError(message: String)

    var errorDescription: String? {
        switch self {
        case .networkError(let error): return error.localizedDescription
        case .validationError(let msg): return msg
        }
    }
}
```

## DO NOT

- Use force unwrapping (`!`) without justification
- Ignore Swift 6 concurrency warnings
- Create massive monolithic views
- Use deprecated APIs
