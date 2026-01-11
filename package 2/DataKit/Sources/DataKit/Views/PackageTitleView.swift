//
//  PackageTitleView.swift
//  DataKit
//
//  Visual representation of a package with title, icon, and stats
//

import SwiftUI

// MARK: - Package Title View

public struct PackageTitleView: View {
    public let package: PackageInfo
    public var style: Style = .standard
    
    public init(package: PackageInfo, style: Style = .standard) {
        self.package = package
        self.style = style
    }
    
    public var body: some View {
        switch style {
        case .compact:
            compactView
        case .standard:
            standardView
        case .expanded:
            expandedView
        case .card:
            cardView
        }
    }
    
    // MARK: - Compact View
    
    private var compactView: some View {
        HStack(spacing: 8) {
            Image(systemName: package.icon)
                .font(.system(size: 14))
                .foregroundStyle(packageColor)
            Text(package.name)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
    
    // MARK: - Standard View
    
    private var standardView: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(packageColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: package.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(packageColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(package.name)
                    .font(.headline)
                Text("v\(package.version)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            statsView
        }
    }
    
    // MARK: - Expanded View
    
    private var expandedView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(packageColor.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Image(systemName: package.icon)
                        .font(.system(size: 28))
                        .foregroundStyle(packageColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(package.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(package.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    Text("Version \(package.version)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            
            Divider()
            
            expandedStatsView
            
            if !package.dependencies.isEmpty {
                dependenciesView
            }
            
            if !package.exports.isEmpty {
                exportsView
            }
        }
        .padding()
        .background(Color.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
    
    // MARK: - Card View
    
    private var cardView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(packageColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: package.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(packageColor)
                }
                
                Spacer()
                
                Text("v\(package.version)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
            }
            
            Text(package.name)
                .font(.headline)
            
            Text(package.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            Spacer()
            
            HStack(spacing: 16) {
                statBadge(count: package.commandCount, icon: "command", label: "Cmds")
                statBadge(count: package.actionCount, icon: "bolt", label: "Acts")
                statBadge(count: package.workflowCount, icon: "arrow.triangle.branch", label: "Flows")
            }
        }
        .padding()
        .frame(width: 200, height: 180)
        .background(Color.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }
    
    // MARK: - Stats Views
    
    private var statsView: some View {
        HStack(spacing: 12) {
            statPill(count: package.commandCount, icon: "command")
            statPill(count: package.actionCount, icon: "bolt")
            statPill(count: package.workflowCount, icon: "arrow.triangle.branch")
        }
    }
    
    private var expandedStatsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            statCard(count: package.commandCount, icon: "command", label: "Commands")
            statCard(count: package.actionCount, icon: "bolt", label: "Actions")
            statCard(count: package.workflowCount, icon: "arrow.triangle.branch", label: "Workflows")
            statCard(count: package.agentCount, icon: "cpu", label: "Agents")
            statCard(count: package.viewCount, icon: "rectangle.on.rectangle", label: "Views")
            statCard(count: package.modelCount, icon: "cube", label: "Models")
            statCard(count: package.serviceCount, icon: "server.rack", label: "Services")
            statCard(count: package.files.count, icon: "doc", label: "Files")
        }
    }
    
    private var dependenciesView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Dependencies")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            FlowLayout(spacing: 6) {
                ForEach(package.dependencies, id: \.self) { dep in
                    Text(dep)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
            }
        }
    }
    
    private var exportsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exports")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
            
            FlowLayout(spacing: 6) {
                ForEach(package.exports, id: \.self) { export in
                    Text(export)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .foregroundStyle(.green)
                        .clipShape(Capsule())
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func statPill(count: Int, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text("\(count)")
                .font(.caption2)
                .fontWeight(.medium)
        }
        .foregroundStyle(.secondary)
    }
    
    private func statBadge(count: Int, icon: String, label: String) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text("\(count)")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            Text(label)
                .font(.system(size: 8))
                .foregroundStyle(.tertiary)
        }
    }
    
    private func statCard(count: Int, icon: String, label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(packageColor)
            Text("\(count)")
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.secondary.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    // MARK: - Computed Properties
    
    private var packageColor: Color {
        switch package.color {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "purple": return .purple
        case "red": return .red
        case "pink": return .pink
        case "yellow": return .yellow
        case "teal": return .teal
        case "indigo": return .indigo
        case "mint": return .mint
        case "cyan": return .cyan
        default: return .blue
        }
    }
    
    // MARK: - Style
    
    public enum Style {
        case compact
        case standard
        case expanded
        case card
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                self.size.width = max(self.size.width, x)
            }
            self.size.height = y + rowHeight
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        PackageTitleView(
            package: PackageInfo(
                identifier: "com.flowkit.commandkit",
                name: "CommandKit",
                version: "1.0.0",
                description: "Command parsing, autocomplete, and execution",
                icon: "command",
                color: "blue",
                dependencies: ["DataKit", "CoreKit"],
                exports: ["Command", "CommandManager"],
                commandCount: 30,
                actionCount: 20,
                workflowCount: 10,
                agentCount: 5
            ),
            style: .expanded
        )
    }
    .padding()
}
