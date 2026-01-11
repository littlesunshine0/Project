//
//  IconVariantType.swift
//  IconKit
//
//  Comprehensive icon variant types - each icon has multiple variants
//  for different contexts: app icon, toolbar, sidebar, accessibility, etc.
//

import SwiftUI

/// All possible icon variant types
/// Each icon should have all these variants generated
public enum IconVariantType: String, CaseIterable, Codable, Sendable, Identifiable {
    public var id: String { rawValue }
    
    // MARK: - Platform App Icons
    case appIcon = "app_icon"           // Full app icon (macOS/iOS)
    case appIconMac = "app_icon_mac"    // macOS specific
    case appIconIOS = "app_icon_ios"    // iOS specific
    case appIconWatch = "app_icon_watch" // watchOS
    case appIconTV = "app_icon_tv"      // tvOS
    
    // MARK: - In-App Usage
    case inApp = "in_app"               // Standard in-app display
    case thumbnail = "thumbnail"         // Small preview
    case toolbar = "toolbar"             // Toolbar icon
    case sidebar = "sidebar"             // Sidebar navigation
    case tabBar = "tab_bar"             // Tab bar icon
    case menuBar = "menu_bar"           // Menu bar icon
    
    // MARK: - Style Variants
    case filled = "filled"               // Solid filled
    case outline = "outline"             // Outline/stroke only
    case solidBlack = "solid_black"      // Solid black version
    case solidWhite = "solid_white"      // Solid white version
    case gradient = "gradient"           // Gradient version
    
    // MARK: - Background Variants
    case circleBackground = "circle_bg"      // Circle background
    case squircleBackground = "squircle_bg"  // Squircle (iOS style)
    case roundedSquare = "rounded_square"    // Rounded square
    case noBackground = "no_background"      // Transparent background
    
    // MARK: - Accessibility
    case accessible = "accessible"       // High contrast accessible
    case voiceOver = "voice_over"        // VoiceOver optimized
    case highContrast = "high_contrast"  // High contrast mode
    case reducedMotion = "reduced_motion" // Static version
    
    // MARK: - Animation
    case animated = "animated"           // Animated version
    case animatedIdle = "animated_idle"  // Idle animation
    case animatedActive = "animated_active" // Active state animation
    
    // MARK: - Dark/Light Mode
    case lightMode = "light_mode"        // Light mode version
    case darkMode = "dark_mode"          // Dark mode version
    case autoDark = "auto_dark"          // Auto-switching
    
    // MARK: - Display Name
    
    public var displayName: String {
        switch self {
        case .appIcon: return "App Icon"
        case .appIconMac: return "macOS App Icon"
        case .appIconIOS: return "iOS App Icon"
        case .appIconWatch: return "watchOS App Icon"
        case .appIconTV: return "tvOS App Icon"
        case .inApp: return "In-App"
        case .thumbnail: return "Thumbnail"
        case .toolbar: return "Toolbar"
        case .sidebar: return "Sidebar"
        case .tabBar: return "Tab Bar"
        case .menuBar: return "Menu Bar"
        case .filled: return "Filled"
        case .outline: return "Outline"
        case .solidBlack: return "Solid Black"
        case .solidWhite: return "Solid White"
        case .gradient: return "Gradient"
        case .circleBackground: return "Circle Background"
        case .squircleBackground: return "Squircle Background"
        case .roundedSquare: return "Rounded Square"
        case .noBackground: return "No Background"
        case .accessible: return "Accessible"
        case .voiceOver: return "VoiceOver"
        case .highContrast: return "High Contrast"
        case .reducedMotion: return "Reduced Motion"
        case .animated: return "Animated"
        case .animatedIdle: return "Animated (Idle)"
        case .animatedActive: return "Animated (Active)"
        case .lightMode: return "Light Mode"
        case .darkMode: return "Dark Mode"
        case .autoDark: return "Auto Dark"
        }
    }
    
    // MARK: - Category
    
    public var category: VariantCategory {
        switch self {
        case .appIcon, .appIconMac, .appIconIOS, .appIconWatch, .appIconTV:
            return .platform
        case .inApp, .thumbnail, .toolbar, .sidebar, .tabBar, .menuBar:
            return .inApp
        case .filled, .outline, .solidBlack, .solidWhite, .gradient:
            return .style
        case .circleBackground, .squircleBackground, .roundedSquare, .noBackground:
            return .background
        case .accessible, .voiceOver, .highContrast, .reducedMotion:
            return .accessibility
        case .animated, .animatedIdle, .animatedActive:
            return .animation
        case .lightMode, .darkMode, .autoDark:
            return .appearance
        }
    }
    
    // MARK: - Default Sizes
    
    public var defaultSizes: [Int] {
        switch self {
        case .appIcon, .appIconMac:
            return [16, 32, 64, 128, 256, 512, 1024]
        case .appIconIOS:
            return [20, 29, 40, 58, 60, 76, 80, 87, 120, 152, 167, 180, 1024]
        case .appIconWatch:
            return [48, 55, 58, 80, 87, 88, 100, 172, 196, 216, 1024]
        case .appIconTV:
            return [400, 800, 1280]
        case .thumbnail:
            return [32, 64]
        case .toolbar, .menuBar:
            return [16, 22, 24, 32]
        case .sidebar:
            return [18, 24, 32]
        case .tabBar:
            return [25, 50, 75]
        default:
            return [64, 128, 256, 512]
        }
    }
    
    // MARK: - Export Filename
    
    /// Generate filename: {Domain}_{variant}_{size}.png
    /// e.g., FlowKit_app_icon_512.png, IdeaKit_toolbar_32.png
    public func filename(for domain: String, size: Int, format: String = "png") -> String {
        "\(domain)_\(rawValue)_\(size).\(format)"
    }
    
    /// Generate filename without size (for imageset folder)
    /// e.g., FlowKit_app_icon, IdeaKit_toolbar
    public func assetName(for domain: String) -> String {
        "\(domain)_\(rawValue)"
    }
    
    /// Full asset path for xcassets
    /// e.g., FlowKit_app_icon.appiconset or FlowKit_toolbar.imageset
    public func assetPath(for domain: String) -> String {
        let name = assetName(for: domain)
        let ext = category == .platform ? "appiconset" : "imageset"
        return "\(name).\(ext)"
    }
}

// MARK: - Icon Asset

/// Represents a complete icon asset with domain and variant
public struct IconAsset: Identifiable, Codable, Sendable {
    public var id: String { "\(domain)_\(variant.rawValue)" }
    
    public let domain: String           // e.g., "FlowKit", "IdeaKit", "IconKit"
    public let variant: IconVariantType
    public var sizes: [Int]
    public var isGenerated: Bool
    public var generatedAt: Date?
    public var filePaths: [String]
    
    public init(
        domain: String,
        variant: IconVariantType,
        sizes: [Int]? = nil,
        isGenerated: Bool = false,
        filePaths: [String] = []
    ) {
        self.domain = domain
        self.variant = variant
        self.sizes = sizes ?? variant.defaultSizes
        self.isGenerated = isGenerated
        self.generatedAt = nil
        self.filePaths = filePaths
    }
    
    /// Asset name: {Domain}_{variant}
    public var assetName: String {
        variant.assetName(for: domain)
    }
    
    /// Filename for a specific size
    public func filename(size: Int, format: String = "png") -> String {
        variant.filename(for: domain, size: size, format: format)
    }
    
    /// All filenames for this asset
    public var allFilenames: [String] {
        sizes.map { filename(size: $0) }
    }
}

/// Variant category for grouping
public enum VariantCategory: String, CaseIterable, Sendable {
    case platform = "Platform"
    case inApp = "In-App"
    case style = "Style"
    case background = "Background"
    case accessibility = "Accessibility"
    case animation = "Animation"
    case appearance = "Appearance"
    
    public var variants: [IconVariantType] {
        IconVariantType.allCases.filter { $0.category == self }
    }
}

/// Complete variant specification for an icon
public struct IconVariantSpec: Identifiable, Codable, Sendable {
    public var id: String { type.rawValue }
    public let type: IconVariantType
    public var sizes: [Int]
    public var isGenerated: Bool
    public var generatedAt: Date?
    public var filePaths: [String]
    
    public init(
        type: IconVariantType,
        sizes: [Int]? = nil,
        isGenerated: Bool = false,
        filePaths: [String] = []
    ) {
        self.type = type
        self.sizes = sizes ?? type.defaultSizes
        self.isGenerated = isGenerated
        self.generatedAt = nil
        self.filePaths = filePaths
    }
    
    /// All default variants for a complete icon
    public static var allVariants: [IconVariantSpec] {
        IconVariantType.allCases.map { IconVariantSpec(type: $0) }
    }
    
    /// Essential variants (minimum set for any project)
    public static var essentialVariants: [IconVariantSpec] {
        [
            IconVariantSpec(type: .appIcon),
            IconVariantSpec(type: .inApp),
            IconVariantSpec(type: .thumbnail),
            IconVariantSpec(type: .toolbar),
            IconVariantSpec(type: .sidebar),
            IconVariantSpec(type: .filled),
            IconVariantSpec(type: .outline),
            IconVariantSpec(type: .solidBlack),
            IconVariantSpec(type: .solidWhite),
            IconVariantSpec(type: .circleBackground),
            IconVariantSpec(type: .squircleBackground),
            IconVariantSpec(type: .gradient),
            IconVariantSpec(type: .accessible),
            IconVariantSpec(type: .animated),
            IconVariantSpec(type: .lightMode),
            IconVariantSpec(type: .darkMode)
        ]
    }
}

// MARK: - Domain Icon Set

/// Complete icon set for a domain (project/package)
/// Contains all variants with proper naming: {Domain}_{variant}
public struct DomainIconSet: Identifiable, Codable, Sendable {
    public var id: String { domain }
    
    public let domain: String           // e.g., "FlowKit", "IdeaKit", "IconKit"
    public let category: String         // e.g., "Project", "Package"
    public var assets: [IconAsset]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        domain: String,
        category: String,
        variants: [IconVariantType] = IconVariantSpec.essentialVariants.map(\.type)
    ) {
        self.domain = domain
        self.category = category
        self.assets = variants.map { IconAsset(domain: domain, variant: $0) }
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    /// Get asset for a specific variant
    public func asset(for variant: IconVariantType) -> IconAsset? {
        assets.first { $0.variant == variant }
    }
    
    /// All asset names: FlowKit_app_icon, FlowKit_toolbar, etc.
    public var allAssetNames: [String] {
        assets.map(\.assetName)
    }
    
    /// Total file count across all variants
    public var totalFileCount: Int {
        assets.reduce(0) { $0 + $1.sizes.count }
    }
    
    /// Mark a variant as generated
    public mutating func markGenerated(variant: IconVariantType, paths: [String]) {
        if let index = assets.firstIndex(where: { $0.variant == variant }) {
            assets[index].isGenerated = true
            assets[index].generatedAt = Date()
            assets[index].filePaths = paths
        }
        updatedAt = Date()
    }
}
