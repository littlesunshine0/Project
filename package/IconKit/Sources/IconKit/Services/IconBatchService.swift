//
//  IconBatchService.swift
//  IconKit
//
//  Batch operations for icons - import, export, process
//  Drop-in ready - works with any project
//

import Foundation
import SwiftUI

/// Batch operations service
public actor IconBatchService {
    
    public static let shared = IconBatchService()
    
    private init() {}
    
    // MARK: - Batch Export
    
    /// Export all icons to xcassets
    @MainActor
    public func exportAllToXCAssets(outputPath: String) async throws -> BatchResult {
        let storage = IconStorageService.shared
        try await storage.initialize()
        let icons = await storage.fetchAll()
        
        var exported = 0
        var failed = 0
        var errors: [String] = []
        
        let exporter = XCAssetExporter()
        
        for icon in icons {
            do {
                try exporter.exportIcon(icon.definition, to: outputPath)
                exported += 1
            } catch {
                failed += 1
                errors.append("\(icon.name): \(error.localizedDescription)")
            }
        }
        
        return BatchResult(
            total: icons.count,
            succeeded: exported,
            failed: failed,
            errors: errors
        )
    }
    
    /// Export icons by category
    @MainActor
    public func exportCategory(_ category: IconKit.IconCategory, outputPath: String) async throws -> BatchResult {
        let storage = IconStorageService.shared
        try await storage.initialize()
        let icons = await storage.fetch(category: category)
        
        var exported = 0
        var failed = 0
        var errors: [String] = []
        
        let exporter = XCAssetExporter()
        
        for icon in icons {
            do {
                try exporter.exportIcon(icon.definition, to: outputPath)
                exported += 1
            } catch {
                failed += 1
                errors.append("\(icon.name): \(error.localizedDescription)")
            }
        }
        
        return BatchResult(
            total: icons.count,
            succeeded: exported,
            failed: failed,
            errors: errors
        )
    }
    
    // MARK: - Batch Import
    
    /// Import icons from JSON file
    public func importFromJSON(path: URL) async throws -> BatchResult {
        let data = try Data(contentsOf: path)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let icons = try decoder.decode([StoredIcon].self, from: data)
        
        var imported = 0
        var failed = 0
        var errors: [String] = []
        
        let storage = IconStorageService.shared
        try await storage.initialize()
        
        for icon in icons {
            do {
                try await storage.save(icon)
                imported += 1
            } catch {
                failed += 1
                errors.append("\(icon.name): \(error.localizedDescription)")
            }
        }
        
        return BatchResult(
            total: icons.count,
            succeeded: imported,
            failed: failed,
            errors: errors
        )
    }
    
    /// Export all icons to JSON
    public func exportToJSON(path: URL) async throws {
        let storage = IconStorageService.shared
        try await storage.initialize()
        let data = try await storage.exportJSON()
        try data.write(to: path)
    }
    
    // MARK: - Batch Generation
    
    /// Generate all variants for all icons
    @MainActor
    public func generateAllVariants(outputDirectory: URL) async throws -> BatchResult {
        let storage = IconStorageService.shared
        try await storage.initialize()
        let icons = await storage.fetchAll()
        
        var generated = 0
        var failed = 0
        var errors: [String] = []
        
        let generator = IconGenerationService.shared
        
        for icon in icons {
            do {
                let iconDir = outputDirectory.appendingPathComponent(icon.name)
                _ = try generator.exportAllVariants(icon: icon, directory: iconDir)
                generated += 1
            } catch {
                failed += 1
                errors.append("\(icon.name): \(error.localizedDescription)")
            }
        }
        
        return BatchResult(
            total: icons.count,
            succeeded: generated,
            failed: failed,
            errors: errors
        )
    }
    
    // MARK: - Batch Operations
    
    /// Add tag to multiple icons
    public func addTag(_ tag: String, to iconIds: [String]) async throws -> BatchResult {
        let storage = IconStorageService.shared
        try await storage.initialize()
        
        var updated = 0
        var failed = 0
        var errors: [String] = []
        
        for id in iconIds {
            if var icon = await storage.fetch(id: id) {
                if !icon.tags.contains(tag) {
                    icon.tags.append(tag)
                    do {
                        try await storage.save(icon)
                        updated += 1
                    } catch {
                        failed += 1
                        errors.append("\(icon.name): \(error.localizedDescription)")
                    }
                }
            } else {
                failed += 1
                errors.append("Icon not found: \(id)")
            }
        }
        
        return BatchResult(
            total: iconIds.count,
            succeeded: updated,
            failed: failed,
            errors: errors
        )
    }
    
    /// Remove tag from multiple icons
    public func removeTag(_ tag: String, from iconIds: [String]) async throws -> BatchResult {
        let storage = IconStorageService.shared
        try await storage.initialize()
        
        var updated = 0
        var failed = 0
        var errors: [String] = []
        
        for id in iconIds {
            if var icon = await storage.fetch(id: id) {
                if let index = icon.tags.firstIndex(of: tag) {
                    icon.tags.remove(at: index)
                    do {
                        try await storage.save(icon)
                        updated += 1
                    } catch {
                        failed += 1
                        errors.append("\(icon.name): \(error.localizedDescription)")
                    }
                }
            } else {
                failed += 1
                errors.append("Icon not found: \(id)")
            }
        }
        
        return BatchResult(
            total: iconIds.count,
            succeeded: updated,
            failed: failed,
            errors: errors
        )
    }
    
    /// Delete multiple icons
    public func deleteIcons(_ iconIds: [String]) async throws -> BatchResult {
        let storage = IconStorageService.shared
        try await storage.initialize()
        
        var deleted = 0
        var failed = 0
        var errors: [String] = []
        
        for id in iconIds {
            do {
                try await storage.delete(id: id)
                deleted += 1
            } catch {
                failed += 1
                errors.append("Failed to delete: \(id)")
            }
        }
        
        return BatchResult(
            total: iconIds.count,
            succeeded: deleted,
            failed: failed,
            errors: errors
        )
    }
}

/// Batch operation result
public struct BatchResult: Sendable {
    public let total: Int
    public let succeeded: Int
    public let failed: Int
    public let errors: [String]
    
    public var successRate: Double {
        guard total > 0 else { return 0 }
        return Double(succeeded) / Double(total) * 100
    }
    
    public var summary: String {
        "\(succeeded)/\(total) succeeded (\(String(format: "%.1f", successRate))%)"
    }
}
