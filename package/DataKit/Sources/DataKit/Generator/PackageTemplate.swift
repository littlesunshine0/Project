//
//  PackageTemplate.swift
//  DataKit
//
//  Template for creating new packages with all canonical files
//  Use this as the gold standard for package structure
//

import Foundation

// MARK: - Package Template

public struct PackageTemplate {
    
    /// Generate all canonical JSON content for a package
    public static func generateAllFiles(
        id: String,
        name: String,
        category: PackageCategory,
        description: String,
        nodes: [String],
        dependencies: [String] = ["DataKit"]
    ) -> PackageFiles {
        
        let contract = PackageGenerator.generate(
            id: id,
            name: name,
            category: category,
            description: description,
            nodes: nodes,
            dependencies: dependencies
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        return PackageFiles(
            manifest: (try? encoder.encode(contract.manifest)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}",
            capabilities: (try? encoder.encode(contract.capabilities)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}",
            state: (try? encoder.encode(contract.state)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}",
            actions: (try? encoder.encode(contract.actions)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}",
            ui: (try? encoder.encode(contract.ui)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}",
            agents: (try? encoder.encode(contract.agents)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}",
            workflows: (try? encoder.encode(contract.workflows)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}",
            readme: generateReadme(name: name, description: description, contract: contract),
            contractSwift: generateContractSwift(name: name, id: id)
        )
    }
    
    // MARK: - README Generation
    
    private static func generateReadme(name: String, description: String, contract: PackageContract) -> String {
        """
        # \(name)
        
        \(description)
        
        ## Overview
        
        \(name) is part of the FlowKit Package Operating System. It provides:
        
        - **\(contract.capabilities.nodes.count) Node Types**: \(contract.capabilities.nodes.joined(separator: ", "))
        - **\(contract.actions.actions.count) Actions**: CRUD operations and more
        - **\(contract.agents.agents.count) Agents**: Intelligent automation
        - **\(contract.workflows.workflows.count) Workflows**: Pre-built automation sequences
        
        ## Installation
        
        Add to your `Package.swift`:
        
        ```swift
        dependencies: [
            .package(path: "../\(name)")
        ]
        ```
        
        ## Quick Start
        
        ```swift
        import \(name)
        import DataKit
        
        // Register the package
        await \(name)Contract.shared.register()
        
        // Run the system
        try await runPackageSystem()
        ```
        
        ## Actions
        
        \(contract.actions.actions.map { "- `\($0.id)`: \($0.description)" }.joined(separator: "\n"))
        
        ## Agents
        
        \(contract.agents.agents.map { "- **\($0.name)**: \($0.description)" }.joined(separator: "\n"))
        
        ## Workflows
        
        \(contract.workflows.workflows.map { "- **\($0.name)**: \($0.description)" }.joined(separator: "\n"))
        
        ## Dependencies
        
        \(contract.manifest.dependencies.map { "- \($0)" }.joined(separator: "\n"))
        
        ## License
        
        MIT
        """
    }
    
    // MARK: - Contract Swift Generation
    
    private static func generateContractSwift(name: String, id: String) -> String {
        """
        //
        //  \(name)Contract.swift
        //  \(name)
        //
        //  Package contract - loads from canonical JSON files
        //
        
        import Foundation
        import DataKit
        
        public struct \(name)Contract {
            public static let shared = \(name)Contract()
            
            public let contract: PackageContract
            
            private init() {
                contract = Self.loadContract()
            }
            
            public func register() async {
                try? await PackageOrchestrator.shared.attachPackage(contract)
                await MLIndexer.shared.indexPackage(contract)
            }
            
            private static func loadContract() -> PackageContract {
                let bundle = Bundle.module
                
                guard let manifestURL = bundle.url(forResource: "Package.manifest", withExtension: "json"),
                      let manifestData = try? Data(contentsOf: manifestURL),
                      let manifest = try? JSONDecoder().decode(PackageManifest.self, from: manifestData) else {
                    return PackageGenerator.generate(
                        id: "\(id)",
                        name: "\(name)",
                        category: .utility,
                        description: "\(name) package"
                    )
                }
                
                let capabilities = loadJSON(PackageCapabilities.self, "Package.capabilities", bundle) ?? PackageCapabilities()
                let state = loadJSON(PackageState.self, "Package.state", bundle) ?? PackageState()
                let actions = loadJSON(PackageActions.self, "Package.actions", bundle) ?? PackageActions()
                let ui = loadJSON(PackageUI.self, "Package.ui", bundle) ?? PackageUI()
                let agents = loadJSON(PackageAgents.self, "Package.agents", bundle) ?? PackageAgents()
                let workflows = loadJSON(PackageWorkflows.self, "Package.workflows", bundle) ?? PackageWorkflows()
                
                return PackageContract(
                    manifest: manifest,
                    capabilities: capabilities,
                    state: state,
                    actions: actions,
                    ui: ui,
                    agents: agents,
                    workflows: workflows
                )
            }
            
            private static func loadJSON<T: Decodable>(_ type: T.Type, _ name: String, _ bundle: Bundle) -> T? {
                guard let url = bundle.url(forResource: name, withExtension: "json"),
                      let data = try? Data(contentsOf: url) else { return nil }
                return try? JSONDecoder().decode(type, from: data)
            }
        }
        """
    }
}

// MARK: - Package Files

public struct PackageFiles {
    public let manifest: String
    public let capabilities: String
    public let state: String
    public let actions: String
    public let ui: String
    public let agents: String
    public let workflows: String
    public let readme: String
    public let contractSwift: String
    
    /// All JSON files as a dictionary
    public var jsonFiles: [String: String] {
        [
            "Package.manifest.json": manifest,
            "Package.capabilities.json": capabilities,
            "Package.state.json": state,
            "Package.actions.json": actions,
            "Package.ui.json": ui,
            "Package.agents.json": agents,
            "Package.workflows.json": workflows
        ]
    }
    
    /// All files including README and Swift
    public var allFiles: [String: String] {
        var files = jsonFiles
        files["README.md"] = readme
        files["Contract.swift"] = contractSwift
        return files
    }
}

// MARK: - Batch Generation

public extension PackageTemplate {
    
    /// Generate contracts for multiple packages at once
    static func generateBatch(_ configs: [PackageConfig]) -> [String: PackageFiles] {
        var results: [String: PackageFiles] = [:]
        
        for config in configs {
            let files = generateAllFiles(
                id: config.id,
                name: config.name,
                category: config.category,
                description: config.description,
                nodes: config.nodes,
                dependencies: config.dependencies
            )
            results[config.name] = files
        }
        
        return results
    }
}

public struct PackageConfig {
    public let id: String
    public let name: String
    public let category: PackageCategory
    public let description: String
    public let nodes: [String]
    public let dependencies: [String]
    
    public init(
        id: String,
        name: String,
        category: PackageCategory,
        description: String,
        nodes: [String] = [],
        dependencies: [String] = ["DataKit"]
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.nodes = nodes
        self.dependencies = dependencies
    }
}

// MARK: - All Package Configs

public let allPackageConfigs: [PackageConfig] = [
    PackageConfig(id: "com.flowkit.commandkit", name: "CommandKit", category: .core, description: "Command parsing, execution, and automation", nodes: ["Command", "Template", "Macro"]),
    PackageConfig(id: "com.flowkit.workflowkit", name: "WorkflowKit", category: .automation, description: "Workflow creation and execution", nodes: ["Workflow", "Step", "Trigger"]),
    PackageConfig(id: "com.flowkit.agentkit", name: "AgentKit", category: .ai, description: "AI agents and intelligent automation", nodes: ["Agent", "Task", "Memory"]),
    PackageConfig(id: "com.flowkit.dockit", name: "DocKit", category: .content, description: "Documentation generation and management", nodes: ["Document", "Section", "Template"]),
    PackageConfig(id: "com.flowkit.chatkit", name: "ChatKit", category: .ai, description: "Chat interface and AI conversations", nodes: ["Chat", "Message", "Context"]),
    PackageConfig(id: "com.flowkit.searchkit", name: "SearchKit", category: .utility, description: "Search and indexing", nodes: ["Query", "Result", "Index"]),
    PackageConfig(id: "com.flowkit.knowledgekit", name: "KnowledgeKit", category: .data, description: "Knowledge base and information management", nodes: ["Knowledge", "Topic", "Reference"]),
    PackageConfig(id: "com.flowkit.learnkit", name: "LearnKit", category: .content, description: "Learning and tutorials", nodes: ["Lesson", "Course", "Progress"]),
    PackageConfig(id: "com.flowkit.designkit", name: "DesignKit", category: .ui, description: "Design system and UI components", nodes: ["Component", "Style", "Theme"]),
    PackageConfig(id: "com.flowkit.analyticskit", name: "AnalyticsKit", category: .analytics, description: "Analytics and metrics", nodes: ["Event", "Metric", "Report"]),
    PackageConfig(id: "com.flowkit.feedbackkit", name: "FeedbackKit", category: .social, description: "User feedback and ratings", nodes: ["Feedback", "Rating", "Survey"]),
    PackageConfig(id: "com.flowkit.notificationkit", name: "NotificationKit", category: .utility, description: "Notifications and alerts", nodes: ["Notification", "Alert", "Badge"]),
    PackageConfig(id: "com.flowkit.filekit", name: "FileKit", category: .data, description: "File management and operations", nodes: ["File", "Folder", "Operation"]),
    PackageConfig(id: "com.flowkit.exportkit", name: "ExportKit", category: .utility, description: "Export and format conversion", nodes: ["Export", "Format", "Template"]),
    PackageConfig(id: "com.flowkit.aikit", name: "AIKit", category: .ai, description: "AI services and ML integration", nodes: ["Model", "Prediction", "Embedding"]),
    PackageConfig(id: "com.flowkit.nlukit", name: "NLUKit", category: .ai, description: "Natural language understanding", nodes: ["Intent", "Entity", "Context"]),
    PackageConfig(id: "com.flowkit.navigationkit", name: "NavigationKit", category: .ui, description: "Navigation and routing", nodes: ["Route", "Screen", "Tab"]),
    PackageConfig(id: "com.flowkit.networkkit", name: "NetworkKit", category: .integration, description: "Network and API integration", nodes: ["Request", "Response", "Endpoint"]),
    PackageConfig(id: "com.flowkit.userkit", name: "UserKit", category: .core, description: "User management and preferences", nodes: ["User", "Preference", "Session"]),
    PackageConfig(id: "com.flowkit.collaborationkit", name: "CollaborationKit", category: .social, description: "Collaboration and sharing", nodes: ["Share", "Comment", "Version"])
]
