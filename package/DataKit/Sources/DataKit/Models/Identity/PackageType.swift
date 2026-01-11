//
//  PackageType.swift
//  DataKit
//

import Foundation

public enum PackageType: String, Codable, Sendable, CaseIterable {
    case library, framework, application, service, tool
}
