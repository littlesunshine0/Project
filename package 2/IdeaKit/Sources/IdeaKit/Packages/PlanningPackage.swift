//
//  PlanningPackage.swift
//  IdeaKit - Project Operating System
//
//  Kernel Package: Planning
//  Decomposes specs into tasks and milestones
//  Produces: TaskArtifact
//

import Foundation

/// Planning Package
/// Decomposes specifications into executable tasks
public struct PlanningPackage: CapabilityPackage {
    
    public static let packageId = "planning"
    public static let name = "Planning Package"
    public static let description = "Break specifications into executable tasks with milestones and effort estimates"
    public static let version = "1.0.0"
    public static let produces = ["TaskArtifact"]
    public static let consumes = ["RequirementsArtifact", "ScopeArtifact"]
    public static let isKernel = true
    
    public init() {}
    
    public func execute(graph: ArtifactGraph, context: ProjectContext) async throws {
        guard let scope: ScopeArtifact = await graph.get(ofType: ScopeArtifact.self) else {
            throw PackageError.missingArtifact("ScopeArtifact")
        }
        
        let tasks = decompose(from: scope)
        await graph.register(tasks, producedBy: Self.packageId)
        await graph.declareDependency(from: tasks.artifactId, to: scope.artifactId)
        
        try context.save(artifact: tasks.toMarkdown(), as: "tasks.md")
        try context.save(artifact: generateMilestonesMarkdown(from: tasks), as: "milestones.md")
    }

    private func decompose(from scope: ScopeArtifact) -> TaskArtifact {
        var tasks: [ProjectTask] = []
        var milestones: [ProjectMilestone] = []
        
        // Foundation milestone
        let foundation = ProjectMilestone(name: "Foundation", description: "Project setup and core infrastructure")
        milestones.append(foundation)
        
        tasks.append(contentsOf: [
            ProjectTask(title: "Project Setup", description: "Initialize project structure", milestone: "Foundation", effort: .small, confidence: 0.9),
            ProjectTask(title: "Core Data Models", description: "Define primary data structures", milestone: "Foundation", effort: .medium, confidence: 0.8),
            ProjectTask(title: "Database Layer", description: "Implement persistence", milestone: "Foundation", effort: .medium, confidence: 0.7)
        ])
        
        // Core Features milestone
        let core = ProjectMilestone(name: "Core Features", description: "Primary functionality")
        milestones.append(core)
        
        for feature in scope.mvpFeatures {
            tasks.append(ProjectTask(
                title: "Implement \(feature.name)",
                description: feature.description,
                milestone: "Core Features",
                effort: feature.effort,
                confidence: 0.7
            ))
        }
        
        // Polish milestone
        let polish = ProjectMilestone(name: "Polish", description: "Quality improvements")
        milestones.append(polish)
        
        tasks.append(contentsOf: [
            ProjectTask(title: "Error Handling", description: "Comprehensive error handling", milestone: "Polish", effort: .medium, confidence: 0.7),
            ProjectTask(title: "Documentation", description: "User documentation", milestone: "Polish", effort: .medium, confidence: 0.8)
        ])
        
        return TaskArtifact(tasks: tasks, milestones: milestones)
    }
    
    private func generateMilestonesMarkdown(from tasks: TaskArtifact) -> String {
        var md = "# Milestones\n\n"
        
        for milestone in tasks.milestones {
            let milestoneTasks = tasks.tasks.filter { $0.milestone == milestone.name }
            let completed = milestoneTasks.filter { $0.status == .completed }.count
            
            md += "## \(milestone.name)\n\n"
            md += "\(milestone.description)\n\n"
            md += "Progress: \(completed)/\(milestoneTasks.count) tasks\n\n"
        }
        
        return md
    }
}
