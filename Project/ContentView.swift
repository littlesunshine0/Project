//
//  ContentView.swift
//  FlowKit
//
//  Main content view - Kit Host architecture
//  Views bind to FlowKitHost. Kits own logic.
//

import SwiftUI
import CoreKit
import IdeaKit
import IconKit

struct ContentView: View {
    @State private var host = FlowKitHost.shared
    @State private var sidebarSections: [SidebarSection] = []
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailView
        }

        .frame(minWidth: 1000, minHeight: 700)
        .task {
            await host.initialize()
            await refreshSidebar()
        }
    }
    
    // MARK: - Sidebar
    
    private var sidebar: some View {
        List(selection: $host.selectedCapability) {
            // Navigation
            Section("Navigation") {
                Label("Dashboard", systemImage: "square.grid.2x2")
                    .tag("dashboard")
                
                Label("Chat", systemImage: "bubble.left.and.bubble.right")
                    .tag("chat")
            }
            
            // Capabilities
            Section("Capabilities") {
                Label("Files", systemImage: "folder")
                    .tag("files")
                
                Label("Workflows", systemImage: "arrow.triangle.branch")
                    .tag("workflows")
                
                Label("Agents", systemImage: "cpu")
                    .tag("agents")
                
                Label("Commands", systemImage: "terminal")
                    .tag("commands")
                
                Label("Documentation", systemImage: "book")
                    .tag("docs")
                
                Label("Search", systemImage: "magnifyingglass")
                    .tag("search")
            }
            
            // Project Nodes (from CoreKit graph)
            if !sidebarSections.isEmpty {
                ForEach(sidebarSections) { section in
                    Section(section.title) {
                        ForEach(section.nodes, id: \.id) { node in
                            Label(node.name, systemImage: iconFor(node.type))
                                .tag("node:\(node.id)")
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 220)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: openFolder) {
                    Image(systemName: "folder.badge.plus")
                }
                .help("Open Folder")
            }
        }
    }
    
    // MARK: - Detail View
    
    @ViewBuilder
    private var detailView: some View {
        switch host.selectedCapability {
        case "dashboard":
            DashboardView()
        case "chat":
            ChatView(host: host)
        case "files":
            FilesView(host: host)
        case "workflows":
            WorkflowsPlaceholderView()
        case "agents":
            AgentsPlaceholderView()
        case "commands":
            CommandsPlaceholderView()
        case "docs":
            DocsPlaceholderView()
        case "search":
            SearchPlaceholderView()
        case let tag where tag?.hasPrefix("node:") == true:
            if let nodeId = tag?.replacingOccurrences(of: "node:", with: "") {
                NodeDetailView(host: host, nodeId: nodeId)
            }
        default:
            DashboardView()
        }
    }
    
    // MARK: - Helpers
    
    private func iconFor(_ type: NodeType) -> String {
        switch type {
        case .project: return "folder.fill"
        case .package: return "shippingbox"
        case .module: return "cube"
        case .directory: return "folder"
        case .sourceFile: return "doc.text"
        case .view: return "rectangle.on.rectangle"
        case .model: return "cylinder"
        case .service: return "gearshape"
        case .test: return "checkmark.circle"
        case .script: return "terminal"
        case .command: return "command"
        case .workflow: return "arrow.triangle.branch"
        case .agent: return "cpu"
        case .document: return "doc.richtext"
        case .config: return "gearshape.2"
        case .asset, .image, .icon: return "photo"
        default: return "doc"
        }
    }
    
    private func refreshSidebar() async {
        sidebarSections = await host.nodesForSidebar()
    }
    
    private func openFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            Task {
                await host.mountDirectory(path: url.path)
                await refreshSidebar()
            }
        }
    }
}

// MARK: - Files View

struct FilesView: View {
    var host: FlowKitHost
    @State private var nodes: [Node] = []
    
    var body: some View {
        List(nodes, id: \.id) { node in
            HStack {
                Image(systemName: iconFor(node.type))
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading) {
                    Text(node.name)
                        .fontWeight(.medium)
                    Text(node.path)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                
                Spacer()
                
                Text(node.type.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(Capsule())
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Files")
        .task {
            nodes = await host.graph.all()
        }
    }
    
    private func iconFor(_ type: NodeType) -> String {
        switch type {
        case .sourceFile: return "doc.text"
        case .directory: return "folder"
        case .project: return "folder.fill"
        case .script: return "terminal"
        case .config: return "gearshape"
        case .document: return "doc.richtext"
        case .image, .asset: return "photo"
        default: return "doc"
        }
    }
}

// MARK: - Node Detail View

struct NodeDetailView: View {
    var host: FlowKitHost
    let nodeId: String
    @State private var node: Node?
    
    var body: some View {
        Group {
            if let node = node {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading) {
                                Text(node.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                Text(node.path)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(node.type.rawValue)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.accentColor.opacity(0.1))
                                .clipShape(Capsule())
                        }
                        
                        Divider()
                        
                        // Capabilities
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Capabilities")
                                .font(.headline)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(Array(node.capabilities), id: \.self) { cap in
                                    Text(cap.rawValue)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.blue.opacity(0.1))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        
                        // Metadata
                        if !node.metadata.tags.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tags")
                                    .font(.headline)
                                
                                FlowLayout(spacing: 8) {
                                    ForEach(node.metadata.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.green.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        
                        // Relationships
                        if !node.relationships.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Relationships")
                                    .font(.headline)
                                
                                ForEach(node.relationships, id: \.id) { rel in
                                    HStack {
                                        Text(rel.type.rawValue)
                                            .foregroundStyle(.secondary)
                                        Text("→")
                                        Text(rel.targetId)
                                            .font(.system(.body, design: .monospaced))
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            } else {
                ContentUnavailableView("Node Not Found", systemImage: "questionmark.circle")
            }
        }
        .task {
            node = await host.graph.get(nodeId)
        }
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
        
        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > width && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: width, height: y + rowHeight)
        }
    }
}

// MARK: - Placeholder Views

struct WorkflowsPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Workflows",
            systemImage: "arrow.triangle.branch",
            description: Text("WorkflowKit integration coming soon")
        )
    }
}

struct AgentsPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Agents",
            systemImage: "cpu",
            description: Text("AgentKit integration coming soon")
        )
    }
}

struct CommandsPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Commands",
            systemImage: "terminal",
            description: Text("CommandKit integration coming soon")
        )
    }
}

struct DocsPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Documentation",
            systemImage: "book",
            description: Text("DocKit integration coming soon")
        )
    }
}

struct SearchPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Search",
            systemImage: "magnifyingglass",
            description: Text("SearchKit integration coming soon")
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
