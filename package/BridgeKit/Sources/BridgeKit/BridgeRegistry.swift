//
//  BridgeRegistry.swift
//  BridgeKit
//
//  Central registry for Kit descriptors and bridge management
//

import Foundation

/// Central registry for all Kit descriptors and bridges
public actor BridgeRegistry {
    public static let shared = BridgeRegistry()
    
    private var kits: [String: KitDescriptor] = [:]
    private var bridges: [UUID: Bridge] = [:]
    private var bridgesByKit: [String: Set<UUID>] = [:]
    
    private init() {}
    
    // MARK: - Kit Registration
    
    /// Register a Kit with its capabilities
    public func register(_ kit: KitDescriptor) {
        kits[kit.id] = kit
        print("[BridgeRegistry] Registered: \(kit.name) with \(kit.inputs.count) inputs, \(kit.outputs.count) outputs")
    }
    
    /// Unregister a Kit
    public func unregister(_ kitId: String) {
        kits.removeValue(forKey: kitId)
        // Remove associated bridges
        if let bridgeIds = bridgesByKit[kitId] {
            for id in bridgeIds {
                bridges.removeValue(forKey: id)
            }
            bridgesByKit.removeValue(forKey: kitId)
        }
    }
    
    /// Get a registered Kit
    public func getKit(_ id: String) -> KitDescriptor? {
        kits[id]
    }
    
    /// Get all registered Kits
    public func allKits() -> [KitDescriptor] {
        Array(kits.values)
    }
    
    // MARK: - Bridge Creation
    
    /// Create a bridge between two Kits
    public func createBridge(from sourceId: String, to targetId: String) -> Bridge? {
        guard let source = kits[sourceId], let target = kits[targetId] else {
            print("[BridgeRegistry] Cannot create bridge: Kit not found")
            return nil
        }
        
        // Find compatible ports
        guard let (sourcePort, targetPort) = findCompatiblePorts(source: source, target: target) else {
            print("[BridgeRegistry] No compatible ports between \(sourceId) and \(targetId)")
            return nil
        }
        
        // Determine triggers (intersection of both Kits' triggers)
        let triggers = Array(Set(source.triggers).intersection(Set(target.triggers)))
        
        let bridge = Bridge(
            sourceKit: sourceId,
            targetKit: targetId,
            sourcePort: sourcePort,
            targetPort: targetPort,
            triggers: triggers.isEmpty ? [.manual] : triggers
        )
        
        // Store bridge
        bridges[bridge.id] = bridge
        bridgesByKit[sourceId, default: []].insert(bridge.id)
        bridgesByKit[targetId, default: []].insert(bridge.id)
        
        print("[BridgeRegistry] Created bridge: \(bridge.description)")
        return bridge
    }
    
    /// Find compatible ports between two Kits
    private func findCompatiblePorts(source: KitDescriptor, target: KitDescriptor) -> (DataPort, DataPort)? {
        for output in source.outputs {
            for input in target.inputs {
                if output.dataType.isCompatible(with: input.dataType) {
                    return (output, input)
                }
            }
        }
        return nil
    }
    
    /// Auto-discover and create all compatible bridges
    public func autoConnect() -> [Bridge] {
        var newBridges: [Bridge] = []
        let kitList = Array(kits.values)
        
        for source in kitList {
            for target in kitList where source.id != target.id {
                // Check if bridge already exists
                let existingBridge = bridges.values.first {
                    $0.sourceKit == source.id && $0.targetKit == target.id
                }
                
                if existingBridge == nil {
                    if let bridge = createBridge(from: source.id, to: target.id) {
                        newBridges.append(bridge)
                    }
                }
            }
        }
        
        print("[BridgeRegistry] Auto-connected \(newBridges.count) bridges")
        return newBridges
    }
    
    // MARK: - Bridge Queries
    
    /// Get all bridges
    public func allBridges() -> [Bridge] {
        Array(bridges.values)
    }
    
    /// Get bridges for a specific Kit
    public func bridges(for kitId: String) -> [Bridge] {
        guard let ids = bridgesByKit[kitId] else { return [] }
        return ids.compactMap { bridges[$0] }
    }
    
    /// Get bridges triggered by a specific event
    public func bridges(triggeredBy trigger: TriggerType) -> [Bridge] {
        bridges.values.filter { $0.triggers.contains(trigger) }
    }
    
    /// Get bridge by ID
    public func getBridge(_ id: UUID) -> Bridge? {
        bridges[id]
    }
    
    /// Remove a bridge
    public func removeBridge(_ id: UUID) {
        if let bridge = bridges.removeValue(forKey: id) {
            bridgesByKit[bridge.sourceKit]?.remove(id)
            bridgesByKit[bridge.targetKit]?.remove(id)
        }
    }
    
    // MARK: - Statistics
    
    public var stats: BridgeStats {
        BridgeStats(
            kitCount: kits.count,
            bridgeCount: bridges.count,
            activeBridges: bridges.values.filter { $0.isActive }.count
        )
    }
}

public struct BridgeStats: Sendable {
    public let kitCount: Int
    public let bridgeCount: Int
    public let activeBridges: Int
}
