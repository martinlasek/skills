# Skills

Public Codex skills by Martin Lasek.

## Overview

This repository contains installable Codex skills focused on Swift and SwiftUI engineering quality.

### Install (Our Recommended Way)

Use this directly in Codex chat:

`$skill-installer install https://github.com/martinlasek/skills/tree/main/swift-coding-guideline`

`$skill-installer install https://github.com/martinlasek/skills/tree/main/swiftui-coding-guideline`

Then restart Codex to load newly installed skills.

## Skills

### ⚙️ Swift Coding Guideline

**Purpose**: Apply core Swift engineering rules across Xcode, SwiftPM, runtime behavior, and codebase conventions.

**Key Features**:
- SwiftPM and package-resolution workflow guidance
- Runtime and concurrency-oriented guardrails
- Cross-cutting Swift rules for naming, enum organization, import hygiene, and mutation semantics
- Strong folder conventions for Model, Store, and Shared boundaries

**Use When**: You are working on non-UI Swift tasks, package/tooling issues, runtime behavior, or enforcing global Swift code conventions.

---

### 🧩 SwiftUI Coding Guideline

**Purpose**: Apply SwiftUI-specific architecture and formatting rules for maintainable views, view models, and UI-layer boundaries.

**Key Features**:
- Clear layer boundaries across View, ViewModel, Controller, Dispatcher, Service, and Store
- SwiftUI-first view composition rules (standalone view files, no subtree computed views)
- Binding guidance to avoid pass-through `Binding(get:set:)`
- UI-focused formatting rules for wrappers, attributes, and view-building readability

**Use When**: You are creating or refactoring SwiftUI views/view models and need strict UI architecture, binding, and formatting consistency.
