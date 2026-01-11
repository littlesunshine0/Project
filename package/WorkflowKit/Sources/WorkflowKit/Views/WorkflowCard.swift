//
//  WorkflowCard.swift
//  WorkflowKit
//
//  Reusable Workflow card components for displaying workflows
//

import SwiftUI

// MARK: - Workflow Card

public struct WorkflowCard: View {
    public let workflow: Workflow
    public var onRun: (() -> Void)?
    public var onEdit: (() -> Void)?
    public var onDelete: (() -> Void)?
    public var isRunning: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        workflow: Workflow,
        isRunning: Bool = false,
        onRun: (() -> Void)? = nil,
        onEdit: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.workflow = workflow
        self.isRunning = isRunning
        self.onRun = onRun
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: categoryIcon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(categoryColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(workflow.name)
                        .font(.headline)
                        .foregroundStyle(primaryTextColor)
                    
                    Text(workflow.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor)
                }
                
                Spacer()
                
                // Status badge
                if isRunning {
                    RunningBadge()
                } else if workflow.isBuiltIn {
                    BuiltInBadge()
                }
            }
            
            // Description
            if !workflow.description.isEmpty {
                Text(workflow.description)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .lineLimit(2)
            }
            
            // Stats
            HStack(spacing: 16) {
                WorkflowStatItem(icon: "list.bullet", value: "\(workflow.steps.count)", label: "Steps")
                
                if !workflow.tags.isEmpty {
                    WorkflowStatItem(icon: "tag", value: "\(workflow.tags.count)", label: "Tags")
                }
                
                WorkflowStatItem(icon: "clock", value: workflow.updatedAt.formatted(date: .abbreviated, time: .omitted), label: "Updated")
            }
            
            // Tags
            if !workflow.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(workflow.tags.prefix(5), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(categoryColor.opacity(0.1))
                                .foregroundStyle(categoryColor)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            // Actions
            if onRun != nil || onEdit != nil || onDelete != nil {
                Divider()
                
                HStack(spacing: 12) {
                    if let onRun = onRun {
                        Button(action: onRun) {
                            Label(isRunning ? "Running..." : "Run", systemImage: isRunning ? "hourglass" : "play.fill")
                        }
                        .buttonStyle(WorkflowButtonStyle(color: .green))
                        .disabled(isRunning)
                    }
                    
                    if let onEdit = onEdit {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .buttonStyle(WorkflowButtonStyle(color: .blue))
                    }
                    
                    Spacer()
                    
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(WorkflowButtonStyle(color: .red))
                    }
                }
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private var categoryColor: Color {
        switch workflow.category {
        case .development, .build: return .blue
        case .testing: return .green
        case .deployment: return .orange
        case .git: return .purple
        case .documentation: return .teal
        case .automation: return .pink
        case .analytics: return .indigo
        default: return .gray
        }
    }
    
    private var categoryIcon: String {
        switch workflow.category {
        case .development: return "hammer"
        case .testing: return "checkmark.circle"
        case .deployment: return "arrow.up.doc"
        case .git: return "arrow.triangle.branch"
        case .documentation: return "doc.text"
        case .build: return "wrench.and.screwdriver"
        case .automation: return "gearshape.2"
        case .analytics: return "chart.bar"
        default: return "arrow.triangle.branch"
        }
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
    }
    
    private var cardBackground: some ShapeStyle {
        colorScheme == .dark ? Color(white: 0.15) : Color.white
    }
}

// MARK: - Running Badge

struct RunningBadge: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color.green)
                .frame(width: 6, height: 6)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
            
            Text("Running")
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.green.opacity(0.15))
        .clipShape(Capsule())
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Built-In Badge

struct BuiltInBadge: View {
    var body: some View {
        Text("Built-in")
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.15))
            .foregroundStyle(.blue)
            .clipShape(Capsule())
    }
}

// MARK: - Workflow Stat Item

struct WorkflowStatItem: View {
    let icon: String
    let value: String
    let label: String
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
    }
}

// MARK: - Workflow Button Style

struct WorkflowButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color.opacity(configuration.isPressed ? 0.2 : 0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Workflow Template Card

public struct WorkflowTemplateCard: View {
    public let template: WorkflowTemplate
    public var onSelect: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(template: WorkflowTemplate, onSelect: (() -> Void)? = nil) {
        self.template = template
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.purple.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: template.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.purple)
                    }
                    
                    Spacer()
                    
                    Text(template.category.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name)
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Text(template.description)
                        .font(.caption)
                        .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                        .lineLimit(2)
                }
                
                HStack(spacing: 12) {
                    Label("\(template.defaultSteps.count) steps", systemImage: "list.bullet")
                    Label(formatDuration(template.estimatedDuration), systemImage: "clock")
                }
                .font(.caption2)
                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        if seconds < 60 { return "\(Int(seconds))s" }
        return "\(Int(seconds / 60))m"
    }
}

// MARK: - Workflow Run Result Card

public struct WorkflowRunResultCard: View {
    public let result: WorkflowRunResult
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(result: WorkflowRunResult) {
        self.result = result
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: result.status == .success ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(result.status == .success ? .green : .red)
                
                Text(result.workflowName)
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                Text(result.duration)
                    .font(.caption)
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
            }
            
            // Step results summary
            HStack(spacing: 8) {
                let successful = result.stepResults.filter { $0.success }.count
                let total = result.stepResults.count
                
                Text("\(successful)/\(total) steps completed")
                    .font(.caption)
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
                
                Spacer()
                
                Text(result.startTime, style: .relative)
                    .font(.caption)
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
            }
            
            if let error = result.error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Preview

#Preview("Workflow Card") {
    VStack(spacing: 16) {
        WorkflowCard(
            workflow: Workflow(
                name: "Build & Test",
                description: "Build the project and run all tests",
                steps: [
                    .command(Command(script: "swift build", description: "Build")),
                    .command(Command(script: "swift test", description: "Test"))
                ],
                category: .development,
                tags: ["build", "test", "ci"]
            ),
            onRun: {},
            onEdit: {},
            onDelete: {}
        )
        
        WorkflowTemplateCard(
            template: WorkflowTemplate.builtInTemplates[0],
            onSelect: {}
        )
    }
    .padding()
    .frame(width: 400)
}
