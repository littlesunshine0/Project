//
//  SystemKit.swift
//  SystemKit
//
//  System integration, permissions, memory, and performance optimization
//

import Foundation

public struct SystemKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.systemkit"
    public init() {}
}

// MARK: - Service Registry

public actor ServiceRegistry {
    public static let shared = ServiceRegistry()
    
    private var services: [String: ServiceInfo] = [:]
    private var dependencies: [String: Set<String>] = [:]
    
    private init() {}
    
    public func register(_ service: ServiceInfo) {
        services[service.id] = service
    }
    
    public func register(id: String, name: String, version: String = "1.0") {
        register(ServiceInfo(id: id, name: name, version: version))
    }
    
    public func unregister(_ id: String) { services.removeValue(forKey: id) }
    public func get(_ id: String) -> ServiceInfo? { services[id] }
    public func getAll() -> [ServiceInfo] { Array(services.values) }
    
    public func addDependency(service: String, dependsOn: String) {
        dependencies[service, default: []].insert(dependsOn)
    }
    
    public func getDependencies(for service: String) -> [String] {
        Array(dependencies[service] ?? [])
    }
    
    public var stats: RegistryStats {
        RegistryStats(serviceCount: services.count, dependencyCount: dependencies.values.reduce(0) { $0 + $1.count })
    }
}

// MARK: - Permission Manager

public actor PermissionManager {
    public static let shared = PermissionManager()
    
    private var permissions: [String: PermissionStatus] = [:]
    private var requests: [PermissionRequest] = []
    
    private init() {}
    
    public func check(_ permission: String) -> PermissionStatus {
        permissions[permission] ?? .unknown
    }
    
    public func request(_ permission: String) -> PermissionStatus {
        let request = PermissionRequest(permission: permission)
        requests.append(request)
        // Simulate granting
        permissions[permission] = .granted
        return .granted
    }
    
    public func grant(_ permission: String) { permissions[permission] = .granted }
    public func deny(_ permission: String) { permissions[permission] = .denied }
    public func revoke(_ permission: String) { permissions[permission] = .revoked }
    
    public func getAllPermissions() -> [String: PermissionStatus] { permissions }
}

// MARK: - Memory Optimizer

public actor MemoryOptimizer {
    public static let shared = MemoryOptimizer()
    
    private var caches: [String: CacheInfo] = [:]
    private var memoryPressure: MemoryPressure = .normal
    
    private init() {}
    
    public func registerCache(_ id: String, size: Int64) {
        caches[id] = CacheInfo(id: id, size: size)
    }
    
    public func clearCache(_ id: String) { caches.removeValue(forKey: id) }
    public func clearAllCaches() { caches.removeAll() }
    
    public func setMemoryPressure(_ pressure: MemoryPressure) {
        memoryPressure = pressure
        if pressure == .critical { clearAllCaches() }
    }
    
    public func getMemoryPressure() -> MemoryPressure { memoryPressure }
    
    public var stats: MemoryStats {
        MemoryStats(
            cacheCount: caches.count,
            totalCacheSize: caches.values.reduce(0) { $0 + $1.size },
            pressure: memoryPressure
        )
    }
}

// MARK: - Performance Optimizer

public actor PerformanceOptimizer {
    public static let shared = PerformanceOptimizer()
    
    private var optimizations: [String: Optimization] = [:]
    private var metrics: [String: Double] = [:]
    
    private init() {}
    
    public func registerOptimization(_ opt: Optimization) {
        optimizations[opt.id] = opt
    }
    
    public func applyOptimization(_ id: String) -> Bool {
        guard let opt = optimizations[id], opt.isEnabled else { return false }
        // Simulate applying optimization
        return true
    }
    
    public func recordMetric(_ name: String, value: Double) {
        metrics[name] = value
    }
    
    public func getMetric(_ name: String) -> Double? { metrics[name] }
    public func getAllMetrics() -> [String: Double] { metrics }
    
    public func getOptimizations() -> [Optimization] { Array(optimizations.values) }
}

// MARK: - Sandbox Manager

public actor SandboxManager {
    public static let shared = SandboxManager()
    
    private var sandboxes: [UUID: Sandbox] = [:]
    
    private init() {}
    
    public func create(name: String, permissions: [String] = []) -> Sandbox {
        let sandbox = Sandbox(name: name, permissions: Set(permissions))
        sandboxes[sandbox.id] = sandbox
        return sandbox
    }
    
    public func get(_ id: UUID) -> Sandbox? { sandboxes[id] }
    public func destroy(_ id: UUID) { sandboxes.removeValue(forKey: id) }
    public func getAll() -> [Sandbox] { Array(sandboxes.values) }
}

// MARK: - Models

public struct ServiceInfo: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let version: String
    public let registeredAt: Date
    
    public init(id: String, name: String, version: String = "1.0", registeredAt: Date = Date()) {
        self.id = id
        self.name = name
        self.version = version
        self.registeredAt = registeredAt
    }
}

public enum PermissionStatus: String, Sendable { case unknown, granted, denied, revoked }

public struct PermissionRequest: Sendable {
    public let permission: String
    public let requestedAt: Date
    public init(permission: String, requestedAt: Date = Date()) {
        self.permission = permission
        self.requestedAt = requestedAt
    }
}

public struct CacheInfo: Sendable {
    public let id: String
    public let size: Int64
    public let createdAt: Date
    public init(id: String, size: Int64, createdAt: Date = Date()) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
    }
}

public enum MemoryPressure: String, Sendable { case normal, warning, critical }

public struct MemoryStats: Sendable {
    public let cacheCount: Int
    public let totalCacheSize: Int64
    public let pressure: MemoryPressure
}

public struct RegistryStats: Sendable {
    public let serviceCount: Int
    public let dependencyCount: Int
}

public struct Optimization: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let isEnabled: Bool
    public init(id: String, name: String, isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
    }
}

public struct Sandbox: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let permissions: Set<String>
    public let createdAt: Date
    public init(id: UUID = UUID(), name: String, permissions: Set<String> = [], createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.permissions = permissions
        self.createdAt = createdAt
    }
}
