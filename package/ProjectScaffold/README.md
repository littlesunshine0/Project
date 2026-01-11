# ProjectScaffold

A Swift package for creating modular project structures with database tracking.

## Features

- **Modular Architecture**: Every struct, enum, class, protocol in its own file
- **Feature Modules**: Self-contained feature folders with Models, Services, Views
- **Database Tracking**: SQLite schema for tracking all code units
- **Combined Files**: Auto-generate combined files for convenience
- **CLI Tool**: Command-line interface for scaffolding

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/yourorg/ProjectScaffold", from: "1.0.0")
]
```

### Build CLI

```bash
swift build -c release
cp .build/release/scaffold /usr/local/bin/
```

## Usage

### Create a New Project

```bash
scaffold project MyApp --platform macOS --features Auth,Settings,Dashboard
```

### Create a Feature Module

```bash
scaffold feature Marketplace --path ./Sources/MyApp/Features --tags ecommerce,oauth
```

### Add a Code Unit

```bash
scaffold unit MarketplaceOrder --feature ./Features/Marketplace --kind struct --category models --tags order,ecommerce
```

### Programmatic Usage

```swift
import ProjectScaffold

// Create a project
let projectPath = try ProjectScaffold.createProject(
    name: "MyApp",
    at: URL(fileURLWithPath: "."),
    platform: .macOS,
    features: ["Auth", "Settings"]
)

// Create a feature
let featurePath = try ProjectScaffold.createFeature(
    name: "Marketplace",
    at: projectPath.appendingPathComponent("Sources/MyApp/Features"),
    description: "E-commerce marketplace integration",
    tags: ["ecommerce", "oauth"]
)

// Add a code unit
let filePath = try ProjectScaffold.addCodeUnit(
    to: featurePath,
    name: "MarketplaceOrder",
    kind: .struct,
    category: .models,
    tags: ["order", "ecommerce"],
    dependencies: ["MarketplaceItem"]
)
```

## Generated Structure

```
MyApp/
├── Package.swift
├── project_manifest.json
├── Database/
│   └── Schema.sql
├── Sources/
│   └── MyApp/
│       ├── Core/
│       │   └── CoreTypes.swift
│       └── Features/
│           └── Marketplace/
│               ├── Models/
│               │   ├── MarketplaceOrder.swift
│               │   └── MarketplaceItem.swift
│               ├── Services/
│               ├── Views/
│               ├── ViewModels/
│               ├── Protocols/
│               ├── Marketplace_MANIFEST.json
│               └── MarketplaceModels.swift (combined)
└── Tests/
    └── MyAppTests/
```

## File Header Convention

Every generated file includes metadata:

```swift
//
//  MarketplaceOrder.swift
//  Marketplace Feature
//
//  Individual Models: MarketplaceOrder struct
//  Feature: Marketplace
//  Category: Models
//  Kind: struct
//  Tags: [order, ecommerce]
//  Dependencies: [MarketplaceItem]
//

import Foundation

struct MarketplaceOrder {
    
}
```

## Database Schema

The generated schema tracks:

- **feature_modules**: Feature metadata
- **code_units**: Individual files with tags, category, kind
- **code_dependencies**: Relationships between code units

## License

MIT
