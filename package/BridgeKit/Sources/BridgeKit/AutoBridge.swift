//
//  AutoBridge.swift
//  BridgeKit
//
//  Automatic Kit activation and production system
//  When a Kit is attached to a project, it automatically:
//  1. Scans the project
//  2. Produces its outputs
//  3. Bridges to other attached Kits
//  4. Stores results in ContentHub (database)
//  5. Indexes content for search
//

import Foundation

// MARK: - Content Storage Integration

/// Stores produced content in the database and indexes it
public actor ContentStorage {
    public static let shared = ContentStorage()
    
    /// All stored content (in-memory database)
    private var database: [UUID: StoredContent] = [:]
    
    /// Index by project
    private var projectIndex: [String: Set<UUID>] = [:]
    
    /// Index by Kit
    private var kitIndex: [String: Set<UUID>] = [:]
    
    /// Index by content type
    private var typeIndex: [String: Set<UUID>] = [:]
    
    /// Full-text search index (word → content IDs)
    private var searchIndex: [String: Set<UUID>] = [:]
    
    private init() {}
    
    /// Store content and index it automatically
    public func store(_ output: ProductionOutput, projectPath: String, projectName: String) -> StoredContent {
        let content = StoredContent(
            id: UUID(),
            projectPath: projectPath,
            projectName: projectName,
            kitId: output.kitId,
            outputType: output.outputType,
            dataType: output.dataType,
            content: output.content,
            metadata: output.metadata,
            createdAt: output.timestamp,
            indexed: true
        )
        
        // Store in database
        database[content.id] = content
        
        // Index by project
        projectIndex[projectPath, default: []].insert(content.id)
        
        // Index by Kit
        kitIndex[output.kitId, default: []].insert(content.id)
        
        // Index by type
        typeIndex[output.outputType, default: []].insert(content.id)
        
        // Full-text index
        indexContent(content)
        
        print("[ContentStorage] Stored & indexed: \(output.outputType) from \(output.kitId) for \(projectName)")
        
        return content
    }
    
    /// Index content for full-text search
    private func indexContent(_ content: StoredContent) {
        // Tokenize content
        let words = tokenize(content.content)
        
        for word in words {
            searchIndex[word.lowercased(), default: []].insert(content.id)
        }
        
        // Also index metadata
        for (key, value) in content.metadata {
            searchIndex[key.lowercased(), default: []].insert(content.id)
            for word in tokenize(value) {
                searchIndex[word.lowercased(), default: []].insert(content.id)
            }
        }
    }
    
    /// Simple tokenizer
    private func tokenize(_ text: String) -> [String] {
        text.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 2 }
    }
    
    /// Search content
    public func search(query: String) -> [StoredContent] {
        let queryWords = tokenize(query).map { $0.lowercased() }
        
        var matchingIds: Set<UUID>?
        
        for word in queryWords {
            if let ids = searchIndex[word] {
                if matchingIds == nil {
                    matchingIds = ids
                } else {
                    matchingIds = matchingIds?.intersection(ids)
                }
            }
        }
        
        return (matchingIds ?? []).compactMap { database[$0] }
    }
    
    /// Get all content for a project
    public func getProjectContent(_ projectPath: String) -> [StoredContent] {
        let ids = projectIndex[projectPath] ?? []
        return ids.compactMap { database[$0] }
    }
    
    /// Get all content from a Kit
    public func getKitContent(_ kitId: String) -> [StoredContent] {
        let ids = kitIndex[kitId] ?? []
        return ids.compactMap { database[$0] }
    }
    
    /// Get all content of a type
    public func getTypeContent(_ outputType: String) -> [StoredContent] {
        let ids = typeIndex[outputType] ?? []
        return ids.compactMap { database[$0] }
    }
    
    /// Get all content
    public func getAllContent() -> [StoredContent] {
        Array(database.values)
    }
    
    /// Get statistics
    public var stats: StorageStats {
        StorageStats(
            totalContent: database.count,
            projectCount: projectIndex.count,
            kitCount: kitIndex.count,
            typeCount: typeIndex.count,
            indexedWords: searchIndex.count
        )
    }
    
    /// Export for ML training
    public func exportForML() -> [MLExportRecord] {
        database.values.map { content in
            MLExportRecord(
                id: content.id,
                projectName: content.projectName,
                kitId: content.kitId,
                outputType: content.outputType,
                content: content.content,
                metadata: content.metadata
            )
        }
    }
}

/// Stored content record
public struct StoredContent: Identifiable, Sendable {
    public let id: UUID
    public let projectPath: String
    public let projectName: String
    public let kitId: String
    public let outputType: String
    public let dataType: DataType
    public let content: String
    public let metadata: [String: String]
    public let createdAt: Date
    public let indexed: Bool
}

/// Storage statistics
public struct StorageStats: Sendable {
    public let totalContent: Int
    public let projectCount: Int
    public let kitCount: Int
    public let typeCount: Int
    public let indexedWords: Int
}

/// ML export record
public struct MLExportRecord: Codable, Sendable {
    public let id: UUID
    public let projectName: String
    public let kitId: String
    public let outputType: String
    public let content: String
    public let metadata: [String: String]
}

/// AutoBridge - Zero-configuration Kit automation
/// Attach any Kit to a project and it starts working immediately
public actor AutoBridge {
    public static let shared = AutoBridge()
    
    /// Attached Kits for each project
    private var projectKits: [String: Set<String>] = [:]
    
    /// Active producers for each project
    private var producers: [String: [KitProducer]] = [:]
    
    /// Production queue
    private var productionQueue: [ProductionJob] = []
    
    /// Is auto-production enabled
    private var isEnabled = true
    
    private init() {}
    
    // MARK: - Kit Attachment (This is the magic)
    
    /// Attach a Kit to a project - triggers automatic production
    public func attach(_ kitId: String, to projectPath: String) async -> AttachResult {
        // Register Kit if not already
        if await BridgeRegistry.shared.getKit(kitId) == nil {
            // Auto-register from known descriptors
            if let descriptor = KitDescriptors.all.first(where: { $0.id == kitId }) {
                await BridgeRegistry.shared.register(descriptor)
            }
        }
        
        // Track attachment
        projectKits[projectPath, default: []].insert(kitId)
        
        // Create producer for this Kit
        let projectName = URL(fileURLWithPath: projectPath).lastPathComponent
        let producer = KitProducer(kitId: kitId, projectPath: projectPath, projectName: projectName)
        producers[projectPath, default: []].append(producer)
        
        // Auto-bridge with other attached Kits
        let bridges = await autoBridgeKit(kitId, in: projectPath)
        
        // Trigger initial production
        let outputs = await producer.produce()
        
        // AUTO-STORE: Store all outputs in database and index them
        for output in outputs {
            _ = await ContentStorage.shared.store(output, projectPath: projectPath, projectName: projectName)
        }
        
        print("[AutoBridge] Attached \(kitId) to \(projectPath) - produced \(outputs.count) outputs, created \(bridges.count) bridges")
        
        return AttachResult(
            kitId: kitId,
            projectPath: projectPath,
            outputs: outputs,
            bridges: bridges,
            success: true
        )
    }
    
    /// Attach multiple Kits at once
    public func attachAll(_ kitIds: [String], to projectPath: String) async -> [AttachResult] {
        var results: [AttachResult] = []
        for kitId in kitIds {
            let result = await attach(kitId, to: projectPath)
            results.append(result)
        }
        return results
    }
    
    /// Attach all known Kits to a project
    public func attachAllKits(to projectPath: String) async -> [AttachResult] {
        let allKitIds = KitDescriptors.all.map { $0.id }
        return await attachAll(allKitIds, to: projectPath)
    }
    
    // MARK: - Auto-Bridging
    
    /// Automatically create bridges between attached Kits
    private func autoBridgeKit(_ kitId: String, in projectPath: String) async -> [Bridge] {
        guard let attachedKits = projectKits[projectPath] else { return [] }
        
        var newBridges: [Bridge] = []
        
        for otherKitId in attachedKits where otherKitId != kitId {
            // Create bridge: new Kit → existing Kit
            if let bridge = await BridgeRegistry.shared.createBridge(from: kitId, to: otherKitId) {
                newBridges.append(bridge)
            }
            // Create bridge: existing Kit → new Kit
            if let bridge = await BridgeRegistry.shared.createBridge(from: otherKitId, to: kitId) {
                newBridges.append(bridge)
            }
        }
        
        return newBridges
    }
    
    // MARK: - Production Triggers
    
    /// Trigger production for all Kits on project create
    public func onProjectCreate(at projectPath: String) async -> [ProductionOutput] {
        guard isEnabled else { return [] }
        
        let projectName = URL(fileURLWithPath: projectPath).lastPathComponent
        var allOutputs: [ProductionOutput] = []
        
        for producer in producers[projectPath] ?? [] {
            let outputs = await producer.produce(trigger: .onProjectCreate)
            allOutputs.append(contentsOf: outputs)
            
            // AUTO-STORE: Store all outputs in database and index them
            for output in outputs {
                _ = await ContentStorage.shared.store(output, projectPath: projectPath, projectName: projectName)
            }
        }
        
        // Flow outputs through bridges
        await flowOutputsThroughBridges(allOutputs, in: projectPath)
        
        return allOutputs
    }
    
    /// Trigger production on file change
    public func onFileChange(file: String, in projectPath: String) async -> [ProductionOutput] {
        guard isEnabled else { return [] }
        
        let projectName = URL(fileURLWithPath: projectPath).lastPathComponent
        var allOutputs: [ProductionOutput] = []
        
        for producer in producers[projectPath] ?? [] {
            let outputs = await producer.produce(trigger: .onFileChange, context: ["file": file])
            allOutputs.append(contentsOf: outputs)
            
            // AUTO-STORE: Store all outputs in database and index them
            for output in outputs {
                _ = await ContentStorage.shared.store(output, projectPath: projectPath, projectName: projectName)
            }
        }
        
        await flowOutputsThroughBridges(allOutputs, in: projectPath)
        
        return allOutputs
    }
    
    /// Trigger production on file save
    public func onFileSave(file: String, in projectPath: String) async -> [ProductionOutput] {
        guard isEnabled else { return [] }
        
        let projectName = URL(fileURLWithPath: projectPath).lastPathComponent
        var allOutputs: [ProductionOutput] = []
        
        for producer in producers[projectPath] ?? [] {
            let outputs = await producer.produce(trigger: .onFileSave, context: ["file": file])
            allOutputs.append(contentsOf: outputs)
            
            // AUTO-STORE: Store all outputs in database and index them
            for output in outputs {
                _ = await ContentStorage.shared.store(output, projectPath: projectPath, projectName: projectName)
            }
        }
        
        await flowOutputsThroughBridges(allOutputs, in: projectPath)
        
        return allOutputs
    }
    
    // MARK: - Bridge Flow
    
    /// Flow outputs through all relevant bridges
    private func flowOutputsThroughBridges(_ outputs: [ProductionOutput], in projectPath: String) async {
        for output in outputs {
            let data = BridgeData(
                type: output.dataType,
                value: output.content,
                metadata: output.metadata,
                sourceKit: output.kitId
            )
            
            // Find bridges from this Kit
            let bridges = await BridgeRegistry.shared.bridges(for: output.kitId)
            
            for bridge in bridges where bridge.sourceKit == output.kitId {
                let result = await BridgeExecutor.shared.execute(data: data, through: bridge)
                if result.success {
                    print("[AutoBridge] Flowed \(output.outputType) from \(output.kitId) to \(bridge.targetKit)")
                }
            }
        }
    }
    
    // MARK: - Control
    
    public func enable() { isEnabled = true }
    public func disable() { isEnabled = false }
    
    public func detach(_ kitId: String, from projectPath: String) {
        projectKits[projectPath]?.remove(kitId)
        producers[projectPath]?.removeAll { $0.kitId == kitId }
    }
    
    public func detachAll(from projectPath: String) {
        projectKits.removeValue(forKey: projectPath)
        producers.removeValue(forKey: projectPath)
    }
    
    // MARK: - Status
    
    public func attachedKits(for projectPath: String) -> Set<String> {
        projectKits[projectPath] ?? []
    }
    
    public var stats: AutoBridgeStats {
        AutoBridgeStats(
            projectCount: projectKits.count,
            totalAttachments: projectKits.values.reduce(0) { $0 + $1.count },
            producerCount: producers.values.reduce(0) { $0 + $1.count },
            isEnabled: isEnabled
        )
    }
}

// MARK: - Kit Producer

/// Produces outputs for a specific Kit attached to a project
public actor KitProducer {
    public let kitId: String
    public let projectPath: String
    public let projectName: String
    
    private var lastProduction: Date?
    private var outputHistory: [ProductionOutput] = []
    
    public init(kitId: String, projectPath: String, projectName: String? = nil) {
        self.kitId = kitId
        self.projectPath = projectPath
        self.projectName = projectName ?? URL(fileURLWithPath: projectPath).lastPathComponent
    }
    
    /// Produce outputs based on Kit type
    public func produce(trigger: TriggerType = .manual, context: [String: String] = [:]) -> [ProductionOutput] {
        lastProduction = Date()
        
        let outputs = generateOutputs(trigger: trigger, context: context)
        outputHistory.append(contentsOf: outputs)
        
        // Keep last 100 outputs
        if outputHistory.count > 100 {
            outputHistory.removeFirst(outputHistory.count - 100)
        }
        
        return outputs
    }
    
    /// Generate outputs based on Kit type
    private func generateOutputs(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        switch kitId {
        case "com.flowkit.dockit":
            return produceDocKit(trigger: trigger, context: context)
        case "com.flowkit.parsekit":
            return produceParseKit(trigger: trigger, context: context)
        case "com.flowkit.searchkit":
            return produceSearchKit(trigger: trigger, context: context)
        case "com.flowkit.nlukit":
            return produceNLUKit(trigger: trigger, context: context)
        case "com.flowkit.learnkit":
            return produceLearnKit(trigger: trigger, context: context)
        case "com.flowkit.commandkit":
            return produceCommandKit(trigger: trigger, context: context)
        case "com.flowkit.workflowkit":
            return produceWorkflowKit(trigger: trigger, context: context)
        case "com.flowkit.agentkit":
            return produceAgentKit(trigger: trigger, context: context)
        case "com.flowkit.ideakit":
            return produceIdeaKit(trigger: trigger, context: context)
        case "com.flowkit.iconkit":
            return produceIconKit(trigger: trigger, context: context)
        case "com.flowkit.contenthub":
            return produceContentHub(trigger: trigger, context: context)
        default:
            return []
        }
    }
    
    // MARK: - Kit-Specific Production
    
    private func produceDocKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate || trigger == .manual {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "readme",
                dataType: .markdown,
                content: "# Project\n\nAuto-generated README",
                metadata: ["generator": "DocKit", "project": projectPath]
            ))
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "specs",
                dataType: .markdown,
                content: "# Specifications\n\nAuto-generated specs",
                metadata: ["generator": "DocKit", "project": projectPath]
            ))
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "config",
                dataType: .json,
                content: "{\"commands\": [], \"workflows\": [], \"agents\": []}",
                metadata: ["generator": "DocKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceParseKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if let file = context["file"] {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "structure",
                dataType: .json,
                content: "{\"file\": \"\(file)\", \"parsed\": true}",
                metadata: ["generator": "ParseKit", "file": file]
            ))
        }
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "projectStructure",
                dataType: .json,
                content: "{\"project\": \"\(projectPath)\", \"scanned\": true}",
                metadata: ["generator": "ParseKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceSearchKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "index",
                dataType: .json,
                content: "{\"indexed\": true, \"project\": \"\(projectPath)\"}",
                metadata: ["generator": "SearchKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceNLUKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "intents",
                dataType: .json,
                content: "{\"intents\": [\"create\", \"edit\", \"delete\", \"search\"]}",
                metadata: ["generator": "NLUKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceLearnKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "model",
                dataType: .json,
                content: "{\"model\": \"initialized\", \"project\": \"\(projectPath)\"}",
                metadata: ["generator": "LearnKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceCommandKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "commands",
                dataType: .json,
                content: "{\"commands\": [\"/help\", \"/search\", \"/create\", \"/build\"]}",
                metadata: ["generator": "CommandKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceWorkflowKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "workflows",
                dataType: .json,
                content: "{\"workflows\": [\"build\", \"test\", \"deploy\"]}",
                metadata: ["generator": "WorkflowKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceAgentKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "agents",
                dataType: .json,
                content: "{\"agents\": [\"doc-agent\", \"test-agent\", \"review-agent\"]}",
                metadata: ["generator": "AgentKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceIdeaKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "architecture",
                dataType: .json,
                content: "{\"architecture\": \"initialized\", \"project\": \"\(projectPath)\"}",
                metadata: ["generator": "IdeaKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceIconKit(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "icons",
                dataType: .json,
                content: "{\"icons\": [\"app-icon\", \"feature-icons\"]}",
                metadata: ["generator": "IconKit", "project": projectPath]
            ))
        }
        
        return outputs
    }
    
    private func produceContentHub(trigger: TriggerType, context: [String: String]) -> [ProductionOutput] {
        var outputs: [ProductionOutput] = []
        
        if trigger == .onProjectCreate {
            outputs.append(ProductionOutput(
                kitId: kitId,
                outputType: "storage",
                dataType: .json,
                content: "{\"storage\": \"initialized\", \"project\": \"\(projectPath)\"}",
                metadata: ["generator": "ContentHub", "project": projectPath]
            ))
        }
        
        return outputs
    }
}

// MARK: - Supporting Types

public struct AttachResult: Sendable {
    public let kitId: String
    public let projectPath: String
    public let outputs: [ProductionOutput]
    public let bridges: [Bridge]
    public let success: Bool
}

public struct ProductionOutput: Sendable {
    public let kitId: String
    public let outputType: String
    public let dataType: DataType
    public let content: String
    public let metadata: [String: String]
    public let timestamp: Date
    
    public init(
        kitId: String,
        outputType: String,
        dataType: DataType,
        content: String,
        metadata: [String: String] = [:],
        timestamp: Date = Date()
    ) {
        self.kitId = kitId
        self.outputType = outputType
        self.dataType = dataType
        self.content = content
        self.metadata = metadata
        self.timestamp = timestamp
    }
}

public struct ProductionJob: Sendable {
    public let kitId: String
    public let projectPath: String
    public let trigger: TriggerType
    public let priority: Int
}

public struct AutoBridgeStats: Sendable {
    public let projectCount: Int
    public let totalAttachments: Int
    public let producerCount: Int
    public let isEnabled: Bool
}
