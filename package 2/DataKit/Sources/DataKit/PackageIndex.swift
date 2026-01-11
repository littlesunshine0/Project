//
//  PackageIndex.swift
//  DataKit
//
//  Indexes all files and capabilities in each package
//

import Foundation

// MARK: - Package Index

public actor PackageIndex {
    public static let shared = PackageIndex()
    
    private var packages: [String: PackageInfo] = [:]
    private var fileIndex: [String: [FileInfo]] = [:]
    private var symbolIndex: [String: [SymbolInfo]] = [:]
    
    private init() {}
    
    // MARK: - Registration
    
    public func register(_ package: PackageInfo) {
        packages[package.identifier] = package
        fileIndex[package.identifier] = package.files
        
        // Index symbols from files
        for file in package.files {
            symbolIndex[package.identifier, default: []].append(contentsOf: file.symbols)
        }
    }
    
    // MARK: - Queries
    
    public func getAllPackages() -> [PackageInfo] {
        Array(packages.values).sorted { $0.name < $1.name }
    }
    
    public func getPackage(_ identifier: String) -> PackageInfo? {
        packages[identifier]
    }
    
    public func getFiles(for package: String) -> [FileInfo] {
        fileIndex[package] ?? []
    }
    
    public func searchFiles(_ query: String) -> [FileInfo] {
        let lowered = query.lowercased()
        return fileIndex.values.flatMap { $0 }.filter {
            $0.name.lowercased().contains(lowered) ||
            $0.path.lowercased().contains(lowered)
        }
    }
    
    public func searchSymbols(_ query: String) -> [SymbolInfo] {
        let lowered = query.lowercased()
        return symbolIndex.values.flatMap { $0 }.filter {
            $0.name.lowercased().contains(lowered)
        }
    }
    
    public func getStats() -> PackageIndexStats {
        PackageIndexStats(
            packageCount: packages.count,
            fileCount: fileIndex.values.reduce(0) { $0 + $1.count },
            symbolCount: symbolIndex.values.reduce(0) { $0 + $1.count }
        )
    }
}

// MARK: - Package Info

public struct PackageInfo: Identifiable, Sendable {
    public let id: UUID
    public let identifier: String
    public let name: String
    public let version: String
    public let description: String
    public let icon: String
    public let color: String
    public let files: [FileInfo]
    public let dependencies: [String]
    public let exports: [String]
    
    // Statistics
    public let commandCount: Int
    public let actionCount: Int
    public let workflowCount: Int
    public let agentCount: Int
    public let viewCount: Int
    public let modelCount: Int
    public let serviceCount: Int
    
    public init(
        id: UUID = UUID(),
        identifier: String,
        name: String,
        version: String = "1.0.0",
        description: String = "",
        icon: String = "shippingbox",
        color: String = "blue",
        files: [FileInfo] = [],
        dependencies: [String] = [],
        exports: [String] = [],
        commandCount: Int = 0,
        actionCount: Int = 0,
        workflowCount: Int = 0,
        agentCount: Int = 0,
        viewCount: Int = 0,
        modelCount: Int = 0,
        serviceCount: Int = 0
    ) {
        self.id = id
        self.identifier = identifier
        self.name = name
        self.version = version
        self.description = description
        self.icon = icon
        self.color = color
        self.files = files
        self.dependencies = dependencies
        self.exports = exports
        self.commandCount = commandCount
        self.actionCount = actionCount
        self.workflowCount = workflowCount
        self.agentCount = agentCount
        self.viewCount = viewCount
        self.modelCount = modelCount
        self.serviceCount = serviceCount
    }
    
    public var totalCapabilities: Int {
        commandCount + actionCount + workflowCount + agentCount
    }
}

// MARK: - File Info

public struct FileInfo: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let path: String
    public let type: FileType
    public let size: Int
    public let lineCount: Int
    public let symbols: [SymbolInfo]
    public let lastModified: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        path: String,
        type: FileType,
        size: Int = 0,
        lineCount: Int = 0,
        symbols: [SymbolInfo] = [],
        lastModified: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.path = path
        self.type = type
        self.size = size
        self.lineCount = lineCount
        self.symbols = symbols
        self.lastModified = lastModified
    }
    
    public enum FileType: String, Sendable {
        case model, view, viewModel, service, test, resource, config
        
        public var icon: String {
            switch self {
            case .model: return "cube"
            case .view: return "rectangle.on.rectangle"
            case .viewModel: return "gearshape.2"
            case .service: return "server.rack"
            case .test: return "checkmark.seal"
            case .resource: return "doc"
            case .config: return "gearshape"
            }
        }
    }
}

// MARK: - Symbol Info

public struct SymbolInfo: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let type: SymbolType
    public let file: String
    public let line: Int
    public let isPublic: Bool
    
    public init(id: UUID = UUID(), name: String, type: SymbolType, file: String, line: Int, isPublic: Bool = true) {
        self.id = id
        self.name = name
        self.type = type
        self.file = file
        self.line = line
        self.isPublic = isPublic
    }
    
    public enum SymbolType: String, Sendable {
        case `struct`, `class`, `enum`, `protocol`, function, property, `actor`
        
        public var icon: String {
            switch self {
            case .struct: return "s.square"
            case .class: return "c.square"
            case .enum: return "e.square"
            case .protocol: return "p.square"
            case .function: return "f.square"
            case .property: return "p.circle"
            case .actor: return "a.square"
            }
        }
    }
}

// MARK: - Stats

public struct PackageIndexStats: Sendable {
    public let packageCount: Int
    public let fileCount: Int
    public let symbolCount: Int
}
