# Public Codex Skills

Public Codex skills by Martin Lasek.

## Overview

This repository contains installable Codex skills focused on Swift and SwiftUI engineering quality.

### Install

Clone the repository and run the installer:

```bash
git clone https://github.com/martinlasek/skills.git
cd skills
./install.sh
```

Install all skills:

```bash
./install.sh
```

Install one specific skill:

```bash
./install.sh swift-coding-guideline
```

Install multiple specific skills:

```bash
./install.sh swift-coding-guideline swiftui-coding-guideline
```

Then restart Codex to load newly installed skills. 🚀

What `install.sh` does:
- Ensures `~/.codex/skills` exists.
- Backs up existing installed versions with a timestamp before replacing them.
- Installs all skills by default, or only selected skills when names are provided.

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
