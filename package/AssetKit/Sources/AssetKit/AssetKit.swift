//
//  AssetKit.swift
//  AssetKit - Intelligent Asset Management
//

import Foundation

// MARK: - Asset

public struct Asset: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let type: AssetType
    public let path: String
    public var tags: [String]
    public var metadata: [String: String]
    public let createdAt: Date
    public var modifiedAt: Date
    public let size: Int64
    
    public init(name: String, type: AssetType, path: String, size: Int64 = 0) {
        self.id = UUID().uuidString
        self.name = name
        self.type = type
        self.path = path
        self.tags = []
        self.metadata = [:]
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.size = size
    }
}

public enum AssetType: String, Sendable, CaseIterable {
    case image, video, audio, document, font, model3d, data, other
}

// MARK: - Asset Collection

public struct AssetCollection: Identifiable, Sendable {
    public let id: String
    public var name: String
    public var assetIds: [String]
    public let createdAt: Date
    
    public init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        self.assetIds = []
        self.createdAt = Date()
    }
}

// MARK: - Asset Library

public actor AssetLibrary {
    public static let shared = AssetLibrary()
    
    private var assets: [String: Asset] = [:]
    private var collections: [String: AssetCollection] = [:]
    private var tagIndex: [String: Set<String>] = [:] // tag -> asset IDs
    
    private init() {}
    
    public func addAsset(name: String, type: AssetType, path: String, size: Int64 = 0) -> Asset {
        let asset = Asset(name: name, type: type, path: path, size: size)
        assets[asset.id] = asset
        return asset
    }
    
    public func getAsset(_ id: String) -> Asset? {
        assets[id]
    }
    
    public func removeAsset(_ id: String) {
        if let asset = assets[id] {
            for tag in asset.tags {
                tagIndex[tag]?.remove(id)
            }
        }
        assets.removeValue(forKey: id)
    }
    
    public func tagAsset(_ id: String, tags: [String]) {
        guard var asset = assets[id] else { return }
        for tag in tags {
            asset.tags.append(tag)
            tagIndex[tag, default: []].insert(id)
        }
        assets[id] = asset
    }
    
    public func getAssets(byType type: AssetType) -> [Asset] {
        assets.values.filter { $0.type == type }
    }
    
    public func getAssets(byTag tag: String) -> [Asset] {
        guard let ids = tagIndex[tag] else { return [] }
        return ids.compactMap { assets[$0] }
    }
    
    public func search(query: String) -> [Asset] {
        let lowercased = query.lowercased()
        return assets.values.filter {
            $0.name.lowercased().contains(lowercased) ||
            $0.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }
    
    public func createCollection(name: String) -> AssetCollection {
        let collection = AssetCollection(name: name)
        collections[collection.id] = collection
        return collection
    }
    
    public func addToCollection(_ collectionId: String, assetId: String) {
        collections[collectionId]?.assetIds.append(assetId)
    }
    
    public func getCollection(_ id: String) -> AssetCollection? {
        collections[id]
    }
    
    public var stats: AssetStats {
        AssetStats(
            totalAssets: assets.count,
            byType: Dictionary(grouping: assets.values, by: { $0.type }).mapValues { $0.count },
            collectionCount: collections.count,
            totalSize: assets.values.reduce(0) { $0 + $1.size }
        )
    }
}

public struct AssetStats: Sendable {
    public let totalAssets: Int
    public let byType: [AssetType: Int]
    public let collectionCount: Int
    public let totalSize: Int64
}
