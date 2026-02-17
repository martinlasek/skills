---
name: swift-coding-guideline
description: Core Swift development workflows for Xcode and Swift tooling, including project setup, dependency management, concurrency guidance, language/runtime best practices, and troubleshooting build or package resolution issues. Use when working on Swift tasks across a codebase, especially package/tooling/runtime work and cross-cutting Swift conventions (mutation semantics, naming, enum/file rules, import hygiene), including in SwiftUI projects.
---

# Swift Development Guide Skill

## Use the relevant reference

- Read the most relevant file in `references/` for the task at hand.
- Start with `references/swift-package-guide.md` only when the task is about SwiftPM or package resolution.
- When multiple references apply, prioritize the most specific one and only load others if needed.

## Apply the reference guidance

- Apply the workflow from the selected `references/` file.
- Keep changes minimal and scoped to the request; avoid broad refactors unless asked.
- For package tasks, follow the non-GUI SwiftPM steps in `references/swift-package-guide.md`.
- Use SwiftPM CLI guidance only when the project is `Package.swift`-based.
- For language/runtime topics (e.g., `MainActor`, actors, isolation), consult the specific concurrency or runtime reference if present.

## Keep edits safe

- Avoid manual edits to generated files unless fixing a known issue.
- When editing `project.pbxproj`, make minimal, targeted changes and verify the new package is attached to the target and project references.
- Prefer documented tooling workflows over ad hoc edits when guidance exists in `references/`.

## Model Folder Rule

`Model/` is only for data structs/classes that represent app or domain models. Enums are not
models; place enums in `Enum/` (or the closest feature folder).

## Store Folder Rule

Files that implement persistence adapters (e.g., `UserDefaults`) are Store types and must live in
`Store/` (or `Shared/Store` for shared scope). Do not place `*Store` types in `Service/`.

## Shared Folder Rule

`Shared/` is only for truly cross-feature primitives. If a type is feature-specific, place it
under that feature folder (e.g., `File/Service`, `Directory/Store`) even if it is reused elsewhere.

## Import Hygiene (Mandatory)

Before finalizing, verify all needed imports are present for any new types or APIs you use. Do not assume transitive imports; add explicit imports so the file builds cleanly on its own.

## Swift Properties & Mutation Semantics (Mandatory)

Goal
- Make mutations obvious.
- Avoid hidden work on assignment (`=`) in app-authored accessor code.
- Keep values/state as properties and actions/mutations as methods.

Core Rules
1) No-op mutator wrappers are forbidden.
- Methods like `setX(...)`, `updateX(...)`, `applyX(...)`, `moveX(to:)` must not exist if they only perform direct assignment.
- If no real behavior exists, remove the method and allow direct property assignment.

2) `private(set)` is conditional, not default.
- Use `private(set)` only when mutation must be controlled by methods that add real behavior.
- If assignment is plain state replacement, do not use `private(set)` to force wrapper methods.

3) App-authored property accessors/observers are forbidden.
- Do not write explicit property `get` / `set` accessors.
- Do not use `willSet` / `didSet` observers.

4) Computed properties are getter-only and pure.
- Computed properties must not declare setters.
- Getter-only computed properties must not mutate state.
- Getter-only computed properties must not cause side effects (for example logging, I/O, persistence, fixups).

5) Semantics by construct.
- Properties should be nouns (state/value).
- Methods should be verbs (actions/mutations).

Scope Clarification
- The accessor/observer bans apply to property code written in app source.
- Framework-managed wrappers (for example `@State`, `@Published`, `@AppStorage`, `@Environment`) are allowed.

SwiftUI-specific binding guidance (`Binding(get:set:)` pass-through bans and view-binding patterns) belongs in `swiftui-coding-guideline`.

Bad
```swift
private(set) var targetLanguage: TargetLanguage = .traditionalChinese

func setTargetLanguage(_ value: TargetLanguage) {
    targetLanguage = value
}
```

Good
```swift
var targetLanguage: TargetLanguage = .traditionalChinese
```

## Multi-line Call Formatting

Avoid cramming multi-argument calls on a single line when they hurt readability. Prefer vertical formatting with one argument per line.

Bad
```swift
func saveLastFile(url: URL) {
    defaults.set(url.path, forKey: UserDefaultsKeys.FileStore.lastSelectedFile)
    do {
        let data = try url.bookmarkData(options: .withSecurityScope,
                                        includingResourceValuesForKeys: nil,
                                        relativeTo: nil)
        defaults.set(data, forKey: UserDefaultsKeys.FileStore.lastSelectedFileBookmark)
    } catch {
        defaults.removeObject(forKey: UserDefaultsKeys.FileStore.lastSelectedFileBookmark)
    }
}
```

Good
```swift
func saveLastFile(url: URL) {
    defaults.set(url.path, forKey: UserDefaultsKeys.FileStore.lastSelectedFile)
    do {
        let data = try url.bookmarkData(
            options: .withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )

        defaults.set(data, forKey: UserDefaultsKeys.FileStore.lastSelectedFileBookmark)
    } catch {
        defaults.removeObject(forKey: UserDefaultsKeys.FileStore.lastSelectedFileBookmark)
    }
}
```

## Multi-line If Formatting

For multi-line `if` bindings, align `let` with `if` and place the opening brace on its own line.

Bad
```swift
if let url = try? URL(
    resolvingBookmarkData: data,
    options: [.withSecurityScope],
    relativeTo: nil,
    bookmarkDataIsStale: &isStale
),
    isValidFile(url: url) {
    if isStale { saveLastFile(url: url) }
    return url
}
```

## Guard Over Nested If

Prefer `guard` over nested `if` when it improves readability by reducing indentation.

Bad
```swift
if
    let url = try? URL(
        resolvingBookmarkData: data,
        options: [.withSecurityScope],
        relativeTo: nil,
        bookmarkDataIsStale: &isStale
    ),
    isValidFile(url: url)
{
    if isStale {
        saveLastFile(url: url)
    }

    return url
}
```

Good
```swift
guard
    let url = try? URL(
        resolvingBookmarkData: data,
        options: [.withSecurityScope],
        relativeTo: nil,
        bookmarkDataIsStale: &isStale
    ),
    isValidFile(url: url)
else {
    return nil
}

if isStale {
    saveLastFile(url: url)
}

return url
```

Good
```swift
if
    let url = try? URL(
        resolvingBookmarkData: data,
        options: [.withSecurityScope],
        relativeTo: nil,
        bookmarkDataIsStale: &isStale
    ),
    isValidFile(url: url)
{
    if isStale {
        saveLastFile(url: url)
    }

    return url
}
```

## Naming Rule (Mandatory)

Do not use underscores in function names or property names. Swift naming should be lowerCamelCase without underscores (e.g., `loadUserProfile`, not `load_user_profile`).

## Model Naming Rule (Mandatory)

All model types must use the `Model` suffix for consistency (e.g., `MarkdownFileModel`).

Enums that represent configuration or view state can omit the `Model` suffix (e.g., `ScanMode`).

## Reserved Term Rule (Mandatory)

Never use the name `coordinator` for types, variables, properties, functions, protocol names, file names, or architecture roles.

If a user explicitly requests using `coordinator`, pause and ask a direct confirmation question before proceeding with that naming.

## Enum File Rule (Mandatory)

All enums must live in their own dedicated file. Do not declare enums alongside classes, structs, or services, even if the enum is currently used in only one place. Prefer placing enum files under an `Enum/` folder within the relevant feature.

Exception (strict, one case only): `UserDefaultsKeys` may be defined as one root enum with nested enums in a single file to keep key namespaces centralized and easier to audit for name clashes. This exception is unique and does not apply to any other enum.

## Enum Case Spacing (Mandatory)

Always insert a blank line between every enum case declaration. Before finalizing, scan any enum
in edited files and normalize spacing. Do not leave compact enums like:

```swift
enum Foo {
    case a
    case b
}
```

Use:

```swift
enum Foo {

    case a

    case b
}
```

## File Header Rule (Mandatory)

File doc comments must list a real human author in the "Created by" line and include the date, formatted like: "Created by Martin Lasek on 18/01/2026."

When creating new files, set the "Created by" date to the current date.

Preserve existing human authorship lines (e.g., keep "emin" if already present) unless the user explicitly asks to change them.
