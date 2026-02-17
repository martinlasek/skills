# Skills

Public Codex skills by Martin Lasek.

## Overview

This repository contains installable Codex skills focused on Swift and SwiftUI engineering quality.

### Install (Our Recommended Way)

Use this directly in Codex chat:

`$skill-installer install https://github.com/martinlasek/skills/tree/main/swift-coding-guideline`

`$skill-installer install https://github.com/martinlasek/skills/tree/main/swiftui-coding-guideline`

Then restart Codex to load newly installed skills.

### Included Skills

- `swift-coding-guideline`: Swift/Xcode/SwiftPM workflows, runtime and concurrency guidance, and non-UI architecture rules.
- `swiftui-coding-guideline`: SwiftUI architecture, layering, state management, formatting, and pure-function patterns.

## swift-coding-guideline

### Purpose

Guide Swift development tasks that are not UI-specific, including tooling, package setup, project structure, and runtime behavior.

### Key Rules

- Keep changes minimal and scoped.
- Use focused `references/` docs based on the task.
- Keep persistence adapters in `Store/`.
- Keep enums in dedicated files (with the documented `UserDefaultsKeys` exception).
- Enforce import hygiene and explicit mutation semantics.

### Use When

- Editing `Package.swift` or resolving package issues.
- Making non-UI Swift architecture or runtime changes.
- Applying strict codebase conventions for models, stores, enums, and naming.

## swiftui-coding-guideline

### Purpose

Apply strict SwiftUI coding standards for view architecture, layering, state transitions, and maintainable formatting.

### Key Rules

- Keep views UI-only and side effects explicit.
- Keep controllers/dispatchers pure (no IO).
- Use services for IO boundaries and stores for persistence only.
- Avoid pass-through `Binding(get:set:)`.
- Favor minimal and testable changes with clear responsibilities.

### Use When

- Creating or refactoring SwiftUI views and view models.
- Enforcing architecture boundaries across View, ViewModel, Controller, Dispatcher, Service, and Store.
- Normalizing SwiftUI formatting and property-wrapper style.
