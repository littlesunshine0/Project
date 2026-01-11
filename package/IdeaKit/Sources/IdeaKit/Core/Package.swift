//
//  Package.swift
//  IdeaKit - Project Operating System
//
//  Base protocol for capability packages
//  Each package owns its logic, emits standardized artifacts, and can be reused
//

import Foundation

/// Protocol for capability packages
/// A package represents a capability, not a document
public protocol CapabilityPackage: Sendable {
    /// Unique identifier for this package
    static var packageId: String { get }
    
    /// Human-readable name
    static var name: String { get }
    
    /// Description of what this package does
    static var description: String { get }
    
    /// Version of this package
    static var version: String { get }
    
    /// Artifact types this package produces
    static var produces: [String] { get }
    
    /// Artifact types this package consumes
    static var consumes: [String] { get }
    
    /// Whether this package is a kernel (always-on) package
    static var isKernel: Bool { get }
    
    /// Execute the package logic
    func execute(graph: ArtifactGraph, context: ProjectContext) async throws
}

// MARK: - Default Implementation

extension CapabilityPackage {
    public static var isKernel: Bool { false }
    public static var version: String { "1.0.0" }
}

// MARK: - Package Registry

/// Registry of all available packages
public actor PackageRegistry {
    
    public static let shared = PackageRegistry()
    
    private var packages: [String: any CapabilityPackage.Type] = [:]
    
    private init() {
        // Kernel packages are registered lazily on first access
    }
    
    /// Ensure kernel packages are registered
    public func ensureKernelPackagesRegistered() {
        if packages.isEmpty {
            packages[IntentPackage.packageId] = IntentPackage.self
            packages[SpecPackage.packageId] = SpecPackage.self
            packages[ArchitecturePackage.packageId] = ArchitecturePackage.self
            packages[PlanningPackage.packageId] = PlanningPackage.self
            packages[RiskPackage.packageId] = RiskPackage.self
            packages[DocsPackage.packageId] = DocsPackage.self
        }
    }
    
    /// Register a package
    public func register<P: CapabilityPackage>(_ package: P.Type) {
        packages[P.packageId] = package
    }
    
    /// Get a package by ID
    public func get(_ id: String) -> (any CapabilityPackage.Type)? {
        packages[id]
    }
    
    /// Get all kernel packages
    public func kernelPackages() -> [any CapabilityPackage.Type] {
        packages.values.filter { $0.isKernel }
    }
    
    /// Get all packages
    public func allPackages() -> [any CapabilityPackage.Type] {
        Array(packages.values)
    }
    
    /// Get packages that produce a specific artifact type
    public func packages(producing artifactType: String) -> [any CapabilityPackage.Type] {
        packages.values.filter { $0.produces.contains(artifactType) }
    }
    
    /// Get packages that consume a specific artifact type
    public func packages(consuming artifactType: String) -> [any CapabilityPackage.Type] {
        packages.values.filter { $0.consumes.contains(artifactType) }
    }
}

// MARK: - Package Manifest

/// Manifest describing a package
public struct PackageManifest: Codable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let version: String
    public let produces: [String]
    public let consumes: [String]
    public let isKernel: Bool
    
    public init<P: CapabilityPackage>(from package: P.Type) {
        self.id = P.packageId
        self.name = P.name
        self.description = P.description
        self.version = P.version
        self.produces = P.produces
        self.consumes = P.consumes
        self.isKernel = P.isKernel
    }
}
