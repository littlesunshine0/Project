//
//  CompatibilityMatrix.swift
//  DataKit
//

import Foundation

/// Compatibility matrix for packages
public struct CompatibilityMatrix: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let packageId: String
    public let platforms: [PlatformRequirement]
    public let dependencies: [DependencyRequirement]
    public let conflicts: [String]
    public let minAppVersion: String?
    public let maxAppVersion: String?
    
    public init(id: String = UUID().uuidString, packageId: String, platforms: [PlatformRequirement] = [], dependencies: [DependencyRequirement] = [], conflicts: [String] = [], minAppVersion: String? = nil, maxAppVersion: String? = nil) {
        self.id = id
        self.packageId = packageId
        self.platforms = platforms
        self.dependencies = dependencies
        self.conflicts = conflicts
        self.minAppVersion = minAppVersion
        self.maxAppVersion = maxAppVersion
    }
}

public struct PlatformRequirement: Codable, Sendable, Hashable {
    public let platform: Platform
    public let minVersion: String
    
    public init(platform: Platform, minVersion: String) {
        self.platform = platform
        self.minVersion = minVersion
    }
}

public enum Platform: String, Codable, Sendable, CaseIterable {
    case macOS, iOS, iPadOS, visionOS, watchOS, tvOS
}

public struct DependencyRequirement: Codable, Sendable, Hashable {
    public let packageId: String
    public let versionRange: String
    public let isOptional: Bool
    
    public init(packageId: String, versionRange: String, isOptional: Bool = false) {
        self.packageId = packageId
        self.versionRange = versionRange
        self.isOptional = isOptional
    }
}
