//
//  TaskDecomposer.swift
//  IdeaKit - Project Operating System
//
//  Tool: TaskDecomposer
//  Phase: Specification
//  Purpose: Convert specs into executable tasks and milestones
//  Outputs: tasks.md, milestones.md, roadmap.json
//

import Foundation

/// Decomposes specifications into executable tasks
public final class TaskDecomposer: ProjectTool, @unchecked Sendable {
    
    // MARK: - ProjectTool Conformance
    
    public static let id = "task_decomposer"
    public static let name = "Task Decomposer"
    public static let description = "Break specifications into executable tasks with milestones and effort estimates"
    public static let phase = ProjectPhase.specification
    public static let outputs = ["tasks.md", "milestones.md", "roadmap.json"]
    public static let inputs = ["requirements.md", "scope.md"]
    public static let isDefault = true
    
    // MARK: - Singleton
    
    public static let shared = TaskDecomposer()
    private init() {}
    
    // MARK: - Decomposition
    
    /// Decompose specification into tasks
    public func decompose(spec: Specification) async throws -> TaskDecomposition {
        var tasks: [ProjectTask] = []
        var milestones: [ProjectMilestone] = []
        
        // Milestone 1: Foundation
        let foundationMilestone = ProjectMilestone(
            name: "Foundation",
            description: "Project setup and core infrastructure"
        )
        milestones.append(foundationMilestone)
        
        let foundationTasks = [
            ProjectTask(title: "Project Setup", description: "Initialize project structure and dependencies", milestone: "Foundation", effort: .small, confidence: 0.9),
            ProjectTask(title: "Core Data Models", description: "Define primary data structures", milestone: "Foundation", effort: .medium, confidence: 0.8),
            ProjectTask(title: "Database Layer", description: "Implement persistence layer", milestone: "Foundation", effort: .medium, confidence: 0.7),
            ProjectTask(title: "Basic UI Shell", description: "Create main application shell", milestone: "Foundation", effort: .small, confidence: 0.9)
        ]
        tasks.append(contentsOf: foundationTasks)
        
        // Milestone 2: Core Features
        let coreMilestone = ProjectMilestone(
            name: "Core Features",
            description: "Primary functionality implementation"
        )
        milestones.append(coreMilestone)
        
        let coreTasks = [
            ProjectTask(title: "Primary Workflow", description: "Implement main user workflow", milestone: "Core Features", effort: .large, confidence: 0.6),
            ProjectTask(title: "Data Operations", description: "CRUD operations for user data", milestone: "Core Features", effort: .medium, confidence: 0.8),
            ProjectTask(title: "User Feedback", description: "Success/error messaging", milestone: "Core Features", effort: .small, confidence: 0.9),
            ProjectTask(title: "Navigation", description: "App navigation and routing", milestone: "Core Features", effort: .medium, confidence: 0.8)
        ]
        tasks.append(contentsOf: coreTasks)
        
        // Milestone 3: Polish
        let polishMilestone = ProjectMilestone(
            name: "Polish",
            description: "Quality improvements and refinements"
        )
        milestones.append(polishMilestone)
        
        let polishTasks = [
            ProjectTask(title: "Error Handling", description: "Comprehensive error handling", milestone: "Polish", effort: .medium, confidence: 0.7),
            ProjectTask(title: "Performance Optimization", description: "Optimize critical paths", milestone: "Polish", effort: .medium, confidence: 0.6),
            ProjectTask(title: "Accessibility", description: "Accessibility compliance", milestone: "Polish", effort: .medium, confidence: 0.7),
            ProjectTask(title: "Documentation", description: "User and developer documentation", milestone: "Polish", effort: .medium, confidence: 0.8)
        ]
        tasks.append(contentsOf: polishTasks)
        
        // Milestone 4: Release
        let releaseMilestone = ProjectMilestone(
            name: "Release",
            description: "Final preparation for release"
        )
        milestones.append(releaseMilestone)
        
        let releaseTasks = [
            ProjectTask(title: "Testing", description: "Comprehensive testing", milestone: "Release", effort: .large, confidence: 0.7),
            ProjectTask(title: "Bug Fixes", description: "Address identified issues", milestone: "Release", effort: .medium, confidence: 0.5),
            ProjectTask(title: "Release Prep", description: "Prepare release artifacts", milestone: "Release", effort: .small, confidence: 0.9)
        ]
        tasks.append(contentsOf: releaseTasks)
        
        return TaskDecomposition(tasks: tasks, milestones: milestones)
    }
    
    /// Generate tasks markdown
    public func generateTasksMarkdown(from decomposition: TaskDecomposition) -> String {
        var md = """
        # Project Tasks
        
        ## Overview
        
        Total Tasks: \(decomposition.tasks.count)
        Total Effort: \(totalEffort(decomposition.tasks)) points
        
        """
        
        // Group by milestone
        let grouped = Dictionary(grouping: decomposition.tasks, by: { $0.milestone })
        
        for milestone in decomposition.milestones {
            guard let milestoneTasks = grouped[milestone.name] else { continue }
            
            md += "\n## \(milestone.name)\n\n"
            md += "_\(milestone.description)_\n\n"
            
            for task in milestoneTasks {
                let statusEmoji = statusEmoji(for: task.status)
                let confidenceBar = confidenceBar(for: task.confidence)
                
                md += "### \(statusEmoji) \(task.title)\n\n"
                md += "- **Description**: \(task.description)\n"
                md += "- **Effort**: \(task.effort.rawValue)\n"
                md += "- **Confidence**: \(confidenceBar) (\(Int(task.confidence * 100))%)\n"
                md += "- **Status**: \(task.status.rawValue)\n\n"
            }
        }
        
        return md
    }
    
    /// Generate milestones markdown
    public func generateMilestonesMarkdown(from decomposition: TaskDecomposition) -> String {
        var md = """
        # Project Milestones
        
        ## Timeline Overview
        
        ```
        """
        
        for (index, milestone) in decomposition.milestones.enumerated() {
            let tasks = decomposition.tasks.filter { $0.milestone == milestone.name }
            let effort = totalEffort(tasks)
            md += "\(index + 1). \(milestone.name) [\(effort) pts]\n"
        }
        
        md += """
        ```
        
        ## Milestone Details
        
        """
        
        let grouped = Dictionary(grouping: decomposition.tasks, by: { $0.milestone })
        
        for milestone in decomposition.milestones {
            let tasks = grouped[milestone.name] ?? []
            let completed = tasks.filter { $0.status == .completed }.count
            let progress = tasks.isEmpty ? 0 : (Double(completed) / Double(tasks.count)) * 100
            
            md += """
            
            ### \(milestone.name)
            
            \(milestone.description)
            
            - **Tasks**: \(completed)/\(tasks.count) completed
            - **Progress**: \(Int(progress))%
            - **Effort**: \(totalEffort(tasks)) points
            
            """
        }
        
        return md
    }
    
    /// Generate roadmap JSON
    public func generateRoadmap(from decomposition: TaskDecomposition) -> [String: Any] {
        [
            "milestones": decomposition.milestones.map { milestone in
                [
                    "id": milestone.id.uuidString,
                    "name": milestone.name,
                    "description": milestone.description,
                    "tasks": decomposition.tasks.filter { $0.milestone == milestone.name }.map { $0.id.uuidString }
                ]
            },
            "tasks": decomposition.tasks.map { task in
                [
                    "id": task.id.uuidString,
                    "title": task.title,
                    "milestone": task.milestone,
                    "effort": task.effort.rawValue,
                    "status": task.status.rawValue
                ]
            },
            "summary": [
                "totalTasks": decomposition.tasks.count,
                "totalEffort": totalEffort(decomposition.tasks),
                "milestoneCount": decomposition.milestones.count
            ]
        ]
    }
    
    // MARK: - Private Helpers
    
    private func totalEffort(_ tasks: [ProjectTask]) -> Int {
        tasks.reduce(0) { $0 + effortValue($1.effort) }
    }
    
    private func effortValue(_ effort: EffortEstimate) -> Int {
        switch effort {
        case .trivial: return 1
        case .small: return 2
        case .medium: return 5
        case .large: return 8
        case .epic: return 13
        }
    }
    
    private func statusEmoji(for status: TaskStatus) -> String {
        switch status {
        case .pending: return "⏳"
        case .inProgress: return "🔄"
        case .blocked: return "🚫"
        case .completed: return "✅"
        case .cancelled: return "❌"
        }
    }
    
    private func confidenceBar(for confidence: Double) -> String {
        let filled = Int(confidence * 5)
        let empty = 5 - filled
        return String(repeating: "█", count: filled) + String(repeating: "░", count: empty)
    }
}
