//
//  PackageKind.swift
//  DataKit
//

import Foundation

public enum PackageKind: String, Codable, Sendable, CaseIterable {
    case standard, plugin, `extension`, theme, template, bridge
}
