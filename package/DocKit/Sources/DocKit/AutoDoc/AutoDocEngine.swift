//
//  AutoDocEngine.swift
//  DocKit
//
//  Automatic Documentation Generation Engine
//  Generates all documentation when a project is created or packages are attached
//

import Foundation

/// AutoDocEngine - Automatic documentation generation for projects
public actor AutoDocEngine {
    public static let shared = AutoDocEngine()
    
    private init() {}
    
    /// Generate all documentation for a project
    public func generateAll(for project: ProjectContext) async -> GenerationReport {
        let startTime = Date()
        var generatedFiles: [GeneratedFile] = []
        var errors: [String] = []
        
        // Generate README
        let readme = generateREADME(for: project)
        generatedFiles.append(GeneratedFile(type: .readme, content: readme))
        
        // Generate Design Doc
        let design = generateDesign(for: project)
        generatedFiles.append(GeneratedFile(type: .design, content: design))
        
        // Generate Requirements
        let requirements = generateRequirements(for: project)
        generatedFiles.append(GeneratedFile(type: .requirements, content: requirements))
        
        // Generate Tasks
        let tasks = generateTasks(for: project)
        generatedFiles.append(GeneratedFile(type: .tasks, content: tasks))
        
        // Generate Specs
        let specs = generateSpecs(for: project)
        generatedFiles.append(GeneratedFile(type: .specs, content: specs))
        
        // Generate JSON configs
        let commands = generateCommands(for: project)
        generatedFiles.append(GeneratedFile(type: .commands, content: commands))
        
        let workflows = generateWorkflows(for: project)
        generatedFiles.append(GeneratedFile(type: .workflows, content: workflows))
        
        let actions = generateActions(for: project)
        generatedFiles.append(GeneratedFile(type: .actions, content: actions))
        
        let scripts = generateScripts(for: project)
        generatedFiles.append(GeneratedFile(type: .scripts, content: scripts))
        
        let agents = generateAgents(for: project)
        generatedFiles.append(GeneratedFile(type: .agents, content: agents))
        
        return GenerationReport(
            projectId: project.id,
            projectName: project.name,
            generatedFiles: generatedFiles,
            errors: errors,
            duration: Date().timeIntervalSince(startTime),
            generatedAt: Date()
        )
    }
    
    // MARK: - Individual Generators
    
    private func generateREADME(for project: ProjectContext) -> String {
        let info = ProjectInfo(
            name: project.name,
            description: project.description,
            version: project.version,
            author: project.author,
            features: project.features,
            dependencies: project.dependencies
        )
        return READMEGenerator.generate(for: info)
    }
    
    private func generateDesign(for project: ProjectContext) -> String {
        let input = DesignDocGenerator.DesignInput(
            projectName: project.name,
            objective: project.description,
            constraints: project.constraints,
            decisions: project.decisions.map {
                DesignDocGenerator.Decision(title: $0.title, description: $0.description, rationale: $0.rationale)
            }
        )
        return DesignDocGenerator.generate(from: input)
    }
    
    private func generateRequirements(for project: ProjectContext) -> String {
        let input = RequirementsGenerator.RequirementsInput(
            projectName: project.name,
            functionalRequirements: project.functionalRequirements.enumerated().map { index, req in
                RequirementsGenerator.Requirement(
                    id: "FR-\(String(format: "%03d", index + 1))",
                    title: req.title,
                    description: req.description,
                    acceptanceCriteria: req.acceptanceCriteria
                )
            },
            nonFunctionalRequirements: project.nonFunctionalRequirements.enumerated().map { index, req in
                RequirementsGenerator.Requirement(
                    id: "NFR-\(String(format: "%03d", index + 1))",
                    title: req.title,
                    description: req.description
                )
            },
            dependencies: project.dependencies,
            owner: project.author ?? ""
        )
        return RequirementsGenerator.generate(from: input)
    }
    
    private func generateTasks(for project: ProjectContext) -> String {
        let input = TasksGenerator.TasksInput(
            projectName: project.name,
            description: "Task list for \(project.name)",
            tasks: project.tasks.map {
                TasksGenerator.TaskItem(
                    title: $0.title,
                    description: $0.description,
                    status: TasksGenerator.TaskStatus(rawValue: $0.status) ?? .todo,
                    priority: TasksGenerator.TaskPriority(rawValue: $0.priority) ?? .medium,
                    assignee: $0.assignee
                )
            },
            owner: project.author ?? ""
        )
        return TasksGenerator.generate(from: input)
    }
    
    private func generateSpecs(for project: ProjectContext) -> String {
        let input = SpecsGenerator.SpecsInput(
            projectName: project.name,
            version: project.version,
            overview: project.description,
            features: project.features.map {
                SpecsGenerator.FeatureSpec(name: $0, description: "Feature: \($0)")
            },
            dataModels: project.dataModels.map {
                SpecsGenerator.DataModelSpec(name: $0.name, description: $0.description, properties: $0.properties.map {
                    SpecsGenerator.DataModelSpec.Property(name: $0.name, type: $0.type, description: $0.description)
                })
            }
        )
        return SpecsGenerator.generate(from: input)
    }
    
    private func generateCommands(for project: ProjectContext) -> String {
        let defaultCommands = [
            ConfigGenerator.CommandConfig(name: "build", description: "Build the project", syntax: "/build [target]", category: "build", icon: "hammer"),
            ConfigGenerator.CommandConfig(name: "test", description: "Run tests", syntax: "/test [filter]", category: "test", icon: "checkmark.circle"),
            ConfigGenerator.CommandConfig(name: "run", description: "Run the project", syntax: "/run [args]", category: "run", icon: "play.fill"),
            ConfigGenerator.CommandConfig(name: "docs", description: "Generate documentation", syntax: "/docs [format]", category: "docs", icon: "doc.text"),
            ConfigGenerator.CommandConfig(name: "clean", description: "Clean build artifacts", syntax: "/clean", category: "build", icon: "trash")
        ]
        return ConfigGenerator.generateCommands(project.commands.isEmpty ? defaultCommands : project.commands, projectName: project.name)
    }
    
    private func generateWorkflows(for project: ProjectContext) -> String {
        let defaultWorkflows = [
            ConfigGenerator.WorkflowConfig(
                id: "build-workflow",
                name: "Build",
                description: "Standard build workflow",
                trigger: "manual",
                steps: [
                    ConfigGenerator.WorkflowStep(name: "Clean", action: "clean"),
                    ConfigGenerator.WorkflowStep(name: "Build", action: "build"),
                    ConfigGenerator.WorkflowStep(name: "Test", action: "test")
                ]
            ),
            ConfigGenerator.WorkflowConfig(
                id: "release-workflow",
                name: "Release",
                description: "Release workflow",
                trigger: "onTag",
                steps: [
                    ConfigGenerator.WorkflowStep(name: "Build", action: "build", parameters: ["configuration": "release"]),
                    ConfigGenerator.WorkflowStep(name: "Test", action: "test"),
                    ConfigGenerator.WorkflowStep(name: "Package", action: "package")
                ]
            )
        ]
        return ConfigGenerator.generateWorkflows(project.workflows.isEmpty ? defaultWorkflows : project.workflows, projectName: project.name)
    }
    
    private func generateActions(for project: ProjectContext) -> String {
        let defaultActions = [
            ConfigGenerator.ActionConfig(id: "build", name: "Build", description: "Build the project", type: "shell", handler: "swift build"),
            ConfigGenerator.ActionConfig(id: "test", name: "Test", description: "Run tests", type: "shell", handler: "swift test"),
            ConfigGenerator.ActionConfig(id: "clean", name: "Clean", description: "Clean build", type: "shell", handler: "swift package clean")
        ]
        return ConfigGenerator.generateActions(project.actions.isEmpty ? defaultActions : project.actions, projectName: project.name)
    }
    
    private func generateScripts(for project: ProjectContext) -> String {
        let defaultScripts = [
            ConfigGenerator.ScriptConfig(id: "setup", name: "Setup", description: "Setup development environment", language: "bash", path: "scripts/setup.sh"),
            ConfigGenerator.ScriptConfig(id: "deploy", name: "Deploy", description: "Deploy to production", language: "bash", path: "scripts/deploy.sh")
        ]
        return ConfigGenerator.generateScripts(project.scripts.isEmpty ? defaultScripts : project.scripts, projectName: project.name)
    }
    
    private func generateAgents(for project: ProjectContext) -> String {
        let defaultAgents = [
            ConfigGenerator.AgentConfig(
                id: "doc-agent",
                name: "Documentation Agent",
                description: "Automatically updates documentation",
                type: "documentation",
                triggers: [ConfigGenerator.AgentTrigger(type: "fileChange", condition: "*.swift")],
                actions: ["generateDocs"]
            ),
            ConfigGenerator.AgentConfig(
                id: "test-agent",
                name: "Test Agent",
                description: "Runs tests on changes",
                type: "testing",
                triggers: [ConfigGenerator.AgentTrigger(type: "fileChange", condition: "Sources/**/*.swift")],
                actions: ["runTests"]
            )
        ]
        return ConfigGenerator.generateAgents(project.agents.isEmpty ? defaultAgents : project.agents, projectName: project.name)
    }
}

// MARK: - Supporting Types

public struct ProjectContext: Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let version: String
    public let author: String?
    public let features: [String]
    public let dependencies: [String]
    public let constraints: [String]
    public let decisions: [DecisionContext]
    public let functionalRequirements: [RequirementContext]
    public let nonFunctionalRequirements: [RequirementContext]
    public let tasks: [TaskContext]
    public let dataModels: [DataModelContext]
    public let commands: [ConfigGenerator.CommandConfig]
    public let workflows: [ConfigGenerator.WorkflowConfig]
    public let actions: [ConfigGenerator.ActionConfig]
    public let scripts: [ConfigGenerator.ScriptConfig]
    public let agents: [ConfigGenerator.AgentConfig]
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String = "",
        version: String = "1.0.0",
        author: String? = nil,
        features: [String] = [],
        dependencies: [String] = [],
        constraints: [String] = [],
        decisions: [DecisionContext] = [],
        functionalRequirements: [RequirementContext] = [],
        nonFunctionalRequirements: [RequirementContext] = [],
        tasks: [TaskContext] = [],
        dataModels: [DataModelContext] = [],
        commands: [ConfigGenerator.CommandConfig] = [],
        workflows: [ConfigGenerator.WorkflowConfig] = [],
        actions: [ConfigGenerator.ActionConfig] = [],
        scripts: [ConfigGenerator.ScriptConfig] = [],
        agents: [ConfigGenerator.AgentConfig] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.version = version
        self.author = author
        self.features = features
        self.dependencies = dependencies
        self.constraints = constraints
        self.decisions = decisions
        self.functionalRequirements = functionalRequirements
        self.nonFunctionalRequirements = nonFunctionalRequirements
        self.tasks = tasks
        self.dataModels = dataModels
        self.commands = commands
        self.workflows = workflows
        self.actions = actions
        self.scripts = scripts
        self.agents = agents
    }
}

public struct DecisionContext: Sendable {
    public let title: String
    public let description: String
    public let rationale: String
    
    public init(title: String, description: String, rationale: String) {
        self.title = title
        self.description = description
        self.rationale = rationale
    }
}

public struct RequirementContext: Sendable {
    public let title: String
    public let description: String
    public let acceptanceCriteria: [String]
    
    public init(title: String, description: String, acceptanceCriteria: [String] = []) {
        self.title = title
        self.description = description
        self.acceptanceCriteria = acceptanceCriteria
    }
}

public struct TaskContext: Sendable {
    public let title: String
    public let description: String
    public let status: String
    public let priority: String
    public let assignee: String?
    
    public init(title: String, description: String = "", status: String = "To Do", priority: String = "Medium", assignee: String? = nil) {
        self.title = title
        self.description = description
        self.status = status
        self.priority = priority
        self.assignee = assignee
    }
}

public struct DataModelContext: Sendable {
    public let name: String
    public let description: String
    public let properties: [PropertyContext]
    
    public init(name: String, description: String, properties: [PropertyContext] = []) {
        self.name = name
        self.description = description
        self.properties = properties
    }
    
    public struct PropertyContext: Sendable {
        public let name: String
        public let type: String
        public let description: String
        
        public init(name: String, type: String, description: String) {
            self.name = name
            self.type = type
            self.description = description
        }
    }
}

// MARK: - Generation Report

public struct GenerationReport: Sendable {
    public let projectId: String
    public let projectName: String
    public let generatedFiles: [GeneratedFile]
    public let errors: [String]
    public let duration: TimeInterval
    public let generatedAt: Date
    
    public var success: Bool { errors.isEmpty }
    public var fileCount: Int { generatedFiles.count }
}

public struct GeneratedFile: Sendable {
    public enum FileType: String, Sendable {
        case readme, design, requirements, tasks, specs
        case commands, workflows, actions, scripts, agents
        case changelog, api
        
        public var fileName: String {
            switch self {
            case .readme: return "README.md"
            case .design: return "design.md"
            case .requirements: return "requirements.md"
            case .tasks: return "tasks.md"
            case .specs: return "specs.md"
            case .commands: return "commands.json"
            case .workflows: return "workflows.json"
            case .actions: return "actions.json"
            case .scripts: return "scripts.json"
            case .agents: return "agents.json"
            case .changelog: return "CHANGELOG.md"
            case .api: return "api.md"
            }
        }
    }
    
    public let type: FileType
    public let content: String
    
    public var fileName: String { type.fileName }
}
