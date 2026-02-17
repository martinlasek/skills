---
name: swiftui-coding-guideline
description: SwiftUI coding guidelines covering style, structure, patterns, formatting, and pure-functions methodology. Use when editing or generating SwiftUI code or Swift files containing SwiftUI views, view models, services, or related architecture.
---

# SwiftUI Coding Guideline

## Overview

Apply these guidelines when working on SwiftUI code. Prefer minimal, readable, and maintainable changes with explicit, testable state transitions.

Use `swift-coding-guideline` as the baseline for cross-cutting Swift language/tooling rules (import hygiene, mutation semantics, enum/file rules, naming, and general formatting). This skill defines SwiftUI- and UI-architecture-specific rules on top of that baseline.

## Priorities (In Order)

1) Minimal changes that solve the problem directly.  
2) Readability over cleverness.  
3) Maintainability over short-term shortcuts.  
4) Clear architecture: each layer owns one responsibility.  
5) Pure, explicit logic with minimal side effects.  
6) Testability via small, injectable dependencies.

## Project Structure

- Prefer feature folders when they improve clarity.
  - Example: `ReadMarkdown/Markdown/View`, `ReadMarkdown/Directory/Controller`
- Keep shared primitives in `ReadMarkdown/Shared/Model` and `ReadMarkdown/Shared/Service`.
- Use a dedicated `Enum` folder for enums.
- Avoid new folders or layers unless they remove real complexity.
- Define each SwiftUI view in its own file; avoid local or nested view types in the same file unless explicitly requested.

## Example Folder Architecture

```
ReadMarkdown
├─ Directory
│  ├─ Controller
│  │  └─ DirectoryController.swift
│  ├─ Dispatcher
│  │  └─ DirectoryDispatcher.swift
│  ├─ Model
│  │  └─ DirectoryItemModel.swift
│  ├─ View
│  │  └─ DirectoryListView.swift
│  ├─ Store
│  │  └─ DirectoryStore.swift
│  └─ ViewModel
│     └─ DirectoryViewModel.swift
├─ Markdown
│  ├─ Controller
│  ├─ Dispatcher
│  ├─ Model
│  ├─ View
│  ├─ Store
│  └─ ViewModel
├─ Utility
│  ├─ View
│  │  └─ SidebarWidthReaderView.swift
│  └─ File
│     ├─ FileWatcherService.swift
│     └─ FileScannerService.swift
└─ Shared
   ├─ Enum
   │  └─ ScanMode.swift
   └─ Service
      └─ DirectoryPickerService.swift
```

## Layering Rules

View (SwiftUI)
- Declarative, minimal, UI-only logic.
- Bind to view model state; avoid side effects.
- Any SwiftUI view extracted outside `body` (e.g., `private var foo: some View`) must live in its own file as a standalone `View` type instead of a computed property.
- Use computed properties for derived values and small logic helpers, not for view subtrees.

ViewModel
- Own state and orchestration.
- Side effects must be explicit methods.
- Use `final class` by default; only use `class` when subclassing is required.
- Follow `swift-coding-guideline` for mutation semantics (`private(set)`, no-op mutator wrappers, and accessor/observer constraints).

Controller / Dispatcher
- Pure transformations only.
- No IO or persistence.
- No UI state.

Service
- Wrap IO (filesystem, watchers, network).
- Keep them small and single-purpose.
- All service types must use the `Service` suffix for consistency (e.g., `FileScannerService`, `DirectoryPickerService`).

Store
- Thin persistence adapters (e.g., `UserDefaults`).
- No business logic beyond serialization.

## Layer Definitions (Explicit Responsibilities)

Controller
- Orchestrates domain-specific flows using dispatchers and services.
- Owns no UI state.
- Should be thin and testable.

Dispatcher
- Pure data transformation (input → output).
- No side effects or IO.

Model
- Simple data structures only.
- No business logic beyond computed convenience values.

View
- UI only; no orchestration.
- Binds to view model state.

ViewModel
- UI-facing state and coordination.
- Explicit methods for side effects.

Store
- Persistence only (e.g., `UserDefaults`).
- No orchestration or UI state.

Service
- IO boundary (filesystem, watchers, dialogs).
- Single-purpose; easy to stub in tests.

## Pure Transformations

- Keep transform logic isolated in controllers/dispatchers.
- Pass data in, return data out. No side effects.

Example
```swift
struct DirectoryController {

    func makeDirectoryItems(files: [MarkdownFileModel], rootURL: URL?) -> [DirectoryItemModel] {
        // Pure transformation of inputs to outputs.
    }
}
```

## ViewModel Orchestration

- `ObservableObject` and `@Published` require Combine. Import `Combine` directly in non-view files (view models, stores, services) instead of `SwiftUI`.

```swift
final class AppViewModel: ObservableObject {

    @Published
    private(set) var files: [MarkdownFileModel] = []

    private let scanner: FileScannerService

    init(scanner: FileScannerService = FileScannerService()) {
        self.scanner = scanner
    }

    func scan(folderURL: URL) {
        files = scanner.scan(folderURL: folderURL)
    }
}
```

## Bindings Should Be Explicit When Needed

- Pass-through `Binding(get:set:)` is always a violation.
- If `get` reads `x` and `set` only writes `x = newValue`, do not use `Binding(get:set:)`.
- Use direct bindings for plain state.
- Use `Binding(get:set:)` only when `set` performs intentional behavior (mapping, validation, or calling explicit mutation methods).

Example
```swift
Toggle("Enabled", isOn: $viewModel.isEnabled)
```

Example (avoid pass-through `Binding(get:set:)`)
```swift
Toggle(
    "Enabled",
    isOn: Binding(
        get: { viewModel.isEnabled },
        set: { viewModel.isEnabled = $0 }
    )
)
```

Example
```swift
Toggle("Full scan") {
    Binding(
        get: { viewModel.scanMode == .full },
        set: { viewModel.setScanMode($0 ? .full : .topLevel) }
    )
}
```

## Testing Guidelines

- Test logic in view models and services.
- Use stubs for IO dependencies.
- Keep tests behavior-focused, not implementation-focused.

Example stub
```swift
final class StubFileScannerService {

    var files: [MarkdownFileModel] = []

    func scan(folderURL: URL) -> [MarkdownFileModel] {
        files
    }
}
```

## Naming & Code Style

- Prefer explicit names over abbreviations.
- Keep functions small and single-purpose.
- Use comments only to clarify intent, not to restate code.
- Prefer computed properties over local `let` declarations inside SwiftUI view-building closures for derived values that are reused or improve readability.
- For view subtrees, prefer dedicated `View` types in their own files over computed properties.
- Formatting preference: place attributes and modifiers on their own lines for clarity.
- Property wrappers should be on their own line, not inline with the property declaration (e.g., `@EnvironmentObject` on a separate line).
- Add a blank line between consecutive stored properties when either property uses a property wrapper or attribute (e.g., `@Published`, `@State`, `@EnvironmentObject`). Treat this as a strict formatting rule.
- Formatting preference: add a blank line after type declarations before the first member.

Example
```swift
@Published
private(set) var scanMode: ScanMode = .full

private let defaults: UserDefaults
```

Example (blank line between consecutive property wrappers)
Bad
```swift
@Published
private(set) var fileAvailability: FileAvailability = .available
@Published
private(set) var missingSelectedFile: MarkdownFile?
```

Good
```swift
@Published
private(set) var fileAvailability: FileAvailability = .available

@Published
private(set) var missingSelectedFile: MarkdownFile?
```

Example
```swift
final class AppViewModel: ObservableObject {

    @Published
    private(set) var files: [MarkdownFileModel] = []
}
```

Example
```swift
@EnvironmentObject
private var settings: SettingsViewModel
```

Example (prefer computed properties to inline `let` declarations)
Bad
```swift
private var contentView: some View {
    let bottomInset = showsTerminal ? terminalHeight + terminalPadding * 2 : 0

    return MarkdownViewerView(bottomInset: bottomInset)
}
```

Good
```swift
private var contentView: some View {
    MarkdownViewerView(bottomInset: terminalBottomInset)
}

private var terminalBottomInset: CGFloat {
    showsTerminal ? terminalHeight + terminalPadding * 2 : 0
}
```

## What to Avoid

- Over-engineering (extra layers without value).
- Implicit side effects (`didSet`, global state).
- Generic “manager” classes.
- UI logic in services/dispatchers.
- Cross-layer responsibilities (e.g., store running business logic).
