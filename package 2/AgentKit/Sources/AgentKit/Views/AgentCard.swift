//
//  AgentCard.swift
//  AgentKit
//
//  Reusable Agent card component for displaying agents
//

import SwiftUI

// MARK: - Agent Card

/// A reusable card component for displaying an Agent
public struct AgentCard: View {
    public let agent: Agent
    public var onRun: (() -> Void)?
    public var onEdit: (() -> Void)?
    public var onDelete: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        agent: Agent,
        onRun: (() -> Void)? = nil,
        onEdit: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.agent = agent
        self.onRun = onRun
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Icon
                ZStack {
                    Circle()
                        .fill(statusColor.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: agent.type.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(statusColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(agent.name)
                        .font(.headline)
                        .foregroundStyle(primaryTextColor)
                    
                    Text(agent.type.rawValue)
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor)
                }
                
                Spacer()
                
                // Status badge
                StatusBadge(status: agent.status)
            }
            
            // Description
            if !agent.description.isEmpty {
                Text(agent.description)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .lineLimit(2)
            }
            
            // Stats
            HStack(spacing: 16) {
                StatItem(icon: "play.circle", value: "\(agent.runCount)", label: "Runs")
                StatItem(icon: "checkmark.circle", value: "\(Int(agent.successRate * 100))%", label: "Success")
                
                if let lastRun = agent.lastRunAt {
                    StatItem(icon: "clock", value: lastRun.formatted(date: .abbreviated, time: .shortened), label: "Last Run")
                }
            }
            
            // Actions
            if onRun != nil || onEdit != nil || onDelete != nil {
                Divider()
                
                HStack(spacing: 12) {
                    if let onRun = onRun {
                        Button(action: onRun) {
                            Label("Run", systemImage: "play.fill")
                        }
                        .buttonStyle(AgentButtonStyle(color: .green))
                        .disabled(agent.status == .running)
                    }
                    
                    if let onEdit = onEdit {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .buttonStyle(AgentButtonStyle(color: .blue))
                    }
                    
                    Spacer()
                    
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(AgentButtonStyle(color: .red))
                    }
                }
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private var statusColor: Color {
        switch agent.status {
        case .idle: return .gray
        case .running: return .green
        case .paused: return .orange
        case .error: return .red
        case .disabled: return .gray
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

// MARK: - Status Badge

struct StatusBadge: View {
    let status: AgentStatus
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(statusColor)
                .frame(width: 6, height: 6)
            
            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor.opacity(0.15))
        .clipShape(Capsule())
    }
    
    private var statusColor: Color {
        switch status {
        case .idle: return .gray
        case .running: return .green
        case .paused: return .orange
        case .error: return .red
        case .disabled: return .gray
        }
    }
}

// MARK: - Stat Item

struct StatItem: View {
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

// MARK: - Agent Button Style

struct AgentButtonStyle: ButtonStyle {
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

// MARK: - Agent Template Card

/// A card for displaying agent templates
public struct AgentTemplateCard: View {
    public let template: AgentTemplate
    public var onSelect: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(template: AgentTemplate, onSelect: (() -> Void)? = nil) {
        self.template = template
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: template.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.orange)
                    }
                    
                    Spacer()
                    
                    Text(template.category)
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
                
                // Capabilities preview
                HStack(spacing: 4) {
                    ForEach(template.capabilities.prefix(3), id: \.self) { cap in
                        Text(cap.rawValue.prefix(10) + "...")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Agent Run Result Card

/// A card for displaying agent run results
public struct AgentRunResultCard: View {
    public let result: AgentRunResult
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(result: AgentRunResult) {
        self.result = result
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: result.status == .success ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(result.status == .success ? .green : .red)
                
                Text(result.status == .success ? "Success" : "Failed")
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                
                Spacer()
                
                Text(formatDuration(result.duration))
                    .font(.caption)
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6))
            }
            
            if !result.output.isEmpty {
                Text(result.output)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.8) : Color.black.opacity(0.8))
                    .lineLimit(5)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            if let error = result.error {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(16)
        .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        if seconds < 1 { return "<1s" }
        if seconds < 60 { return "\(Int(seconds))s" }
        return "\(Int(seconds / 60))m \(Int(seconds.truncatingRemainder(dividingBy: 60)))s"
    }
}

// MARK: - Preview

#Preview("Agent Card") {
    VStack(spacing: 16) {
        AgentCard(
            agent: Agent(
                name: "Build Agent",
                description: "Builds and compiles the project automatically",
                type: .builder,
                capabilities: [.buildOperations, .executeCommands]
            ),
            onRun: {},
            onEdit: {},
            onDelete: {}
        )
        
        AgentTemplateCard(
            template: AgentTemplate.builtInTemplates[0],
            onSelect: {}
        )
    }
    .padding()
    .frame(width: 400)
}
