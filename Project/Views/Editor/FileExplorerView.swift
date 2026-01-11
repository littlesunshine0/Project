//
//  FileExplorerView.swift
//  FlowKit
//
//  Directory explorer for navigating project files
//

import SwiftUI

// MARK: - File Item Model

struct FileItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let path: String
    let isDirectory: Bool
    let children: [FileItem]?
    
    var icon: String {
        if isDirectory {
            return "folder.fill"
        }
        let ext = (name as NSString).pathExtension.lowercased()
        switch ext {
        case "swift": return "swift"
        case "js", "jsx", "ts", "tsx": return "curlybraces"
        case "json": return "curlybraces.square"
        case "md": return "doc.richtext"
        case "html": return "chevron.left.forwardslash.chevron.right"
        case "css", "scss": return "paintbrush"
        default: return "doc.text"
        }
    }
    
    var color: Color {
        if isDirectory { return FlowPalette.Category.explorer }
        let ext = (name as NSString).pathExtension.lowercased()
        switch ext {
        case "swift": return .orange
        case "js", "jsx": return .yellow
        case "ts", "tsx": return .blue
        case "json": return .gray
        case "md": return .purple
        default: return .secondary
        }
    }
}

// MARK: - File Explorer View

struct FileExplorerView: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var expandedFolders: Set<UUID> = []
    @State private var searchText: String = ""
    
    // Sample file structure
    private let rootItems: [FileItem] = [
        FileItem(name: "Project", path: "/Project", isDirectory: true, children: [
            FileItem(name: "Views", path: "/Project/Views", isDirectory: true, children: [
                FileItem(name: "ContentView.swift", path: "/Project/Views/ContentView.swift", isDirectory: false, children: nil),
                FileItem(name: "DashboardView.swift", path: "/Project/Views/DashboardView.swift", isDirectory: false, children: nil)
            ]),
            FileItem(name: "Models", path: "/Project/Models", isDirectory: true, children: [
                FileItem(name: "DataModel.swift", path: "/Project/Models/DataModel.swift", isDirectory: false, children: nil)
            ]),
            FileItem(name: "App.swift", path: "/Project/App.swift", isDirectory: false, children: nil)
        ]),
        FileItem(name: "Package.swift", path: "/Package.swift", isDirectory: false, children: nil),
        FileItem(name: "README.md", path: "/README.md", isDirectory: false, children: nil)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            searchBar
            
            // File tree
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(rootItems) { item in
                        FileItemRow(
                            item: item,
                            level: 0,
                            expandedFolders: $expandedFolders,
                            onFileSelect: { path in
                                workspaceManager.openFile(path)
                            }
                        )
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .background(FlowPalette.Semantic.surface(colorScheme))
    }
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            
            TextField("Search files...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 12))
        }
        .padding(8)
        .background(FlowPalette.Semantic.elevated(colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(8)
    }
}

// MARK: - File Item Row

struct FileItemRow: View {
    let item: FileItem
    let level: Int
    @Binding var expandedFolders: Set<UUID>
    let onFileSelect: (String) -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    private var isExpanded: Bool {
        expandedFolders.contains(item.id)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Item row
            HStack(spacing: 6) {
                // Expand arrow for directories
                if item.isDirectory {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                        .frame(width: 12)
                } else {
                    Spacer().frame(width: 12)
                }
                
                // Icon
                Image(systemName: item.icon)
                    .font(.system(size: 13))
                    .foregroundStyle(item.color)
                
                // Name
                Text(item.name)
                    .font(.system(size: 12))
                    .foregroundStyle(FlowPalette.Text.primary(colorScheme))
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(.leading, CGFloat(level) * 16 + 8)
            .padding(.trailing, 8)
            .padding(.vertical, 5)
            .background(
                isHovered
                    ? FlowPalette.Border.subtle(colorScheme)
                    : Color.clear
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if item.isDirectory {
                    withAnimation(FlowMotion.quick) {
                        if isExpanded {
                            expandedFolders.remove(item.id)
                        } else {
                            expandedFolders.insert(item.id)
                        }
                    }
                } else {
                    onFileSelect(item.path)
                }
            }
            .onHover { isHovered = $0 }
            
            // Children
            if item.isDirectory && isExpanded, let children = item.children {
                ForEach(children) { child in
                    FileItemRow(
                        item: child,
                        level: level + 1,
                        expandedFolders: $expandedFolders,
                        onFileSelect: onFileSelect
                    )
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    FileExplorerView(workspaceManager: WorkspaceManager.shared)
        .frame(width: 280, height: 500)
        .preferredColorScheme(.dark)
}
