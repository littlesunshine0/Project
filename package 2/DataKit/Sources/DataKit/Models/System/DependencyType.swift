//
//  DependencyType.swift
//  DataKit
//

import Foundation

public enum DependencyType: String, Codable, Sendable, CaseIterable {
    case package, framework, library, plugin, service
}
