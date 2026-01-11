//
//  BridgeKit.swift
//  BridgeKit
//
//  Universal Kit Bridge System
//  Dynamically connects any two Kits to work together automatically
//
//  USAGE - One liner to activate all Kits:
//  ```swift
//  import BridgeKit
//  let result = await KitPack.activate(project: "/path/to/project")
//  // Done. All Kits are now producing and bridging automatically.
//  ```
//
//  Architecture:
//  - KitPack: One-liner activation for any project
//  - AutoBridge: Automatic Kit attachment and production
//  - BridgeRegistry: Central registry for Kit descriptors
//  - BridgeExecutor: Executes data flow through bridges
//  - KitDescriptors: Pre-defined descriptors for all Kits
//

import Foundation

/// BridgeKit - Universal Kit Connection System
public struct BridgeKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.bridgekit"
    
    public init() {}
    
    /// Quick start - activate all Kits for a project
    public static func start(project path: String) async -> ActivationResult {
        await KitPack.activate(project: path)
    }
    
    /// Register a Kit with its capabilities
    public static func register(_ kit: KitDescriptor) async {
        await BridgeRegistry.shared.register(kit)
    }
    
    /// Create a bridge between two Kits
    public static func bridge(_ source: String, to target: String) async -> Bridge? {
        await BridgeRegistry.shared.createBridge(from: source, to: target)
    }
    
    /// Auto-discover and create all compatible bridges
    public static func autoConnect() async -> [Bridge] {
        await BridgeRegistry.shared.autoConnect()
    }
    
    /// Execute data flow through a bridge
    public static func flow(_ data: BridgeData, through bridge: Bridge) async -> BridgeResult {
        await BridgeExecutor.shared.execute(data: data, through: bridge)
    }
    
    /// Chain multiple bridges: A→B→C
    public static func chain(_ bridges: [Bridge]) -> BridgeChain {
        BridgeChain(bridges: bridges)
    }
    
    /// Pair two bridges to work in parallel: (A+B)
    public static func pair(_ bridge1: Bridge, _ bridge2: Bridge) -> BridgePair {
        BridgePair(first: bridge1, second: bridge2)
    }
}

// MARK: - Kit Descriptor

/// Describes a Kit's capabilities for bridging
public struct KitDescriptor: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let inputs: [DataPort]
    public let outputs: [DataPort]
    public let triggers: [TriggerType]
    
    public init(
        id: String,
        name: String,
        inputs: [DataPort] = [],
        outputs: [DataPort] = [],
        triggers: [TriggerType] = []
    ) {
        self.id = id
        self.name = name
        self.inputs = inputs
        self.outputs = outputs
        self.triggers = triggers
    }
}

/// A data port that a Kit exposes
public struct DataPort: Sendable, Equatable {
    public let name: String
    public let dataType: DataType
    public let description: String
    
    public init(name: String, dataType: DataType, description: String = "") {
        self.name = name
        self.dataType = dataType
        self.description = description
    }
}

/// Types of data that can flow through bridges
public enum DataType: String, Sendable, CaseIterable {
    case text, markdown, json, code, file, path
    case intent, entity, command, query
    case workflow, action, agent, task
    case searchResult, prediction, suggestion
    case content, document, metadata
    case any // Matches anything
    
    /// Check if this type is compatible with another
    public func isCompatible(with other: DataType) -> Bool {
        if self == .any || other == .any { return true }
        return self == other
    }
}

/// Events that can trigger bridge execution
public enum TriggerType: String, Sendable, CaseIterable {
    case onProjectCreate
    case onFileChange
    case onFileSave
    case onCommand
    case onSearch
    case onIntent
    case onWorkflowComplete
    case onAgentAction
    case manual
}

// MARK: - Bridge

/// A connection between two Kits
public struct Bridge: Identifiable, Sendable {
    public let id: UUID
    public let sourceKit: String
    public let targetKit: String
    public let sourcePort: DataPort
    public let targetPort: DataPort
    public let transformer: String? // Optional data transformation
    public let triggers: [TriggerType]
    public let isActive: Bool
    
    public init(
        id: UUID = UUID(),
        sourceKit: String,
        targetKit: String,
        sourcePort: DataPort,
        targetPort: DataPort,
        transformer: String? = nil,
        triggers: [TriggerType] = [.manual],
        isActive: Bool = true
    ) {
        self.id = id
        self.sourceKit = sourceKit
        self.targetKit = targetKit
        self.sourcePort = sourcePort
        self.targetPort = targetPort
        self.transformer = transformer
        self.triggers = triggers
        self.isActive = isActive
    }
    
    public var description: String {
        "\(sourceKit).\(sourcePort.name) → \(targetKit).\(targetPort.name)"
    }
}

// MARK: - Bridge Chain

/// Multiple bridges chained together: A→B→C
public struct BridgeChain: Sendable {
    public let bridges: [Bridge]
    
    public var description: String {
        bridges.map { $0.sourceKit }.joined(separator: " → ") + " → " + (bridges.last?.targetKit ?? "")
    }
    
    /// Execute data through the entire chain
    public func execute(_ data: BridgeData) async -> BridgeResult {
        var currentData = data
        var results: [BridgeResult] = []
        
        for bridge in bridges {
            let result = await BridgeExecutor.shared.execute(data: currentData, through: bridge)
            results.append(result)
            
            if !result.success {
                return BridgeResult(
                    success: false,
                    output: nil,
                    error: "Chain failed at \(bridge.description): \(result.error ?? "Unknown")",
                    duration: results.reduce(0) { $0 + $1.duration }
                )
            }
            
            // Pass output to next bridge
            if let output = result.output {
                currentData = output
            }
        }
        
        return BridgeResult(
            success: true,
            output: currentData,
            duration: results.reduce(0) { $0 + $1.duration }
        )
    }
}

// MARK: - Bridge Pair

/// Two bridges working in parallel: (A+B)
public struct BridgePair: Sendable {
    public let first: Bridge
    public let second: Bridge
    
    public var description: String {
        "(\(first.description)) + (\(second.description))"
    }
    
    /// Execute both bridges in parallel and merge results
    public func execute(_ data: BridgeData) async -> BridgePairResult {
        async let result1 = BridgeExecutor.shared.execute(data: data, through: first)
        async let result2 = BridgeExecutor.shared.execute(data: data, through: second)
        
        let (r1, r2) = await (result1, result2)
        
        return BridgePairResult(
            first: r1,
            second: r2,
            success: r1.success && r2.success
        )
    }
}

public struct BridgePairResult: Sendable {
    public let first: BridgeResult
    public let second: BridgeResult
    public let success: Bool
}

// MARK: - Bridge Data

/// Data flowing through bridges
public struct BridgeData: Sendable {
    public let type: DataType
    public let value: String
    public let metadata: [String: String]
    public let sourceKit: String?
    public let timestamp: Date
    
    public init(
        type: DataType,
        value: String,
        metadata: [String: String] = [:],
        sourceKit: String? = nil,
        timestamp: Date = Date()
    ) {
        self.type = type
        self.value = value
        self.metadata = metadata
        self.sourceKit = sourceKit
        self.timestamp = timestamp
    }
}

// MARK: - Bridge Result

public struct BridgeResult: Sendable {
    public let success: Bool
    public let output: BridgeData?
    public let error: String?
    public let duration: TimeInterval
    
    public init(success: Bool, output: BridgeData? = nil, error: String? = nil, duration: TimeInterval = 0) {
        self.success = success
        self.output = output
        self.error = error
        self.duration = duration
    }
}
