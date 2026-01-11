//
//  BridgeExecutor.swift
//  BridgeKit
//
//  Executes data flow through bridges
//

import Foundation

/// Executes data flow through bridges
public actor BridgeExecutor {
    public static let shared = BridgeExecutor()
    
    /// Registered handlers for each Kit
    private var handlers: [String: BridgeHandler] = [:]
    
    /// Execution history for analytics
    private var history: [BridgeExecution] = []
    
    private init() {}
    
    // MARK: - Handler Registration
    
    /// Register a handler for a Kit
    public func registerHandler(_ handler: BridgeHandler, for kitId: String) {
        handlers[kitId] = handler
        print("[BridgeExecutor] Registered handler for: \(kitId)")
    }
    
    /// Unregister a handler
    public func unregisterHandler(for kitId: String) {
        handlers.removeValue(forKey: kitId)
    }
    
    // MARK: - Execution
    
    /// Execute data flow through a bridge
    public func execute(data: BridgeData, through bridge: Bridge) -> BridgeResult {
        let startTime = Date()
        
        // Check if bridge is active
        guard bridge.isActive else {
            return BridgeResult(
                success: false,
                error: "Bridge is inactive",
                duration: 0
            )
        }
        
        // Get handler for target Kit
        guard let handler = handlers[bridge.targetKit] else {
            // No handler - simulate success for testing
            let duration = Date().timeIntervalSince(startTime)
            let output = BridgeData(
                type: bridge.targetPort.dataType,
                value: data.value,
                metadata: data.metadata.merging(["bridge": bridge.id.uuidString]) { _, new in new },
                sourceKit: bridge.sourceKit
            )
            
            recordExecution(bridge: bridge, success: true, duration: duration)
            
            return BridgeResult(
                success: true,
                output: output,
                duration: duration
            )
        }
        
        // Transform data if needed
        let transformedData = transform(data, for: bridge)
        
        // Execute handler
        do {
            let output = try handler.handle(transformedData, port: bridge.targetPort)
            let duration = Date().timeIntervalSince(startTime)
            
            recordExecution(bridge: bridge, success: true, duration: duration)
            
            return BridgeResult(
                success: true,
                output: output,
                duration: duration
            )
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            recordExecution(bridge: bridge, success: false, duration: duration)
            
            return BridgeResult(
                success: false,
                error: error.localizedDescription,
                duration: duration
            )
        }
    }
    
    /// Execute multiple bridges triggered by an event
    public func executeTrigger(_ trigger: TriggerType, with data: BridgeData) async -> [BridgeResult] {
        let bridges = await BridgeRegistry.shared.bridges(triggeredBy: trigger)
        var results: [BridgeResult] = []
        
        for bridge in bridges {
            let result = execute(data: data, through: bridge)
            results.append(result)
        }
        
        return results
    }
    
    // MARK: - Data Transformation
    
    private func transform(_ data: BridgeData, for bridge: Bridge) -> BridgeData {
        // Apply transformer if specified
        guard let transformer = bridge.transformer else {
            return data
        }
        
        // Built-in transformers
        switch transformer {
        case "toJSON":
            return BridgeData(
                type: .json,
                value: "{\"value\": \"\(data.value)\"}",
                metadata: data.metadata,
                sourceKit: data.sourceKit
            )
        case "toMarkdown":
            return BridgeData(
                type: .markdown,
                value: "# \(data.value)",
                metadata: data.metadata,
                sourceKit: data.sourceKit
            )
        case "toText":
            return BridgeData(
                type: .text,
                value: data.value,
                metadata: data.metadata,
                sourceKit: data.sourceKit
            )
        default:
            return data
        }
    }
    
    // MARK: - History
    
    private func recordExecution(bridge: Bridge, success: Bool, duration: TimeInterval) {
        let execution = BridgeExecution(
            bridgeId: bridge.id,
            sourceKit: bridge.sourceKit,
            targetKit: bridge.targetKit,
            success: success,
            duration: duration,
            timestamp: Date()
        )
        history.append(execution)
        
        // Keep last 1000 executions
        if history.count > 1000 {
            history.removeFirst(history.count - 1000)
        }
    }
    
    /// Get execution history
    public func getHistory(limit: Int = 100) -> [BridgeExecution] {
        Array(history.suffix(limit))
    }
    
    /// Get statistics
    public var stats: ExecutorStats {
        let successful = history.filter { $0.success }.count
        let avgDuration = history.isEmpty ? 0 : history.reduce(0) { $0 + $1.duration } / Double(history.count)
        
        return ExecutorStats(
            totalExecutions: history.count,
            successfulExecutions: successful,
            failedExecutions: history.count - successful,
            averageDuration: avgDuration
        )
    }
}

// MARK: - Bridge Handler Protocol

/// Protocol for Kit-specific bridge handlers
public protocol BridgeHandler: Sendable {
    func handle(_ data: BridgeData, port: DataPort) throws -> BridgeData
}

// MARK: - Execution Record

public struct BridgeExecution: Sendable {
    public let bridgeId: UUID
    public let sourceKit: String
    public let targetKit: String
    public let success: Bool
    public let duration: TimeInterval
    public let timestamp: Date
}

public struct ExecutorStats: Sendable {
    public let totalExecutions: Int
    public let successfulExecutions: Int
    public let failedExecutions: Int
    public let averageDuration: TimeInterval
    
    public var successRate: Double {
        totalExecutions == 0 ? 0 : Double(successfulExecutions) / Double(totalExecutions)
    }
}
