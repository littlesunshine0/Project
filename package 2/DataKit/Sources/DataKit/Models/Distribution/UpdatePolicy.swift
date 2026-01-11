//
//  UpdatePolicy.swift
//  DataKit
//

import Foundation

/// Update policy for packages
public struct UpdatePolicy: Codable, Sendable, Hashable {
    public let autoUpdate: Bool
    public let channel: UpdateChannel
    public let minVersion: String?
    public let maxVersion: String?
    public let checkInterval: TimeInterval
    
    public init(autoUpdate: Bool = true, channel: UpdateChannel = .stable, minVersion: String? = nil, maxVersion: String? = nil, checkInterval: TimeInterval = 86400) {
        self.autoUpdate = autoUpdate
        self.channel = channel
        self.minVersion = minVersion
        self.maxVersion = maxVersion
        self.checkInterval = checkInterval
    }
    
    public static let `default` = UpdatePolicy()
    public static let manual = UpdatePolicy(autoUpdate: false)
}

public enum UpdateChannel: String, Codable, Sendable, CaseIterable {
    case stable, beta, alpha, nightly
}
