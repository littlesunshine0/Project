//
//  IconGenerationService.swift
//  IconKit
//
//  Service for generating icon variants and exports
//  Drop-in ready - works with any project
//

import SwiftUI
import AppKit

/// Icon generation service - creates all variants
public actor IconGenerationService {
    
    public static let shared = IconGenerationService()
    
    private init() {}
    
    // MARK: - Variant Generation
    
    /// Generate all variants for an icon
    @MainActor
    public func generateAllVariants(for icon: StoredIcon) async throws -> [GeneratedVariant] {
        var results: [GeneratedVariant] = []
        
        for variant in icon.variants {
            let generated = try await generateVariant(for: icon, variant: variant)
            results.append(contentsOf: generated)
        }
        
        return results
    }
    
    /// Generate a specific variant
    @MainActor
    public func generateVariant(for icon: StoredIcon, variant: IconVariant) async throws -> [GeneratedVariant] {
        var results: [GeneratedVariant] = []
        
        for size in variant.sizes {
            let image = try renderIcon(icon: icon, variant: variant.type, size: size)
            results.append(GeneratedVariant(
                iconId: icon.id,
                variantType: variant.type,
                size: size,
                image: image,
                format: variant.format
            ))
        }
        
        return results
    }
    
    /// Render icon to NSImage
    @MainActor
    public func renderIcon(icon: StoredIcon, variant: VariantType, size: Int) throws -> NSImage {
        let cgSize = CGFloat(size)
        
        // Create the icon view with appropriate modifiers
        let iconView = IconDesign(style: icon.iconStyle, size: cgSize)
        
        // Apply variant-specific modifications
        let modifiedView: AnyView
        switch variant {
        case .monochrome:
            modifiedView = AnyView(iconView.saturation(0).opacity(0.8))
        case .lineArt:
            modifiedView = AnyView(iconView.saturation(0).contrast(1.5))
        case .dark:
            modifiedView = AnyView(iconView.colorMultiply(.black.opacity(0.3)))
        case .light:
            modifiedView = AnyView(iconView.colorMultiply(.white.opacity(0.1)))
        default:
            modifiedView = AnyView(iconView)
        }
        
        // Render to image
        let renderer = ImageRenderer(content: modifiedView.frame(width: cgSize, height: cgSize))
        renderer.scale = 2.0
        
        guard let cgImage = renderer.cgImage else {
            throw IconGenerationError.renderFailed
        }
        
        return NSImage(cgImage: cgImage, size: NSSize(width: size, height: size))
    }
    
    // MARK: - Export
    
    /// Export icon to PNG file
    @MainActor
    public func exportToPNG(icon: StoredIcon, variant: VariantType, size: Int, path: URL) throws {
        let image = try renderIcon(icon: icon, variant: variant, size: size)
        
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            throw IconGenerationError.exportFailed
        }
        
        try pngData.write(to: path)
    }
    
    /// Export all variants to directory
    @MainActor
    public func exportAllVariants(icon: StoredIcon, directory: URL) throws -> [URL] {
        var exportedFiles: [URL] = []
        
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        
        for variant in icon.variants {
            for size in variant.sizes {
                let filename = "\(icon.name)_\(variant.type.rawValue)_\(size).png"
                let filePath = directory.appendingPathComponent(filename)
                try exportToPNG(icon: icon, variant: variant.type, size: size, path: filePath)
                exportedFiles.append(filePath)
            }
        }
        
        return exportedFiles
    }
}

/// Generated variant result
public struct GeneratedVariant: Sendable {
    public let iconId: String
    public let variantType: VariantType
    public let size: Int
    public let image: NSImage
    public let format: String
    
    public var filename: String {
        "\(iconId)_\(variantType.rawValue)_\(size).\(format)"
    }
}

/// Icon generation errors
public enum IconGenerationError: Error, LocalizedError {
    case renderFailed
    case exportFailed
    case invalidSize
    case unsupportedFormat
    
    public var errorDescription: String? {
        switch self {
        case .renderFailed: return "Failed to render icon"
        case .exportFailed: return "Failed to export icon"
        case .invalidSize: return "Invalid icon size"
        case .unsupportedFormat: return "Unsupported export format"
        }
    }
}
