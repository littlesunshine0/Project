//
//  XCAssetExporter.swift
//  IconKit
//
//  Exports icons to .xcassets format for Xcode
//  Supports all platforms: macOS, iOS, watchOS, tvOS
//

import SwiftUI
import AppKit

/// Exports icons to xcassets format
public class XCAssetExporter {
    
    public init() {}
    
    // MARK: - Project Icon Export
    
    /// Export all variants of a project icon to xcassets
    @MainActor
    public func exportProjectIcon(
        _ iconType: ProjectIconType,
        variants: [IconVariantType] = IconVariantSpec.essentialVariants.map(\.type),
        to outputPath: String
    ) throws -> ExportResult {
        let fileManager = FileManager.default
        var exportedFiles: [String] = []
        var errors: [String] = []
        
        // Create base xcassets folder
        let xcassetsPath = outputPath.hasSuffix(".xcassets") ? outputPath : "\(outputPath)/\(iconType.rawValue).xcassets"
        try fileManager.createDirectory(atPath: xcassetsPath, withIntermediateDirectories: true)
        
        // Write root Contents.json
        let xcassetsContents = """
        {
          "info" : {
            "author" : "IconKit",
            "version" : 1
          }
        }
        """
        try xcassetsContents.write(toFile: "\(xcassetsPath)/Contents.json", atomically: true, encoding: .utf8)
        
        // Export each variant
        for variant in variants {
            do {
                let files = try exportVariant(iconType: iconType, variant: variant, to: xcassetsPath)
                exportedFiles.append(contentsOf: files)
            } catch {
                errors.append("\(variant.displayName): \(error.localizedDescription)")
            }
        }
        
        return ExportResult(
            totalFiles: exportedFiles.count,
            exportedFiles: exportedFiles,
            errors: errors,
            outputPath: xcassetsPath
        )
    }
    
    /// Export a specific variant of a project icon
    @MainActor
    public func exportVariant(
        iconType: ProjectIconType,
        variant: IconVariantType,
        to xcassetsPath: String
    ) throws -> [String] {
        var exportedFiles: [String] = []
        
        // Determine if this is an app icon or image set
        let isAppIcon = [.appIcon, .appIconMac, .appIconIOS, .appIconWatch, .appIconTV].contains(variant)
        
        if isAppIcon {
            let files = try exportAppIconVariant(iconType: iconType, variant: variant, to: xcassetsPath)
            exportedFiles.append(contentsOf: files)
        } else {
            let files = try exportImageSetVariant(iconType: iconType, variant: variant, to: xcassetsPath)
            exportedFiles.append(contentsOf: files)
        }
        
        return exportedFiles
    }
    
    /// Export app icon variant (appiconset)
    @MainActor
    private func exportAppIconVariant(
        iconType: ProjectIconType,
        variant: IconVariantType,
        to xcassetsPath: String
    ) throws -> [String] {
        let fileManager = FileManager.default
        var exportedFiles: [String] = []
        
        let setName = "\(iconType.rawValue)_\(variant.rawValue)"
        let appiconsetPath = "\(xcassetsPath)/\(setName).appiconset"
        
        try fileManager.createDirectory(atPath: appiconsetPath, withIntermediateDirectories: true)
        
        // Get platform-specific sizes
        let sizes = appIconSizes(for: variant)
        var images: [[String: Any]] = []
        
        for sizeConfig in sizes {
            let filename = "icon_\(Int(sizeConfig.size))x\(Int(sizeConfig.size))\(sizeConfig.suffix).png"
            let actualSize = sizeConfig.size * CGFloat(sizeConfig.scale)
            
            try generateProjectIconPNG(
                iconType: iconType,
                variant: variant,
                size: actualSize,
                outputPath: "\(appiconsetPath)/\(filename)"
            )
            
            images.append([
                "filename": filename,
                "idiom": sizeConfig.idiom,
                "scale": "\(sizeConfig.scale)x",
                "size": "\(Int(sizeConfig.size))x\(Int(sizeConfig.size))"
            ])
            
            exportedFiles.append(filename)
        }
        
        // Write Contents.json
        let contents: [String: Any] = [
            "images": images,
            "info": ["author": "IconKit", "version": 1]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
        try jsonData.write(to: URL(fileURLWithPath: "\(appiconsetPath)/Contents.json"))
        
        return exportedFiles
    }
    
    /// Export image set variant (imageset)
    @MainActor
    private func exportImageSetVariant(
        iconType: ProjectIconType,
        variant: IconVariantType,
        to xcassetsPath: String
    ) throws -> [String] {
        let fileManager = FileManager.default
        var exportedFiles: [String] = []
        
        let setName = "\(iconType.rawValue)_\(variant.rawValue)"
        let imagesetPath = "\(xcassetsPath)/\(setName).imageset"
        
        try fileManager.createDirectory(atPath: imagesetPath, withIntermediateDirectories: true)
        
        // Generate at standard sizes
        let sizes = variant.defaultSizes
        var images: [[String: Any]] = []
        
        for size in sizes {
            let filename = "\(setName)_\(size).png"
            
            try generateProjectIconPNG(
                iconType: iconType,
                variant: variant,
                size: CGFloat(size),
                outputPath: "\(imagesetPath)/\(filename)"
            )
            
            images.append([
                "filename": filename,
                "idiom": "universal"
            ])
            
            exportedFiles.append(filename)
        }
        
        // Write Contents.json
        let contents: [String: Any] = [
            "images": images,
            "info": ["author": "IconKit", "version": 1]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
        try jsonData.write(to: URL(fileURLWithPath: "\(imagesetPath)/Contents.json"))
        
        return exportedFiles
    }
    
    /// Generate PNG for project icon
    @MainActor
    private func generateProjectIconPNG(
        iconType: ProjectIconType,
        variant: IconVariantType,
        size: CGFloat,
        outputPath: String
    ) throws {
        let view = iconType.icon(size: size, variant: variant)
        
        let hosting = NSHostingView(rootView: AnyView(view))
        hosting.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        guard let bitmapRep = hosting.bitmapImageRepForCachingDisplay(in: hosting.bounds) else {
            throw ExportError.bitmapCreationFailed
        }
        
        hosting.cacheDisplay(in: hosting.bounds, to: bitmapRep)
        
        guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            throw ExportError.pngConversionFailed
        }
        
        try pngData.write(to: URL(fileURLWithPath: outputPath))
    }
    
    // MARK: - Platform Size Configurations
    
    private func appIconSizes(for variant: IconVariantType) -> [AppIconSizeConfig] {
        switch variant {
        case .appIconMac, .appIcon:
            return [
                AppIconSizeConfig(size: 16, scale: 1, idiom: "mac"),
                AppIconSizeConfig(size: 16, scale: 2, suffix: "@2x", idiom: "mac"),
                AppIconSizeConfig(size: 32, scale: 1, idiom: "mac"),
                AppIconSizeConfig(size: 32, scale: 2, suffix: "@2x", idiom: "mac"),
                AppIconSizeConfig(size: 128, scale: 1, idiom: "mac"),
                AppIconSizeConfig(size: 128, scale: 2, suffix: "@2x", idiom: "mac"),
                AppIconSizeConfig(size: 256, scale: 1, idiom: "mac"),
                AppIconSizeConfig(size: 256, scale: 2, suffix: "@2x", idiom: "mac"),
                AppIconSizeConfig(size: 512, scale: 1, idiom: "mac"),
                AppIconSizeConfig(size: 512, scale: 2, suffix: "@2x", idiom: "mac")
            ]
        case .appIconIOS:
            return [
                AppIconSizeConfig(size: 20, scale: 2, suffix: "@2x", idiom: "iphone"),
                AppIconSizeConfig(size: 20, scale: 3, suffix: "@3x", idiom: "iphone"),
                AppIconSizeConfig(size: 29, scale: 2, suffix: "@2x", idiom: "iphone"),
                AppIconSizeConfig(size: 29, scale: 3, suffix: "@3x", idiom: "iphone"),
                AppIconSizeConfig(size: 40, scale: 2, suffix: "@2x", idiom: "iphone"),
                AppIconSizeConfig(size: 40, scale: 3, suffix: "@3x", idiom: "iphone"),
                AppIconSizeConfig(size: 60, scale: 2, suffix: "@2x", idiom: "iphone"),
                AppIconSizeConfig(size: 60, scale: 3, suffix: "@3x", idiom: "iphone"),
                AppIconSizeConfig(size: 20, scale: 1, idiom: "ipad"),
                AppIconSizeConfig(size: 20, scale: 2, suffix: "@2x", idiom: "ipad"),
                AppIconSizeConfig(size: 29, scale: 1, idiom: "ipad"),
                AppIconSizeConfig(size: 29, scale: 2, suffix: "@2x", idiom: "ipad"),
                AppIconSizeConfig(size: 40, scale: 1, idiom: "ipad"),
                AppIconSizeConfig(size: 40, scale: 2, suffix: "@2x", idiom: "ipad"),
                AppIconSizeConfig(size: 76, scale: 1, idiom: "ipad"),
                AppIconSizeConfig(size: 76, scale: 2, suffix: "@2x", idiom: "ipad"),
                AppIconSizeConfig(size: 83.5, scale: 2, suffix: "@2x", idiom: "ipad"),
                AppIconSizeConfig(size: 1024, scale: 1, idiom: "ios-marketing")
            ]
        case .appIconWatch:
            return [
                AppIconSizeConfig(size: 24, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 27.5, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 29, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 29, scale: 3, suffix: "@3x", idiom: "watch"),
                AppIconSizeConfig(size: 40, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 44, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 50, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 86, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 98, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 108, scale: 2, suffix: "@2x", idiom: "watch"),
                AppIconSizeConfig(size: 1024, scale: 1, idiom: "watch-marketing")
            ]
        case .appIconTV:
            return [
                AppIconSizeConfig(size: 400, scale: 1, idiom: "tv"),
                AppIconSizeConfig(size: 400, scale: 2, suffix: "@2x", idiom: "tv"),
                AppIconSizeConfig(size: 1280, scale: 1, idiom: "tv")
            ]
        default:
            return []
        }
    }
    
    private struct AppIconSizeConfig {
        let size: CGFloat
        let scale: Int
        var suffix: String = ""
        let idiom: String
    }
    
    // MARK: - Export Methods
    
    /// Export multiple icons to xcassets
    @MainActor
    public func export(icons: [IconDefinition], to outputPath: String) throws {
        let fileManager = FileManager.default
        
        // Create base xcassets folder if needed
        let xcassetsPath = outputPath.hasSuffix(".xcassets") ? outputPath : "\(outputPath)/Icons.xcassets"
        try fileManager.createDirectory(atPath: xcassetsPath, withIntermediateDirectories: true)
        
        // Write Contents.json for xcassets
        let xcassetsContents = """
        {
          "info" : {
            "author" : "IconKit",
            "version" : 1
          }
        }
        """
        try xcassetsContents.write(toFile: "\(xcassetsPath)/Contents.json", atomically: true, encoding: .utf8)
        
        // Export each icon
        for icon in icons {
            try exportIcon(icon, to: xcassetsPath)
        }
    }
    
    /// Export a single icon definition
    @MainActor
    public func exportIcon(_ icon: IconDefinition, to xcassetsPath: String) throws {
        let fileManager = FileManager.default
        let imagesetPath = "\(xcassetsPath)/\(icon.filename).imageset"
        
        // Create imageset folder
        try fileManager.createDirectory(atPath: imagesetPath, withIntermediateDirectories: true)
        
        // Generate icons at different sizes
        let sizes = IconSizeConfig.imageAsset
        var images: [[String: Any]] = []
        
        for config in sizes {
            let actualSize = config.size * CGFloat(config.scale)
            let filename = "\(icon.filename)\(config.suffix).png"
            
            // Generate the icon
            try generatePNG(
                for: icon,
                size: actualSize,
                outputPath: "\(imagesetPath)/\(filename)"
            )
            
            // Add to Contents.json
            images.append([
                "filename": filename,
                "idiom": "universal",
                "scale": "\(config.scale)x"
            ])
        }
        
        // Write Contents.json
        let contents: [String: Any] = [
            "images": images,
            "info": [
                "author": "IconKit",
                "version": 1
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
        try jsonData.write(to: URL(fileURLWithPath: "\(imagesetPath)/Contents.json"))
    }
    
    /// Export app icon set (all required sizes)
    @MainActor
    public func exportAppIcon(_ icon: IconDefinition, to xcassetsPath: String) throws {
        let fileManager = FileManager.default
        let appiconsetPath = "\(xcassetsPath)/AppIcon.appiconset"
        
        // Create appiconset folder
        try fileManager.createDirectory(atPath: appiconsetPath, withIntermediateDirectories: true)
        
        // Generate all app icon sizes
        let sizes = IconSizeConfig.macOSAppIcon
        var images: [[String: Any]] = []
        
        for config in sizes {
            let actualSize = config.size * CGFloat(config.scale)
            let filename = "icon_\(Int(config.size))x\(Int(config.size))\(config.suffix).png"
            
            try generatePNG(
                for: icon,
                size: actualSize,
                outputPath: "\(appiconsetPath)/\(filename)"
            )
            
            images.append([
                "filename": filename,
                "idiom": "mac",
                "scale": "\(config.scale)x",
                "size": "\(Int(config.size))x\(Int(config.size))"
            ])
        }
        
        // Write Contents.json
        let contents: [String: Any] = [
            "images": images,
            "info": [
                "author": "IconKit",
                "version": 1
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: contents, options: .prettyPrinted)
        try jsonData.write(to: URL(fileURLWithPath: "\(appiconsetPath)/Contents.json"))
    }
    
    // MARK: - PNG Generation
    
    @MainActor
    private func generatePNG(for icon: IconDefinition, size: CGFloat, outputPath: String) throws {
        let view = IconDesign(
            style: icon.style,
            size: size,
            colors: icon.colors,
            label: icon.label
        )
        
        let hosting = NSHostingView(rootView: view)
        hosting.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        guard let bitmapRep = hosting.bitmapImageRepForCachingDisplay(in: hosting.bounds) else {
            throw ExportError.bitmapCreationFailed
        }
        
        hosting.cacheDisplay(in: hosting.bounds, to: bitmapRep)
        
        guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            throw ExportError.pngConversionFailed
        }
        
        try pngData.write(to: URL(fileURLWithPath: outputPath))
    }
    
    // MARK: - Batch Export
    
    /// Export all icons for a project
    @MainActor
    public func exportProjectIcons(
        projectName: String,
        packages: [String],
        features: [String],
        services: [String],
        modules: [String],
        to outputPath: String
    ) throws {
        var icons: [IconDefinition] = []
        
        // Project icon
        icons.append(IconDefinition(
            name: projectName,
            category: .project,
            style: .glowOrb
        ))
        
        // Package icons
        for pkg in packages {
            icons.append(IconDefinition(
                name: pkg,
                category: .package,
                style: .cube
            ))
        }
        
        // Feature icons
        for feature in features {
            icons.append(IconDefinition(
                name: feature,
                category: .feature,
                style: .star
            ))
        }
        
        // Service icons
        for service in services {
            icons.append(IconDefinition(
                name: service,
                category: .service,
                style: .gear
            ))
        }
        
        // Module icons
        for module in modules {
            icons.append(IconDefinition(
                name: module,
                category: .module,
                style: .layers
            ))
        }
        
        try export(icons: icons, to: outputPath)
    }
    
    /// Export capability icons
    @MainActor
    public func exportCapabilityIcons(to outputPath: String) throws {
        let capabilities = ["intent", "context", "structure", "work", "decisions", "risk", "feedback", "outcome"]
        let styles: [IconStyle] = [.lightbulb, .layers, .grid, .gear, .diamond, .badge, .circuit, .star]
        
        var icons: [IconDefinition] = []
        
        for (index, cap) in capabilities.enumerated() {
            icons.append(IconDefinition(
                id: "capability_\(cap)",
                name: cap.capitalized,
                category: .capability,
                style: styles[index],
                label: cap.prefix(2).uppercased()
            ))
        }
        
        try export(icons: icons, to: outputPath)
    }
}

// MARK: - Export Errors

public enum ExportError: Error, LocalizedError {
    case bitmapCreationFailed
    case pngConversionFailed
    case directoryCreationFailed
    case writeError(String)
    
    public var errorDescription: String? {
        switch self {
        case .bitmapCreationFailed:
            return "Failed to create bitmap representation"
        case .pngConversionFailed:
            return "Failed to convert to PNG format"
        case .directoryCreationFailed:
            return "Failed to create output directory"
        case .writeError(let path):
            return "Failed to write file: \(path)"
        }
    }
}
