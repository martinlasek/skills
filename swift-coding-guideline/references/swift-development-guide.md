# Swift Development Guide

## Adding a Non-Local Swift Package Dependency (SwiftPM) Without Xcode UI

This guide documents a repeatable, non-GUI approach to add a remote Swift Package dependency (non-local) and wire it into a target.

---

## 1) Xcode Project File (Automated .pbxproj Edit)

This is the only non-GUI method when working with an Xcode project. It is brittle; take a backup before editing.

### A. Add an `XCRemoteSwiftPackageReference`
Add a new entry:
```
<UUID> /* XCRemoteSwiftPackageReference "PackageName" */ = {
    isa = XCRemoteSwiftPackageReference;
    repositoryURL = "https://github.com/owner/repo";
    requirement = {
        kind = upToNextMajorVersion;
        minimumVersion = 1.2.3;
    };
};
```

### B. Add an `XCSwiftPackageProductDependency`
```
<UUID> /* PackageProduct */ = {
    isa = XCSwiftPackageProductDependency;
    package = <UUID> /* XCRemoteSwiftPackageReference "PackageName" */;
    productName = ProductName;
};
```

### C. Attach to the Target
- Add the product dependency UUID under the target’s `packageProductDependencies`.
- Add a `PBXBuildFile` entry and include it in the target’s **Frameworks** build phase:
```
<UUID> /* Product in Frameworks */ = {isa = PBXBuildFile; productRef = <ProductUUID>; };
```

### D. Attach to Project Package References
Under the `PBXProject` object, add the package reference UUID to `packageReferences`.

---

## 2) Swift Package Manager (Command Line)

If you use a SwiftPM package (not Xcode), add dependencies in `Package.swift`:

```
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/owner/repo", from: "1.2.3")
    ],
    targets: [
        .target(
            name: "MyTarget",
            dependencies: [
                .product(name: "ProductName", package: "repo")
            ]
        )
    ]
)
```

---

## 3) Versioning and Pinning Guidance

- **Up to Next Major**: safest default for semantic versioning.
- **Exact Version**: use when you need full stability or reproducible builds.
- **Branch**: for active development or unreleased features.
- **Commit**: for strict reproducibility or hotfixes.

---

## 4) Common Pitfalls

- **Product vs Package**: You must add a **product** to a target, not just the package.
- **Multiple Targets**: Each target that uses the package needs the product dependency.
- **Merge Conflicts**: `Package.resolved` can end up with duplicate pins after merges; re-resolve or remove duplicates.
- **Stale DerivedData**: If builds fail after adding, reset with **Product > Clean Build Folder**.
- **macOS Sandbox**: Some packages require sandbox or entitlements adjustments.
- **Build Errors**: Ensure the package supports your platform and deployment target.

---

## 5) Verifying Integration

1) Import the module in code:
```
import ProductName
```
2) Build the target.
3) Confirm the dependency is listed in:
   - **Project > Package Dependencies**
   - **Target > Frameworks, Libraries, and Embedded Content**

---

## 6) Recommended Documentation Notes

When you add a dependency, record:
- URL
- Product name
- Version rule
- Target(s) linked

---

## 7) Troubleshooting Checklist

- Can Xcode resolve the package? (**File > Packages > Resolve Package Versions**)
- Is the product added to the target?
- Does the package support your deployment target?
- Are you pinned to a valid tag?
- Is the package cached incorrectly? (clear DerivedData)
- If Xcode reports `Package.resolved` is malformed or corrupted, check for duplicate entries (often from merges). Remove the duplicate pin or re-resolve packages to regenerate the file.

---

## 8) Example: Adding SwiftTerm

- Repo: `https://github.com/migueldeicaza/SwiftTerm`
- Product: `SwiftTerm`
- Version rule: `upToNextMajorVersion` from `1.2.0`

Once added, use:
```
import SwiftTerm
```
