//
//  IconStorageService.swift
//  IconKit
//
//  Persistent storage service for icons
//  Drop-in ready - works with any project
//

import Foundation
import SwiftUI

/// Stored icon with full metadata
public struct StoredIcon: Identifiable, Codable, Sendable {
    public let id: String
    public var name: String
    public var category: String
    public var style: String
    public var description: String
    public var tags: [String]
    public var colors: [String]
    public var variants: [IconVariant]
    public var createdAt: Date
    public var updatedAt: Date
    public var isCustom: Bool
    public var metadata: [String: String]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        category: IconKit.IconCategory,
        style: IconStyle,
        description: String = "",
        tags: [String] = [],
        colors: [String] = [],
        variants: [IconVariant] = IconVariant.defaultVariants,
        isCustom: Bool = false,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.name = name
        self.category = category.rawValue
        self.style = style.rawValue
        self.description = description
        self.tags = tags
        self.colors = colors
        self.variants = variants
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isCustom = isCustom
        self.metadata = metadata
    }
    
    public var definition: IconDefinition {
        IconDefinition(
            id: id,
            name: name,
            category: iconCategory,
            style: iconStyle,
            colors: swiftUIColors,
            label: String(name.prefix(2)).uppercased()
        )
    }
    
    public var iconCategory: IconKit.IconCategory {
        IconKit.IconCategory(rawValue: category) ?? .module
    }
    
    public var iconStyle: IconStyle {
        IconStyle(rawValue: style) ?? .cube
    }
    
    public var swiftUIColors: [Color]? {
        guard !colors.isEmpty else { return nil }
        return colors.compactMap { Color(hex: $0) }
    }
    
    public mutating func touch() {
        updatedAt = Date()
    }
}

/// Icon variant types
public struct IconVariant: Codable, Sendable, Identifiable {
    public var id: String { type.rawValue }
    public let type: VariantType
    public var sizes: [Int]
    public var format: String
    public var isGenerated: Bool
    public var generatedAt: Date?
    
    public init(type: VariantType, sizes: [Int] = [64, 128, 256, 512, 1024], format: String = "png", isGenerated: Bool = false) {
        self.type = type
        self.sizes = sizes
        self.format = format
        self.isGenerated = isGenerated
        self.generatedAt = nil
    }
    
    public static let defaultVariants: [IconVariant] = [
        IconVariant(type: .appIcon, sizes: [16, 32, 64, 128, 256, 512, 1024]),
        IconVariant(type: .filled, sizes: [64, 128, 256]),
        IconVariant(type: .lineArt, sizes: [64, 128, 256]),
        IconVariant(type: .monochrome, sizes: [64, 128, 256]),
        IconVariant(type: .thumbnail, sizes: [32, 64])
    ]
}

public enum VariantType: String, Codable, Sendable, CaseIterable {
    case appIcon = "app_icon"
    case filled = "filled"
    case lineArt = "line_art"
    case monochrome = "monochrome"
    case thumbnail = "thumbnail"
    case dark = "dark"
    case light = "light"
    
    public var displayName: String {
        switch self {
        case .appIcon: return "App Icon"
        case .filled: return "Filled"
        case .lineArt: return "Line Art"
        case .monochrome: return "Monochrome"
        case .thumbnail: return "Thumbnail"
        case .dark: return "Dark Mode"
        case .light: return "Light Mode"
        }
    }
}

/// Icon storage service - persistent database
public actor IconStorageService {
    
    public static let shared = IconStorageService()
    
    private var icons: [String: StoredIcon] = [:]
    private var isInitialized = false
    private let storagePath: URL
    
    private init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let iconDir = appSupport.appendingPathComponent("IconKit", isDirectory: true)
        try? FileManager.default.createDirectory(at: iconDir, withIntermediateDirectories: true)
        self.storagePath = iconDir.appendingPathComponent("icons.json")
    }
    
    // MARK: - Initialization
    
    public func initialize() throws {
        guard !isInitialized else { return }
        isInitialized = true
        
        if FileManager.default.fileExists(atPath: storagePath.path) {
            try loadFromDisk()
        } else {
            createDefaultIcons()
            try saveToDisk()
        }
    }
    
    private func createDefaultIcons() {
        // FlowKit Project
        addIcon(StoredIcon(
            id: "flowkit_app", name: "FlowKit", category: .project, style: .glowOrb,
            description: "Main FlowKit application - warm glowing orb",
            tags: ["app", "main", "project"], colors: ["#FF9933", "#E64D80", "#9933E6"]
        ))
        
        // IdeaKit Package
        addIcon(StoredIcon(
            id: "ideakit_pkg", name: "IdeaKit", category: .package, style: .lightbulb,
            description: "Project Operating System - transforms intent into outcomes",
            tags: ["package", "ideas", "reasoning"], colors: ["#FFD700", "#FFA500"]
        ))
        
        // IconKit Package
        addIcon(StoredIcon(
            id: "iconkit_pkg", name: "IconKit", category: .package, style: .hexagon,
            description: "Universal Icon System - generation, storage, export",
            tags: ["package", "icons", "design"], colors: ["#00CED1", "#20B2AA"]
        ))
        
        // 8 Universal Capabilities
        let caps: [(String, String, IconStyle, String)] = [
            ("Intent", "Why this exists", .lightbulb, "#FFD700"),
            ("Context", "Constraints & environment", .layers, "#3498DB"),
            ("Structure", "How it's organized", .grid, "#9B59B6"),
            ("Work", "What actions happen", .gear, "#2ECC71"),
            ("Decisions", "Why choices were made", .diamond, "#E67E22"),
            ("Risk", "What could go wrong", .badge, "#E74C3C"),
            ("Feedback", "How learning happens", .circuit, "#00BCD4"),
            ("Outcome", "What done means", .star, "#27AE60")
        ]
        for (name, desc, style, color) in caps {
            addIcon(StoredIcon(
                id: "cap_\(name.lowercased())", name: name, category: .capability, style: style,
                description: desc, tags: ["capability", "universal"], colors: [color]
            ))
        }
        
        // 16 Utility Packages
        let utils: [(String, String, IconStyle, String)] = [
            ("IDUtility", "Stable identity", .diamond, "#9B59B6"),
            ("GraphUtility", "Relationships", .circuit, "#3498DB"),
            ("VersioningUtility", "Change tracking", .layers, "#2ECC71"),
            ("SchemaUtility", "Structure validation", .grid, "#E74C3C"),
            ("SerializationUtility", "Data transform", .gear, "#F39C12"),
            ("TemplateUtility", "Output rendering", .star, "#1ABC9C"),
            ("ScoringUtility", "Comparison", .badge, "#E91E63"),
            ("HeuristicUtility", "Rules of thumb", .brain, "#9C27B0"),
            ("DiffUtility", "Change detection", .layers, "#00BCD4"),
            ("LoggingUtility", "Event capture", .stack, "#607D8B"),
            ("MetricsUtility", "Progress measurement", .gradient, "#FF5722"),
            ("FeedbackUtility", "Signal ingestion", .circuit, "#8BC34A"),
            ("ConstraintUtility", "Boundary enforcement", .badge, "#FF9800"),
            ("ValidationUtility", "Correctness checks", .gear, "#795548"),
            ("MemoryUtility", "Knowledge persistence", .brain, "#673AB7"),
            ("SimilarityUtility", "Pattern matching", .spark, "#03A9F4")
        ]
        for (name, desc, style, color) in utils {
            addIcon(StoredIcon(
                id: "util_\(name.lowercased())", name: name, category: .module, style: style,
                description: desc, tags: ["utility", "core"], colors: [color],
                metadata: ["type": "utility"]
            ))
        }
    }
    
    private func addIcon(_ icon: StoredIcon) {
        icons[icon.id] = icon
    }
    
    // MARK: - CRUD
    
    public func fetchAll() -> [StoredIcon] {
        Array(icons.values).sorted { $0.name < $1.name }
    }
    
    public func fetch(id: String) -> StoredIcon? {
        icons[id]
    }
    
    public func fetch(category: IconKit.IconCategory) -> [StoredIcon] {
        icons.values.filter { $0.category == category.rawValue }.sorted { $0.name < $1.name }
    }
    
    public func fetch(tag: String) -> [StoredIcon] {
        icons.values.filter { $0.tags.contains(tag) }.sorted { $0.name < $1.name }
    }
    
    public func search(query: String) -> [StoredIcon] {
        let q = query.lowercased()
        return icons.values.filter {
            $0.name.lowercased().contains(q) ||
            $0.description.lowercased().contains(q) ||
            $0.tags.contains { $0.lowercased().contains(q) }
        }.sorted { $0.name < $1.name }
    }
    
    public func save(_ icon: StoredIcon) throws {
        var mutable = icon
        mutable.touch()
        icons[icon.id] = mutable
        try saveToDisk()
    }
    
    public func delete(id: String) throws {
        icons.removeValue(forKey: id)
        try saveToDisk()
    }
    
    public func count() -> Int { icons.count }
    
    // MARK: - Persistence
    
    private func saveToDisk() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(Array(icons.values))
        try data.write(to: storagePath)
    }
    
    private func loadFromDisk() throws {
        let data = try Data(contentsOf: storagePath)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let loaded = try decoder.decode([StoredIcon].self, from: data)
        icons = Dictionary(uniqueKeysWithValues: loaded.map { ($0.id, $0) })
    }
    
    public func exportJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(Array(icons.values))
    }
    
    public func importJSON(_ data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let imported = try decoder.decode([StoredIcon].self, from: data)
        for icon in imported { icons[icon.id] = icon }
        try saveToDisk()
    }
    
    public func reset() throws {
        icons.removeAll()
        isInitialized = false
        try initialize()
    }
}

// MARK: - Color Extension

extension Color {
    public init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
