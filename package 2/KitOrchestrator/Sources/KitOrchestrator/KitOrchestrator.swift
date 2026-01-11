//
//  KitOrchestrator.swift
//  KitOrchestrator
//
//  Automatic Kit Coordination System
//  When Kits are added to a project, they automatically work together
//

import Foundation

/// KitOrchestrator - Coordinates all Kits to work together automatically
public actor KitOrchestrator {
    public static let shared = KitOrchestrator()
    
    private var registeredKits: [KitRegistration] = []
    private var activeProjects: [String: ProjectSession] = [:]
    private var eventHandlers: [KitEvent: [(KitEventData) async -> Void]] = [:]
    
    private init() {}
    
    // MARK: - Kit Registration
    
    /// Register a Kit with the orchestrator
    public func register(_ kit: KitRegistration) {
        registeredKits.append(kit)
        print("🔧 KitOrchestrator: Registered \(kit.name)")
    }
    
    /// Get all registered Kits
    public func getRegisteredKits() -> [KitRegistration] {
        registeredKits
    }
    
    // MARK: - Project Lifecycle
    
    /// Called when a new project is created - triggers automatic Kit activation
    public func onProjectCreated(_ project: ProjectInfo) async -> ProjectSession {
        print("🚀 KitOrchestrator: New project created - \(project.name)")
        
        let session = ProjectSession(
            id: UUID().uuidString,
            project: project,
            attachedKits: [],
            createdAt: Date()
        )
        
        activeProjects[project.id] = session
        
        // Auto-attach all registered Kits
        for kit in registeredKits {
            await attachKit(kit.id, to: project.id)
        }
        
        // Emit project created event
        await emit(.projectCreated, data: KitEventData(projectId: project.id, kitId: nil, payload: ["name": project.name]))
        
        // Trigger automatic content generation
        await triggerAutoGeneration(for: project.id)
        
        return session
    }
    
    /// Attach a Kit to a project
    public func attachKit(_ kitId: String, to projectId: String) async {
        guard var session = activeProjects[projectId],
              let kit = registeredKits.first(where: { $0.id == kitId }) else { return }
        
        if !session.attachedKits.contains(kitId) {
            session.attachedKits.append(kitId)
            activeProjects[projectId] = session
            
            print("📦 KitOrchestrator: Attached \(kit.name) to project \(projectId)")
            
            // Emit kit attached event
            await emit(.kitAttached, data: KitEventData(projectId: projectId, kitId: kitId, payload: [:]))
            
            // Run Kit's onAttach hook
            if let onAttach = kit.hooks.onAttach {
                await onAttach(projectId)
            }
        }
    }
    
    /// Detach a Kit from a project
    public func detachKit(_ kitId: String, from projectId: String) async {
        guard var session = activeProjects[projectId],
              let kit = registeredKits.first(where: { $0.id == kitId }) else { return }
        
        session.attachedKits.removeAll { $0 == kitId }
        activeProjects[projectId] = session
        
        // Run Kit's onDetach hook
        if let onDetach = kit.hooks.onDetach {
            await onDetach(projectId)
        }
        
        await emit(.kitDetached, data: KitEventData(projectId: projectId, kitId: kitId, payload: [:]))
    }
    
    // MARK: - Automatic Generation Pipeline
    
    /// Trigger automatic content generation for a project
    public func triggerAutoGeneration(for projectId: String) async {
        guard let session = activeProjects[projectId] else { return }
        
        print("⚡ KitOrchestrator: Starting auto-generation pipeline for \(session.project.name)")
        
        var pipeline = GenerationPipeline(projectId: projectId, steps: [])
        
        // Build pipeline based on attached Kits
        for kitId in session.attachedKits {
            guard let kit = registeredKits.first(where: { $0.id == kitId }) else { continue }
            
            for capability in kit.capabilities {
                switch capability {
                case .documentGeneration:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "generateDocs",
                        priority: 1,
                        dependencies: []
                    ))
                case .codeAnalysis:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "analyzeCode",
                        priority: 0,
                        dependencies: []
                    ))
                case .contentIndexing:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "indexContent",
                        priority: 2,
                        dependencies: ["generateDocs"]
                    ))
                case .intentClassification:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "classifyIntents",
                        priority: 3,
                        dependencies: ["indexContent"]
                    ))
                case .workflowOrchestration:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "setupWorkflows",
                        priority: 4,
                        dependencies: []
                    ))
                case .agentManagement:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "configureAgents",
                        priority: 5,
                        dependencies: ["setupWorkflows"]
                    ))
                case .machineLearning:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "trainModels",
                        priority: 6,
                        dependencies: ["indexContent"]
                    ))
                case .commandParsing:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "registerCommands",
                        priority: 1,
                        dependencies: []
                    ))
                case .fileParsing:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "parseFiles",
                        priority: 0,
                        dependencies: []
                    ))
                case .iconGeneration:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "generateIcons",
                        priority: 7,
                        dependencies: []
                    ))
                case .contentStorage:
                    pipeline.steps.append(PipelineStep(
                        kitId: kitId,
                        action: "storeContent",
                        priority: 8,
                        dependencies: ["generateDocs", "indexContent"]
                    ))
                }
            }
        }
        
        // Execute pipeline
        await executePipeline(pipeline, session: session)
    }
    
    private func executePipeline(_ pipeline: GenerationPipeline, session: ProjectSession) async {
        // Sort by priority
        let sortedSteps = pipeline.steps.sorted { $0.priority < $1.priority }
        var completedActions: Set<String> = []
        
        for step in sortedSteps {
            // Check dependencies
            let dependenciesMet = step.dependencies.allSatisfy { completedActions.contains($0) }
            guard dependenciesMet else {
                print("⏳ Skipping \(step.action) - dependencies not met")
                continue
            }
            
            guard let kit = registeredKits.first(where: { $0.id == step.kitId }) else { continue }
            
            print("▶️ Executing: \(kit.name).\(step.action)")
            
            // Execute the action
            if let executor = kit.hooks.onExecute {
                await executor(step.action, session.project)
            }
            
            completedActions.insert(step.action)
            
            // Emit step completed event
            await emit(.pipelineStepCompleted, data: KitEventData(
                projectId: pipeline.projectId,
                kitId: step.kitId,
                payload: ["action": step.action]
            ))
        }
        
        print("✅ KitOrchestrator: Pipeline completed for \(session.project.name)")
        await emit(.pipelineCompleted, data: KitEventData(projectId: pipeline.projectId, kitId: nil, payload: [:]))
    }
    
    // MARK: - Event System
    
    /// Subscribe to Kit events
    public func on(_ event: KitEvent, handler: @escaping (KitEventData) async -> Void) {
        eventHandlers[event, default: []].append(handler)
    }
    
    /// Emit an event to all subscribers
    private func emit(_ event: KitEvent, data: KitEventData) async {
        guard let handlers = eventHandlers[event] else { return }
        for handler in handlers {
            await handler(data)
        }
    }
    
    // MARK: - File Change Watching
    
    /// Called when a file changes in a project
    public func onFileChanged(_ file: FileChange, in projectId: String) async {
        guard let session = activeProjects[projectId] else { return }
        
        // Notify relevant Kits
        for kitId in session.attachedKits {
            guard let kit = registeredKits.first(where: { $0.id == kitId }) else { continue }
            
            if let onFileChange = kit.hooks.onFileChange {
                await onFileChange(file, projectId)
            }
        }
        
        await emit(.fileChanged, data: KitEventData(
            projectId: projectId,
            kitId: nil,
            payload: ["path": file.path, "type": file.changeType.rawValue]
        ))
    }
    
    // MARK: - Inter-Kit Communication
    
    /// Send a message from one Kit to another
    public func sendMessage(from sourceKit: String, to targetKit: String, message: KitMessage) async {
        guard let kit = registeredKits.first(where: { $0.id == targetKit }) else { return }
        
        if let onMessage = kit.hooks.onMessage {
            await onMessage(sourceKit, message)
        }
    }
    
    /// Broadcast a message to all Kits
    public func broadcast(from sourceKit: String, message: KitMessage) async {
        for kit in registeredKits where kit.id != sourceKit {
            if let onMessage = kit.hooks.onMessage {
                await onMessage(sourceKit, message)
            }
        }
    }
}

// MARK: - Supporting Types

public struct KitRegistration: Sendable {
    public let id: String
    public let name: String
    public let version: String
    public let capabilities: [KitCapability]
    public let hooks: KitHooks
    
    public init(
        id: String,
        name: String,
        version: String,
        capabilities: [KitCapability],
        hooks: KitHooks
    ) {
        self.id = id
        self.name = name
        self.version = version
        self.capabilities = capabilities
        self.hooks = hooks
    }
}

public enum KitCapability: String, Sendable, CaseIterable {
    case documentGeneration
    case codeAnalysis
    case contentIndexing
    case intentClassification
    case workflowOrchestration
    case agentManagement
    case machineLearning
    case commandParsing
    case fileParsing
    case iconGeneration
    case contentStorage
}

public struct KitHooks: Sendable {
    public let onAttach: (@Sendable (String) async -> Void)?
    public let onDetach: (@Sendable (String) async -> Void)?
    public let onExecute: (@Sendable (String, ProjectInfo) async -> Void)?
    public let onFileChange: (@Sendable (FileChange, String) async -> Void)?
    public let onMessage: (@Sendable (String, KitMessage) async -> Void)?
    
    public init(
        onAttach: (@Sendable (String) async -> Void)? = nil,
        onDetach: (@Sendable (String) async -> Void)? = nil,
        onExecute: (@Sendable (String, ProjectInfo) async -> Void)? = nil,
        onFileChange: (@Sendable (FileChange, String) async -> Void)? = nil,
        onMessage: (@Sendable (String, KitMessage) async -> Void)? = nil
    ) {
        self.onAttach = onAttach
        self.onDetach = onDetach
        self.onExecute = onExecute
        self.onFileChange = onFileChange
        self.onMessage = onMessage
    }
}

public struct ProjectInfo: Sendable {
    public let id: String
    public let name: String
    public let path: String
    public let description: String
    public let metadata: [String: String]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        path: String,
        description: String = "",
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.name = name
        self.path = path
        self.description = description
        self.metadata = metadata
    }
}

public struct ProjectSession: Sendable {
    public let id: String
    public let project: ProjectInfo
    public var attachedKits: [String]
    public let createdAt: Date
}

public struct FileChange: Sendable {
    public let path: String
    public let changeType: ChangeType
    public let content: String?
    
    public enum ChangeType: String, Sendable {
        case created, modified, deleted
    }
    
    public init(path: String, changeType: ChangeType, content: String? = nil) {
        self.path = path
        self.changeType = changeType
        self.content = content
    }
}

public struct KitMessage: Sendable {
    public let type: String
    public let payload: [String: String]
    
    public init(type: String, payload: [String: String] = [:]) {
        self.type = type
        self.payload = payload
    }
}

public enum KitEvent: String, Sendable {
    case projectCreated
    case kitAttached
    case kitDetached
    case fileChanged
    case pipelineStepCompleted
    case pipelineCompleted
    case contentGenerated
    case contentIndexed
}

public struct KitEventData: Sendable {
    public let projectId: String
    public let kitId: String?
    public let payload: [String: String]
    public let timestamp: Date
    
    public init(projectId: String, kitId: String?, payload: [String: String]) {
        self.projectId = projectId
        self.kitId = kitId
        self.payload = payload
        self.timestamp = Date()
    }
}

struct GenerationPipeline {
    let projectId: String
    var steps: [PipelineStep]
}

struct PipelineStep {
    let kitId: String
    let action: String
    let priority: Int
    let dependencies: [String]
}
