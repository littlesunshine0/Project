# IconKit

**Universal Icon System** - A complete, drop-in package for generating, storing, browsing, and exporting icons.

Version: 2.0.0

## Icon Naming Convention

Each icon follows the pattern: `{Domain}_{variant}_{size}.{format}`

Examples:
- `FlowKit_app_icon_512.png`
- `IdeaKit_toolbar_32.png`
- `IconKit_sidebar_24.png`
- `FlowKit_solid_black_256.png`

Asset folders follow: `{Domain}_{variant}.{appiconset|imageset}`

## Kit Icon Design System

All "Kit" packages share a consistent design:
- **Deep Squircle** - Layered background with 3 depth levels
- **Blue Gradient** - Linear gradient from light to deep blue
- **Unique Symbol** - Each Kit has its own symbol

### Kit Icons

| Kit | Symbol | Description |
|-----|--------|-------------|
| **IdeaKit** | 💡 Lightbulb | Project Operating System - ideas & reasoning |
| **IconKit** | 🖌️ Paintbrush | Universal Icon System - design & creation |

### Project Icons (Different Design)

| Project | Style | Description |
|---------|-------|-------------|
| **FlowKit** | 🔥 Warm Orb | Main Application - flow & creativity |

FlowKit is a **Project**, not a Kit, so it uses a different design (warm glowing orb).

### Design System Colors

```swift
// Kit Blue Gradient
KitColors.gradientStart  // #4A90D9 (Light blue)
KitColors.gradientMid    // #2E6BB5 (Medium blue)
KitColors.gradientEnd    // #1A4A8A (Deep blue)

// Background Layers
KitColors.bgOuter        // #0D2240 (Darkest)
KitColors.bgMiddle       // #153057 (Dark)
KitColors.bgInner        // #1E4070 (Medium dark)
```

Each icon has 30+ variants covering all use cases.

## Variant Types (30+)

### Platform App Icons
- `app_icon` - Universal app icon
- `app_icon_mac` - macOS specific
- `app_icon_ios` - iOS specific  
- `app_icon_watch` - watchOS
- `app_icon_tv` - tvOS

### In-App Usage
- `in_app` - Standard in-app display
- `thumbnail` - Small preview (32, 64px)
- `toolbar` - Toolbar icon (16-32px)
- `sidebar` - Sidebar navigation (18-32px)
- `tab_bar` - Tab bar icon (25-75px)
- `menu_bar` - Menu bar icon (16-32px)

### Style Variants
- `filled` - Solid filled version
- `outline` - Outline/stroke only
- `solid_black` - Solid black version
- `solid_white` - Solid white version
- `gradient` - Gradient version

### Background Variants
- `circle_bg` - Circle background
- `squircle_bg` - Squircle (iOS style)
- `rounded_square` - Rounded square
- `no_background` - Transparent background

### Accessibility
- `accessible` - High contrast accessible
- `voice_over` - VoiceOver optimized
- `high_contrast` - High contrast mode
- `reduced_motion` - Static version

### Animation
- `animated` - Animated version
- `animated_idle` - Idle animation
- `animated_active` - Active state animation

### Appearance
- `light_mode` - Light mode version
- `dark_mode` - Dark mode version
- `auto_dark` - Auto-switching

## Quick Start

```swift
import IconKit

// 1. Use project icons directly
FlowKitIcon(size: 128, variant: .inApp)
IdeaKitIcon(size: 64, variant: .toolbar)
IconKitIcon(size: 32, variant: .sidebar)

// 2. Use animated versions
FlowKitIconAnimated(size: 128)
IdeaKitIconAnimated(size: 64)

// 3. Export to xcassets
try await IconKit.exportProjectIcon(
    .flowKit,
    variants: [.appIcon, .toolbar, .sidebar, .solidBlack, .solidWhite],
    to: "/path/to/output"
)
```

## Drop-in Views

### AllIconsGalleryView
Browse all project icons with all variants.

```swift
AllIconsGalleryView()
```

### IconVariantGalleryView
View all variants of a specific icon.

```swift
IconVariantGalleryView(iconType: .flowKit)
```

### KitIconComparisonView
Compare all Kit icons side by side with the consistent design system.

```swift
KitIconComparisonView()
```

### KitIconAllVariantsView
Grid showing all variants for all Kit icons.

```swift
KitIconAllVariantsView()
```

### IconBrowserView
Full icon browser with Table/List/Grid/Gallery views.

```swift
IconBrowserView()
```

## Export Structure

When exporting, IconKit creates:

```
FlowKit.xcassets/
├── Contents.json
├── FlowKit_app_icon.appiconset/
│   ├── Contents.json
│   ├── icon_16x16.png
│   ├── icon_16x16@2x.png
│   ├── icon_32x32.png
│   └── ... (all sizes)
├── FlowKit_toolbar.imageset/
│   ├── Contents.json
│   ├── FlowKit_toolbar_16.png
│   ├── FlowKit_toolbar_22.png
│   ├── FlowKit_toolbar_24.png
│   └── FlowKit_toolbar_32.png
├── FlowKit_sidebar.imageset/
│   └── ...
├── FlowKit_solid_black.imageset/
│   └── ...
└── FlowKit_solid_white.imageset/
    └── ...
```

## DomainIconSet

Manage all icons for a domain:

```swift
// Create icon set for a new package
var iconSet = DomainIconSet(
    domain: "MyPackage",
    category: "Package",
    variants: [.appIcon, .inApp, .toolbar, .sidebar, .solidBlack, .solidWhite]
)

// Get all asset names
iconSet.allAssetNames
// ["MyPackage_app_icon", "MyPackage_in_app", "MyPackage_toolbar", ...]

// Total files to generate
iconSet.totalFileCount // e.g., 42 files
```

## IconAsset

Individual icon asset with naming:

```swift
let asset = IconAsset(domain: "FlowKit", variant: .toolbar)

asset.assetName        // "FlowKit_toolbar"
asset.filename(size: 32) // "FlowKit_toolbar_32.png"
asset.allFilenames     // ["FlowKit_toolbar_16.png", "FlowKit_toolbar_22.png", ...]
```

## Services

### IconStorageService
Persistent icon database.

### IconGenerationService
Generate icon variants and export to files.

### IconBatchService
Batch operations for multiple icons.

### XCAssetExporter
Export to Xcode xcassets format.

## Requirements

- macOS 15.0+
- Swift 6.0+
- SwiftUI

## License

MIT License
