//
//  IconDefinition.swift
//  IconKit
//
//  Defines icon metadata and configuration
//

import SwiftUI

/// Definition of an icon for generation and export
public struct IconDefinition: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let category: IconKit.IconCategory
    public let style: IconStyle
    public let colors: [Color]?
    public let label: String?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        category: IconKit.IconCategory,
        style: IconStyle? = nil,
        colors: [Color]? = nil,
        label: String? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.style = style ?? category.defaultIcon
        self.colors = colors
        self.label = label
    }
    
    /// Filename for export
    public var filename: String {
        "\(category.rawValue.lowercased())_\(name.lowercased().replacingOccurrences(of: " ", with: "_"))"
    }
}

/// Icon size configuration for export
public struct IconSizeConfig: Sendable {
    public let size: CGFloat
    public let scale: Int
    public let suffix: String
    
    public init(size: CGFloat, scale: Int = 1, suffix: String = "") {
        self.size = size
        self.scale = scale
        self.suffix = suffix
    }
    
    /// Standard macOS app icon sizes
    public static let macOSAppIcon: [IconSizeConfig] = [
        IconSizeConfig(size: 16, scale: 1),
        IconSizeConfig(size: 16, scale: 2, suffix: "@2x"),
        IconSizeConfig(size: 32, scale: 1),
        IconSizeConfig(size: 32, scale: 2, suffix: "@2x"),
        IconSizeConfig(size: 128, scale: 1),
        IconSizeConfig(size: 128, scale: 2, suffix: "@2x"),
        IconSizeConfig(size: 256, scale: 1),
        IconSizeConfig(size: 256, scale: 2, suffix: "@2x"),
        IconSizeConfig(size: 512, scale: 1),
        IconSizeConfig(size: 512, scale: 2, suffix: "@2x")
    ]
    
    /// Standard image asset sizes
    public static let imageAsset: [IconSizeConfig] = [
        IconSizeConfig(size: 64, scale: 1),
        IconSizeConfig(size: 128, scale: 2, suffix: "@2x"),
        IconSizeConfig(size: 192, scale: 3, suffix: "@3x")
    ]
    
    /// Single high-res export
    public static let highRes: [IconSizeConfig] = [
        IconSizeConfig(size: 1024, scale: 1)
    ]
}

/// Icon export format
public enum IconExportFormat: String, Sendable {
    case png = "png"
    case pdf = "pdf"
    case svg = "svg"
}

/// Icon set for a complete entity (all sizes)
public struct IconSet: Identifiable, Sendable {
    public let id: String
    public let definition: IconDefinition
    public let sizes: [IconSizeConfig]
    public let format: IconExportFormat
    
    public init(
        definition: IconDefinition,
        sizes: [IconSizeConfig] = IconSizeConfig.imageAsset,
        format: IconExportFormat = .png
    ) {
        self.id = definition.id
        self.definition = definition
        self.sizes = sizes
        self.format = format
    }
}
