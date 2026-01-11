//
//  ConstraintType.swift
//  DataKit
//

import Foundation

public enum ConstraintType: String, Codable, Sendable, CaseIterable {
    case minVersion, maxVersion, platform, feature, permission, resource
}
