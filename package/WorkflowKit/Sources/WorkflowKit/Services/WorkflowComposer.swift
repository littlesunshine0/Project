//
//  WorkflowComposer.swift
//  WorkflowKit
//
//  Visual workflow composition and template system
//

import Foundation

// MARK: - Workflow Composer

@MainActor
public class WorkflowComposer: ObservableObject {
    public static let shared = WorkflowComposer()
    
    @Published public var composedWorkflows: [Workflow] = []
    @Published public var templates: [WorkflowTemplate] = []
    @Published public var draftWorkflow: WorkflowDraft?
    
    private init() {
        loadTemplates()
    }
    
    // MARK: - Composition
    
    public func startComposition(from template: WorkflowTemplate? = nil) -> WorkflowDraft {
        let draft = WorkflowDraft(template: template)
        draftWorkflow = draft
        return draft
    }
    
    public func addStep(_ step: WorkflowStep) {
        draftWorkflow?.steps.append(step)
    }
    
    public func removeStep(at index: Int) {
        guard let draft = draftWorkflow, index < draft.steps.count else { return }
        draftWorkflow?.steps.remove(at: index)
    }
    
    public func finalize() -> Workflow? {
        guard let draft = draftWorkflow else { return nil }
        
        let workflow = Workflow(
            name: draft.name,
            description: draft.description,
            steps: draft.steps,
            category: draft.category,
            tags: draft.tags,
            isBuiltIn: false
        )
        
        composedWorkflows.append(workflow)
        draftWorkflow = nil
        saveComposedWorkflows()
        
        return workflow
    }
    
    public func cancelComposition() {
        draftWorkflow = nil
    }
    
    // MARK: - Templates
    
    public func createFromTemplate(_ template: WorkflowTemplate) -> Workflow {
        return Workflow(
            name: template.name,
            description: template.description,
            steps: template.defaultSteps,
            category: template.category,
            tags: template.tags,
            isBuiltIn: false
        )
    }
    
    public func templates(for category: WorkflowCategory) -> [WorkflowTemplate] {
        templates.filter { $0.category == category }
    }
    
    // MARK: - Persistence
    
    private func loadTemplates() {
        templates = WorkflowTemplate.builtInTemplates
    }
    
    private func saveComposedWorkflows() {
        if let encoded = try? JSONEncoder().encode(composedWorkflows) {
            UserDefaults.standard.set(encoded, forKey: "composedWorkflows")
        }
    }
    
    public func loadComposedWorkflows() {
        if let data = UserDefaults.standard.data(forKey: "composedWorkflows"),
           let decoded = try? JSONDecoder().decode([Workflow].self, from: data) {
            composedWorkflows = decoded
        }
    }
}

// MARK: - Workflow Draft

public struct WorkflowDraft {
    public var name: String
    public var description: String
    public var category: WorkflowCategory
    public var steps: [WorkflowStep]
    public var tags: [String]
    
    public init(template: WorkflowTemplate? = nil) {
        if let template = template {
            self.name = template.name
            self.description = template.description
            self.category = template.category
            self.steps = template.defaultSteps
            self.tags = template.tags
        } else {
            self.name = "New Workflow"
            self.description = ""
            self.category = .general
            self.steps = []
            self.tags = []
        }
    }
}

// MARK: - Workflow Template

public struct WorkflowTemplate: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let category: WorkflowCategory
    public let defaultSteps: [WorkflowStep]
    public let tags: [String]
    public let icon: String
    public let estimatedDuration: TimeInterval
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        category: WorkflowCategory,
        defaultSteps: [WorkflowStep] = [],
        tags: [String] = [],
        icon: String = "arrow.triangle.branch",
        estimatedDuration: TimeInterval = 60
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.defaultSteps = defaultSteps
        self.tags = tags
        self.icon = icon
        self.estimatedDuration = estimatedDuration
    }
    
    // MARK: - Built-in Templates
    
    public static let builtInTemplates: [WorkflowTemplate] = [
        WorkflowTemplate(
            name: "Build & Test",
            description: "Build project and run all tests",
            category: .development,
            defaultSteps: [
                .command(Command(script: "swift build", description: "Build")),
                .command(Command(script: "swift test", description: "Test"))
            ],
            tags: ["build", "test", "ci"],
            icon: "hammer",
            estimatedDuration: 120
        ),
        WorkflowTemplate(
            name: "Git Commit Flow",
            description: "Stage, commit, and push changes",
            category: .git,
            defaultSteps: [
                .command(Command(script: "git add .", description: "Stage All")),
                .prompt(Prompt(message: "Enter commit message")),
                .command(Command(script: "git commit -m \"$INPUT\"", description: "Commit")),
                .command(Command(script: "git push", description: "Push"))
            ],
            tags: ["git", "commit", "push"],
            icon: "arrow.triangle.branch",
            estimatedDuration: 30
        ),
        WorkflowTemplate(
            name: "Deploy Release",
            description: "Build release and deploy",
            category: .deployment,
            defaultSteps: [
                .command(Command(script: "swift build -c release", description: "Build Release")),
                .command(Command(script: "swift test", description: "Run Tests")),
                .prompt(Prompt(message: "Confirm deployment?")),
                .command(Command(script: "echo 'Deploying...'", description: "Deploy"))
            ],
            tags: ["deploy", "release", "production"],
            icon: "arrow.up.doc",
            estimatedDuration: 300
        ),
        WorkflowTemplate(
            name: "Code Review",
            description: "Lint, format, and analyze code",
            category: .development,
            defaultSteps: [
                .command(Command(script: "swiftlint", description: "Lint")),
                .command(Command(script: "swift-format format -i -r .", description: "Format")),
                .command(Command(script: "swift build --build-tests", description: "Analyze"))
            ],
            tags: ["lint", "format", "review"],
            icon: "checkmark.seal",
            estimatedDuration: 60
        ),
        WorkflowTemplate(
            name: "Documentation",
            description: "Generate and publish documentation",
            category: .documentation,
            defaultSteps: [
                .command(Command(script: "swift package generate-documentation", description: "Generate Docs")),
                .command(Command(script: "swift package preview-documentation", description: "Preview"))
            ],
            tags: ["docs", "documentation", "docc"],
            icon: "doc.text",
            estimatedDuration: 90
        ),
        WorkflowTemplate(
            name: "Clean Build",
            description: "Clean and rebuild from scratch",
            category: .build,
            defaultSteps: [
                .command(Command(script: "swift package clean", description: "Clean")),
                .command(Command(script: "swift package reset", description: "Reset")),
                .command(Command(script: "swift package resolve", description: "Resolve")),
                .command(Command(script: "swift build", description: "Build"))
            ],
            tags: ["clean", "rebuild", "fresh"],
            icon: "arrow.clockwise",
            estimatedDuration: 180
        )
    ]
}
