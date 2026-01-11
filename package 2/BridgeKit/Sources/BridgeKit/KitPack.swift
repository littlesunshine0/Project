//
//  KitPack.swift
//  BridgeKit
//
//  One-liner Kit automation for any project
//  Just call: await KitPack.activate(project: "/path/to/project")
//  All Kits automatically attach, produce, and bridge
//

import Foundation

/// KitPack - Zero-config Kit automation
/// One call activates all Kits for a project
public enum KitPack {
    
    // MARK: - One-Liner Activation
    
    /// Activate all Kits for a project - FULLY AUTOMATIC
    /// ```swift
    /// let result = await KitPack.activate(project: "/path/to/project")
    /// // That's it. All Kits are now working.
    /// ```
    public static func activate(project path: String) async -> ActivationResult {
        print("[KitPack] 🚀 Activating all Kits for: \(path)")
        
        // 1. Register all Kit descriptors
        await KitDescriptors.registerAll()
        
        // 2. Attach all Kits to project
        let attachResults = await AutoBridge.shared.attachAllKits(to: path)
        
        // 3. Auto-connect all bridges
        let bridges = await BridgeRegistry.shared.autoConnect()
        
        // 4. Trigger initial production (project create)
        let outputs = await AutoBridge.shared.onProjectCreate(at: path)
        
        let result = ActivationResult(
            projectPath: path,
            attachedKits: attachResults.map { $0.kitId },
            bridges: bridges,
            outputs: outputs,
            success: true
        )
        
        print("[KitPack] ✅ Activated \(result.attachedKits.count) Kits, \(bridges.count) bridges, \(outputs.count) outputs")
        
        return result
    }
    
    /// Activate specific Kits for a project
    public static func activate(kits: [KitType], project path: String) async -> ActivationResult {
        print("[KitPack] 🚀 Activating \(kits.count) Kits for: \(path)")
        
        // Register selected Kit descriptors
        for kit in kits {
            if let descriptor = kit.descriptor {
                await BridgeRegistry.shared.register(descriptor)
            }
        }
        
        // Attach selected Kits
        let kitIds = kits.compactMap { $0.descriptor?.id }
        let attachResults = await AutoBridge.shared.attachAll(kitIds, to: path)
        
        // Auto-connect bridges
        let bridges = await BridgeRegistry.shared.autoConnect()
        
        // Trigger production
        let outputs = await AutoBridge.shared.onProjectCreate(at: path)
        
        return ActivationResult(
            projectPath: path,
            attachedKits: attachResults.map { $0.kitId },
            bridges: bridges,
            outputs: outputs,
            success: true
        )
    }
    
    // MARK: - Preset Packs
    
    /// Documentation Pack: DocKit + ParseKit + SearchKit
    public static func docs(project path: String) async -> ActivationResult {
        await activate(kits: [.docKit, .parseKit, .searchKit], project: path)
    }
    
    /// Intelligence Pack: NLUKit + LearnKit + CommandKit
    public static func intelligence(project path: String) async -> ActivationResult {
        await activate(kits: [.nluKit, .learnKit, .commandKit], project: path)
    }
    
    /// Automation Pack: WorkflowKit + AgentKit + CommandKit
    public static func automation(project path: String) async -> ActivationResult {
        await activate(kits: [.workflowKit, .agentKit, .commandKit], project: path)
    }
    
    /// Full Stack: All Kits
    public static func full(project path: String) async -> ActivationResult {
        await activate(project: path)
    }
    
    // MARK: - Event Hooks
    
    /// Call when a file changes in the project
    public static func fileChanged(_ file: String, in project: String) async {
        _ = await AutoBridge.shared.onFileChange(file: file, in: project)
    }
    
    /// Call when a file is saved
    public static func fileSaved(_ file: String, in project: String) async {
        _ = await AutoBridge.shared.onFileSave(file: file, in: project)
    }
    
    // MARK: - Status
    
    public static func status(for project: String) async -> ProjectStatus {
        let kits = await AutoBridge.shared.attachedKits(for: project)
        let bridges = await BridgeRegistry.shared.allBridges()
        let stats = await AutoBridge.shared.stats
        
        return ProjectStatus(
            projectPath: project,
            attachedKits: Array(kits),
            bridgeCount: bridges.count,
            isActive: !kits.isEmpty,
            stats: stats
        )
    }
    
    // MARK: - Content Storage & Search
    
    /// Search all stored content across all projects
    public static func search(_ query: String) async -> [StoredContent] {
        await ContentStorage.shared.search(query: query)
    }
    
    /// Get all content for a specific project
    public static func getProjectContent(_ projectPath: String) async -> [StoredContent] {
        await ContentStorage.shared.getProjectContent(projectPath)
    }
    
    /// Get all content produced by a specific Kit
    public static func getKitContent(_ kitId: String) async -> [StoredContent] {
        await ContentStorage.shared.getKitContent(kitId)
    }
    
    /// Get all content of a specific type (e.g., "readme", "specs")
    public static func getTypeContent(_ outputType: String) async -> [StoredContent] {
        await ContentStorage.shared.getTypeContent(outputType)
    }
    
    /// Get all stored content
    public static func getAllContent() async -> [StoredContent] {
        await ContentStorage.shared.getAllContent()
    }
    
    /// Get storage statistics
    public static func storageStats() async -> StorageStats {
        await ContentStorage.shared.stats
    }
    
    /// Export all content for ML training
    public static func exportForML() async -> [MLExportRecord] {
        await ContentStorage.shared.exportForML()
    }
}

// MARK: - Kit Type Enum

public enum KitType: String, CaseIterable {
    case docKit
    case parseKit
    case searchKit
    case nluKit
    case learnKit
    case commandKit
    case workflowKit
    case agentKit
    case ideaKit
    case iconKit
    case contentHub
    
    public var descriptor: KitDescriptor? {
        switch self {
        case .docKit: return KitDescriptors.docKit
        case .parseKit: return KitDescriptors.parseKit
        case .searchKit: return KitDescriptors.searchKit
        case .nluKit: return KitDescriptors.nluKit
        case .learnKit: return KitDescriptors.learnKit
        case .commandKit: return KitDescriptors.commandKit
        case .workflowKit: return KitDescriptors.workflowKit
        case .agentKit: return KitDescriptors.agentKit
        case .ideaKit: return KitDescriptors.ideaKit
        case .iconKit: return KitDescriptors.iconKit
        case .contentHub: return KitDescriptors.contentHub
        }
    }
}

// MARK: - Result Types

public struct ActivationResult: Sendable {
    public let projectPath: String
    public let attachedKits: [String]
    public let bridges: [Bridge]
    public let outputs: [ProductionOutput]
    public let success: Bool
    
    public var summary: String {
        """
        KitPack Activation Complete
        ──────────────────────────
        Project: \(projectPath)
        Kits: \(attachedKits.count) attached
        Bridges: \(bridges.count) created
        Outputs: \(outputs.count) produced
        Status: \(success ? "✅ Success" : "❌ Failed")
        """
    }
}

public struct ProjectStatus: Sendable {
    public let projectPath: String
    public let attachedKits: [String]
    public let bridgeCount: Int
    public let isActive: Bool
    public let stats: AutoBridgeStats
}
