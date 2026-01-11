//
//  CommandCard.swift
//  CommandKit
//
//  Reusable Command card components
//

import SwiftUI

// MARK: - Command Card

public struct CommandCard: View {
    public let command: ComposedCommand
    public var onRun: (() -> Void)?
    public var onEdit: (() -> Void)?
    public var onDelete: (() -> Void)?
    public var onToggleFavorite: (() -> Void)?
    public var isExecuting: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        command: ComposedCommand,
        isExecuting: Bool = false,
        onRun: (() -> Void)? = nil,
        onEdit: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil,
        onToggleFavorite: (() -> Void)? = nil
    ) {
        self.command = command
        self.isExecuting = isExecuting
        self.onRun = onRun
        self.onEdit = onEdit
        self.onDelete = onDelete
        self.onToggleFavorite = onToggleFavorite
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(Color.pink.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "terminal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.pink)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(command.name)
                        .font(.headline)
                        .foregroundStyle(primaryTextColor)
                    
                    Text(command.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor)
                }
                
                Spacer()
                
                if let onToggleFavorite = onToggleFavorite {
                    Button(action: onToggleFavorite) {
                        Image(systemName: command.isFavorite ? "star.fill" : "star")
                            .foregroundStyle(command.isFavorite ? .yellow : secondaryTextColor)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Description
            if !command.description.isEmpty {
                Text(command.description)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .lineLimit(2)
            }
            
            // Script preview
            Text(command.script)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(primaryTextColor.opacity(0.8))
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .lineLimit(2)
            
            // Arguments
            if !command.arguments.isEmpty {
                HStack(spacing: 6) {
                    ForEach(command.arguments.prefix(3)) { arg in
                        Text(arg.name)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.blue.opacity(0.1))
                            .foregroundStyle(.blue)
                            .clipShape(Capsule())
                    }
                    if command.arguments.count > 3 {
                        Text("+\(command.arguments.count - 3)")
                            .font(.caption2)
                            .foregroundStyle(secondaryTextColor)
                    }
                }
            }
            
            // Actions
            if onRun != nil || onEdit != nil || onDelete != nil {
                Divider()
                
                HStack(spacing: 12) {
                    if let onRun = onRun {
                        Button(action: onRun) {
                            Label(isExecuting ? "Running..." : "Run", systemImage: isExecuting ? "hourglass" : "play.fill")
                        }
                        .buttonStyle(CommandButtonStyle(color: .green))
                        .disabled(isExecuting)
                    }
                    
                    if let onEdit = onEdit {
                        Button(action: onEdit) {
                            Label("Edit", systemImage: "pencil")
                        }
                        .buttonStyle(CommandButtonStyle(color: .blue))
                    }
                    
                    Spacer()
                    
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(CommandButtonStyle(color: .red))
                    }
                }
            }
        }
        .padding(16)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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

// MARK: - Command Button Style

struct CommandButtonStyle: ButtonStyle {
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

// MARK: - Command Template Card

public struct CommandTemplateCard: View {
    public let template: CommandTemplate
    public var onSelect: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(template: CommandTemplate, onSelect: (() -> Void)? = nil) {
        self.template = template
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: { onSelect?() }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.pink.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: template.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.pink)
                    }
                    
                    Spacer()
                    
                    Text(template.category.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.pink.opacity(0.1))
                        .foregroundStyle(.pink)
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
                
                Text(template.script)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
                    .lineLimit(1)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Command History Card

public struct CommandHistoryCard: View {
    public let entry: CommandHistoryEntry
    public var onRerun: (() -> Void)?
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(entry: CommandHistoryEntry, onRerun: (() -> Void)? = nil) {
        self.entry = entry
        self.onRerun = onRerun
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Status icon
            Image(systemName: entry.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(entry.success ? .green : .red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.command)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Text(entry.timestamp, style: .relative)
                    Text("•")
                    Text(formatDuration(entry.duration))
                }
                .font(.caption2)
                .foregroundStyle(colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5))
            }
            
            Spacer()
            
            if let onRerun = onRerun {
                Button(action: onRerun) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(colorScheme == .dark ? Color(white: 0.15) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        if seconds < 1 { return "<1s" }
        if seconds < 60 { return "\(Int(seconds))s" }
        return "\(Int(seconds / 60))m \(Int(seconds.truncatingRemainder(dividingBy: 60)))s"
    }
}

// MARK: - Preview

#Preview("Command Card") {
    VStack(spacing: 16) {
        CommandCard(
            command: ComposedCommand(
                name: "Git Status",
                description: "Show working tree status",
                script: "git status",
                category: .general,
                isFavorite: true
            ),
            onRun: {},
            onEdit: {},
            onDelete: {},
            onToggleFavorite: {}
        )
        
        CommandTemplateCard(
            template: CommandTemplate.builtInTemplates[0],
            onSelect: {}
        )
    }
    .padding()
    .frame(width: 400)
}
