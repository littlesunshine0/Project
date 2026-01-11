//
//  VersionModel.swift
//  DataKit
//

import Foundation

/// Version model
public struct VersionModel: Codable, Sendable, Hashable, Comparable {
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let prerelease: String?
    public let build: String?
    
    public init(major: Int, minor: Int, patch: Int, prerelease: String? = nil, build: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = prerelease
        self.build = build
    }
    
    public init?(string: String) {
        let parts = string.split(separator: ".")
        guard parts.count >= 3,
              let major = Int(parts[0]),
              let minor = Int(parts[1]),
              let patch = Int(parts[2]) else { return nil }
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = nil
        self.build = nil
    }
    
    public var string: String {
        var result = "\(major).\(minor).\(patch)"
        if let pre = prerelease { result += "-\(pre)" }
        if let b = build { result += "+\(b)" }
        return result
    }
    
    public static func < (lhs: VersionModel, rhs: VersionModel) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}
