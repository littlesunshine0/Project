//
//  IconBrowserView.swift
//  IconKit
//
//  Main icon browser with multiple view modes
//  Drop-in ready - works with any project
//

import SwiftUI

/// View mode for icon display
public enum IconViewMode: String, CaseIterable, Sendable {
    case table = "Table"
    case list = "List"
    case grid = "Grid"
    case gallery = "Gallery"
    
    public var icon: String {
        switch self {
        case .table: return "tablecells"
        case .list: return "list.bullet"
        case .grid: return "square.grid.3x3"
        case .gallery: return "photo.on.rectangle"
        }
    }
}

/// Main icon browser view - drop-in component
public struct IconBrowserView: View {
    @State private var icons: [StoredIcon] = []
    @State private var selectedIcon: StoredIcon?
    @State private var viewMode: IconViewMode = .grid
    @State private var searchText = ""
    @State private var selectedCategory: IconKit.IconCategory?
    @State private var isLoading = true
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            contentView
        } detail: {
            detailView
        }
        .searchable(text: $searchText, prompt: "Search icons...")
        .task {
            await loadIcons()
        }
    }
    
    // MARK: - Sidebar
    
    private var sidebar: some View {
        List(selection: $selectedCategory) {
            Section("Categories") {
                NavigationLink(value: Optional<IconKit.IconCategory>.none) {
                    Label("All Icons", systemImage: "square.grid.2x2")
                }
                .tag(Optional<IconKit.IconCategory>.none)
                
                ForEach(IconKit.IconCategory.allCases, id: \.self) { category in
                    NavigationLink(value: Optional(category)) {
                        Label(category.rawValue, systemImage: categoryIcon(category))
                    }
                    .tag(Optional(category))
                    .badge(icons.filter { $0.category == category.rawValue }.count)
                }
            }
            
            Section("View Mode") {
                Picker("View", selection: $viewMode) {
                    ForEach(IconViewMode.allCases, id: \.self) { mode in
                        Label(mode.rawValue, systemImage: mode.icon)
                            .tag(mode)
                    }
                }
                .pickerStyle(.inline)
                .labelsHidden()
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 200)
    }
    
    // MARK: - Content View
    
    @ViewBuilder
    private var contentView: some View {
        if isLoading {
            ProgressView("Loading icons...")
        } else {
            switch viewMode {
            case .table:
                IconTableView(icons: filteredIcons, selectedIcon: $selectedIcon)
            case .list:
                IconListView(icons: filteredIcons, selectedIcon: $selectedIcon)
            case .grid:
                IconGridView(icons: filteredIcons, selectedIcon: $selectedIcon)
            case .gallery:
                IconGalleryView(icons: filteredIcons, selectedIcon: $selectedIcon)
            }
        }
    }
    
    // MARK: - Detail View
    
    @ViewBuilder
    private var detailView: some View {
        if let icon = selectedIcon {
            IconDetailView(icon: icon)
        } else {
            ContentUnavailableView(
                "Select an Icon",
                systemImage: "photo",
                description: Text("Choose an icon to view details")
            )
        }
    }
    
    // MARK: - Helpers
    
    private var filteredIcons: [StoredIcon] {
        var result = icons
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category.rawValue }
        }
        
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter { icon in
                icon.name.lowercased().contains(query) ||
                icon.description.lowercased().contains(query) ||
                icon.tags.contains { $0.lowercased().contains(query) }
            }
        }
        
        return result
    }
    
    private func loadIcons() async {
        do {
            try await IconStorageService.shared.initialize()
            icons = await IconStorageService.shared.fetchAll()
            isLoading = false
        } catch {
            print("Failed to load icons: \(error)")
            isLoading = false
        }
    }
    
    private func categoryIcon(_ category: IconKit.IconCategory) -> String {
        switch category {
        case .project: return "folder.fill"
        case .package: return "shippingbox.fill"
        case .feature: return "star.fill"
        case .service: return "gearshape.fill"
        case .module: return "square.stack.3d.up.fill"
        case .capability: return "lightbulb.fill"
        }
    }
}

// MARK: - Table View

public struct IconTableView: View {
    public let icons: [StoredIcon]
    @Binding public var selectedIcon: StoredIcon?
    
    public init(icons: [StoredIcon], selectedIcon: Binding<StoredIcon?>) {
        self.icons = icons
        self._selectedIcon = selectedIcon
    }
    
    public var body: some View {
        Table(icons, selection: Binding(
            get: { selectedIcon?.id },
            set: { id in selectedIcon = icons.first { $0.id == id } }
        )) {
            TableColumn("Icon") { icon in
                IconDesign(style: icon.iconStyle, size: 32)
            }
            .width(50)
            
            TableColumn("Name", value: \.name)
            TableColumn("Category", value: \.category)
            TableColumn("Style", value: \.style)
            
            TableColumn("Tags") { icon in
                Text(icon.tags.joined(separator: ", "))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - List View

public struct IconListView: View {
    public let icons: [StoredIcon]
    @Binding public var selectedIcon: StoredIcon?
    
    public init(icons: [StoredIcon], selectedIcon: Binding<StoredIcon?>) {
        self.icons = icons
        self._selectedIcon = selectedIcon
    }
    
    public var body: some View {
        List(icons, selection: Binding(
            get: { selectedIcon?.id },
            set: { id in selectedIcon = icons.first { $0.id == id } }
        )) { icon in
            HStack(spacing: 12) {
                IconDesign(style: icon.iconStyle, size: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(icon.name)
                        .font(.headline)
                    Text(icon.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(icon.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.blue.opacity(0.2)))
                    
                    Text(icon.style)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
            .tag(icon.id)
        }
    }
}

// MARK: - Grid View

public struct IconGridView: View {
    public let icons: [StoredIcon]
    @Binding public var selectedIcon: StoredIcon?
    
    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 16)]
    
    public init(icons: [StoredIcon], selectedIcon: Binding<StoredIcon?>) {
        self.icons = icons
        self._selectedIcon = selectedIcon
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(icons) { icon in
                    IconGridItem(icon: icon, isSelected: selectedIcon?.id == icon.id)
                        .onTapGesture {
                            selectedIcon = icon
                        }
                }
            }
            .padding()
        }
    }
}

public struct IconGridItem: View {
    public let icon: StoredIcon
    public let isSelected: Bool
    
    public init(icon: StoredIcon, isSelected: Bool) {
        self.icon = icon
        self.isSelected = isSelected
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            IconDesign(style: icon.iconStyle, size: 64)
                .shadow(color: isSelected ? .blue : .clear, radius: 8)
            
            Text(icon.name)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .lineLimit(1)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Gallery View

public struct IconGalleryView: View {
    public let icons: [StoredIcon]
    @Binding public var selectedIcon: StoredIcon?
    
    private let columns = [GridItem(.adaptive(minimum: 200), spacing: 20)]
    
    public init(icons: [StoredIcon], selectedIcon: Binding<StoredIcon?>) {
        self.icons = icons
        self._selectedIcon = selectedIcon
    }
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(icons) { icon in
                    IconGalleryItem(icon: icon, isSelected: selectedIcon?.id == icon.id)
                        .onTapGesture {
                            selectedIcon = icon
                        }
                }
            }
            .padding()
        }
    }
}

public struct IconGalleryItem: View {
    public let icon: StoredIcon
    public let isSelected: Bool
    
    public init(icon: StoredIcon, isSelected: Bool) {
        self.icon = icon
        self.isSelected = isSelected
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            IconDesign(style: icon.iconStyle, size: 128)
                .shadow(radius: isSelected ? 10 : 4)
            
            VStack(spacing: 4) {
                Text(icon.name)
                    .font(.headline)
                
                Text(icon.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 4) {
                    ForEach(icon.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(.secondary.opacity(0.2)))
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
        )
    }
}
