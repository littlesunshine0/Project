//
//  PackageCapability.swift
//  DataKit
//

import Foundation

/// Package capability declaration
public protocol PackageCapability {
    var id: String { get }
    var name: String { get }
    var isEnabled: Bool { get }
    var requirements: [String] { get }
}
