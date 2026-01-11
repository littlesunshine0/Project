//
//  PackageContractProtocol.swift
//  DataKit
//

import Foundation

/// Protocol for packages to conform to for orchestrator integration
/// Note: PackageContract struct is defined in PackageSchemas.swift for data representation
public protocol PackageContractProtocol {
    static var packageId: String { get }
    static var manifest: PackageManifest { get }
    static var capabilities: [String] { get }
}
