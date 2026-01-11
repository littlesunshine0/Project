//
//  IconKit.swift
//  IconKit - Universal Icon System
//
//  A complete, drop-in package for generating, storing, browsing, and exporting icons
//  for projects, packages, features, services, modules, and capabilities.
//
//  Drop-in Components:
//  - IconBrowserView: Full icon browser with Table/List/Grid/Gallery views
//  - IconDetailView: Detailed icon view with variants and export
//  - IconPicker: Select icons from storage
//  - IconEditor: Create and edit icons
//  - CapabilityIcon: Universal capability icons
//
//  Services:
//  - IconStorageService: Persistent icon database
//  - IconGenerationService: Generate icon variants
//  - IconBatchService: Batch operations
//

import SwiftUI

/// IconKit - Universal Icon System
///
/// A complete, drop-in icon system for any Swift project.
///
/// Quick Start:
/// ```swift
/// // 1. Initialize storage
/// try await IconStorageService.shared.initialize()
///
/// // 2. Use drop-in browser
/// IconBrowserView()
///
/// // 3. Or use individual components
/// IconPicker(selectedIconId: $iconId)
/// IconDesign(style: .glowOrb, size: 64)
/// CapabilityIcon(capability: "intent", size: 48)
/// ```
///
public struct IconKit {
    
    /// Current version
    public static let version = "2.0.0"
    
    // MARK: - Icon Categories
    
    /// All icon categories supported
    public enum IconCategory: String, CaseIterable, Sendable {
        case project = "Project"
        case package = "Package"
        case feature = "Feature"
        case service = "Service"
        case module = "Module"
        case capability = "Capability"
        
        public var defaultIcon: IconStyle {
            switch self {
            case .project: return .glowOrb
            case .package: return .cube
            case .feature: return .star
            case .service: return .gear
            case .module: return .layers
            case .capability: return .lightbulb
            }
        }
        
        public var systemImage: String {
            switch self {
            case .project: return "folder.fill"
            case .package: return "shippingbox.fill"
            case .feature: return "star.fill"
            case .service: return "gearshape.fill"
            case .module: return "square.stack.3d.up.fill"
            case .capability: return "lightbulb.fill"
            }
        }
    }
    
    // MARK: - Services
    
    /// Shared icon storage service
    public static var storage: IconStorageService { IconStorageService.shared }
    
    /// Shared icon generation service
    public static var generator: IconGenerationService { IconGenerationService.shared }
    
    /// Shared batch operations service
    public static var batch: IconBatchService { IconBatchService.shared }
    
    /// Shared icon registry
    public static let registry = IconRegistry.shared
    
    /// Shared asset exporter
    @MainActor
    public static let exporter = XCAssetExporter()
    
    // MARK: - Quick Access
    
    /// Initialize IconKit - call once at app startup
    public static func initialize() async throws {
        try await storage.initialize()
    }
    
    /// Get all stored icons
    public static func allIcons() async -> [StoredIcon] {
        await storage.fetchAll()
    }
    
    /// Get icons by category
    public static func icons(for category: IconCategory) async -> [StoredIcon] {
        await storage.fetch(category: category)
    }
    
    /// Get icon by ID
    public static func icon(id: String) async -> StoredIcon? {
        await storage.fetch(id: id)
    }
    
    /// Search icons
    public static func search(_ query: String) async -> [StoredIcon] {
        await storage.search(query: query)
    }
    
    /// Save an icon
    public static func save(_ icon: StoredIcon) async throws {
        try await storage.save(icon)
    }
    
    /// Delete an icon
    public static func delete(id: String) async throws {
        try await storage.delete(id: id)
    }
    
    /// Generate an icon view for an entity
    @MainActor
    public static func generateIcon(
        for category: IconCategory,
        name: String,
        style: IconStyle? = nil,
        size: CGFloat = 1024
    ) -> some View {
        let iconStyle = style ?? category.defaultIcon
        return IconDesign(style: iconStyle, size: size, label: name)
    }
    
    /// Export icons to xcassets
    @MainActor
    public static func exportToXCAssets(
        icons: [IconDefinition],
        outputPath: String
    ) throws {
        try exporter.export(icons: icons, to: outputPath)
    }
    
    /// Export stored icon to xcassets
    @MainActor
    public static func exportStoredIcon(_ icon: StoredIcon, to path: String) throws {
        try exporter.exportIcon(icon.definition, to: path)
    }
    
    // MARK: - Project Icons
    
    /// Get FlowKit icon
    @MainActor
    public static func flowKitIcon(size: CGFloat = 128, variant: IconVariantType = .inApp) -> some View {
        FlowKitIcon(size: size, variant: variant)
    }
    
    /// Get IdeaKit icon
    @MainActor
    public static func ideaKitIcon(size: CGFloat = 128, variant: IconVariantType = .inApp) -> some View {
        IdeaKitIcon(size: size, variant: variant)
    }
    
    /// Get IconKit icon
    @MainActor
    public static func iconKitIcon(size: CGFloat = 128, variant: IconVariantType = .inApp) -> some View {
        IconKitIcon(size: size, variant: variant)
    }
    
    /// Export project icon with all variants
    @MainActor
    public static func exportProjectIcon(
        _ iconType: ProjectIconType,
        variants: [IconVariantType] = IconVariantSpec.essentialVariants.map(\.type),
        to outputPath: String
    ) throws -> ExportResult {
        try exporter.exportProjectIcon(iconType, variants: variants, to: outputPath)
    }
    
    // MARK: - Information
    
    public static func printInfo() {
        print("""
        ╔══════════════════════════════════════════════════════════════╗
        ║                    IconKit v\(version)                          ║
        ║                  Universal Icon System                       ║
        ╠══════════════════════════════════════════════════════════════╣
        ║                                                              ║
        ║  Project Icons (Custom):                                     ║
        ║    🔥 FlowKit  - Warm glowing orb                            ║
        ║    💡 IdeaKit  - Illuminated lightbulb                       ║
        ║    ⬡ IconKit  - Hexagonal design                            ║
        ║                                                              ║
        ║  Variant Types (30+):                                        ║
        ║    Platform: appIcon, iOS, macOS, watchOS, tvOS              ║
        ║    In-App: thumbnail, toolbar, sidebar, tabBar, menuBar      ║
        ║    Style: filled, outline, solidBlack, solidWhite, gradient  ║
        ║    Background: circle, squircle, roundedSquare, transparent  ║
        ║    Accessibility: accessible, voiceOver, highContrast        ║
        ║    Animation: animated, idle, active                         ║
        ║    Appearance: lightMode, darkMode, autoDark                 ║
        ║                                                              ║
        ║  Drop-in Components:                                         ║
        ║    📋 IconBrowserView      - Full browser                    ║
        ║    🎨 IconVariantGalleryView - All variants grouped          ║
        ║    🖼️ AllIconsGalleryView  - All project icons               ║
        ║    🎯 IconPicker           - Select icons                    ║
        ║    ✏️ IconEditor           - Create/edit icons               ║
        ║                                                              ║
        ║  Export:                                                     ║
        ║    • xcassets for all platforms                              ║
        ║    • All sizes for each platform                             ║
        ║    • PNG export at any size                                  ║
        ║                                                              ║
        ╚══════════════════════════════════════════════════════════════╝
        """)
    }
}

/// Export result
public struct ExportResult: Sendable {
    public let totalFiles: Int
    public let exportedFiles: [String]
    public let errors: [String]
    public let outputPath: String
    
    public var success: Bool { errors.isEmpty }
    
    public var summary: String {
        if success {
            return "Exported \(totalFiles) files to \(outputPath)"
        } else {
            return "Exported \(totalFiles) files with \(errors.count) errors"
        }
    }
}

// MARK: - Convenience Extensions

public extension View {
    /// Add an icon overlay to any view
    func iconOverlay(style: IconStyle, size: CGFloat = 24, alignment: Alignment = .topTrailing) -> some View {
        self.overlay(alignment: alignment) {
            IconDesign(style: style, size: size)
                .padding(4)
        }
    }
}

// MARK: - Preview

#Preview("IconKit Overview") {
    VStack(spacing: 20) {
        Text("IconKit v\(IconKit.version)")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        Text("Universal Icon System")
            .font(.headline)
            .foregroundStyle(.secondary)
        
        Divider()
        
        Text("Icon Styles")
            .font(.headline)
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
            ForEach(IconStyle.allCases, id: \.self) { style in
                VStack {
                    IconDesign(style: style, size: 48)
                    Text(style.rawValue)
                        .font(.caption2)
                }
            }
        }
        
        Divider()
        
        Text("Capabilities")
            .font(.headline)
        
        UniversalCapabilityIcons(size: 48)
    }
    .padding()
    .frame(width: 600)
}
