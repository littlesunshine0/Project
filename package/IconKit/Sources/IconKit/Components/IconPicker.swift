//
//  IconPicker.swift
//  IconKit
//
//  Drop-in icon picker component
//  Use in any project to select icons
//

import SwiftUI

/// Drop-in icon picker - select from stored icons
public struct IconPicker: View {
    @Binding public var selectedIconId: String?
    @State private var icons: [StoredIcon] = []
    @State private var searchText = ""
    @State private var selectedCategory: IconKit.IconCategory?
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    
    private let columns = [GridItem(.adaptive(minimum: 80), spacing: 12)]
    
    public init(selectedIconId: Binding<String?>) {
        self._selectedIconId = selectedIconId
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Select Icon")
                    .font(.headline)
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Divider()
            
            // Category filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CategoryChip(
                        title: "All",
                        isSelected: selectedCategory == nil,
                        action: { selectedCategory = nil }
                    )
                    
                    ForEach(IconKit.IconCategory.allCases, id: \.self) { category in
                        CategoryChip(
                            title: category.rawValue,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            
            // Search
            TextField("Search icons...", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            // Grid
            if isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredIcons) { icon in
                            IconPickerItem(
                                icon: icon,
                                isSelected: selectedIconId == icon.id
                            )
                            .onTapGesture {
                                selectedIconId = icon.id
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(minWidth: 400, minHeight: 500)
        .task {
            await loadIcons()
        }
    }
    
    private var filteredIcons: [StoredIcon] {
        var result = icons
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category.rawValue }
        }
        
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter { icon in
                icon.name.lowercased().contains(query) ||
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
            isLoading = false
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.secondary.opacity(0.2))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

struct IconPickerItem: View {
    let icon: StoredIcon
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            IconDesign(style: icon.iconStyle, size: 48)
                .shadow(color: isSelected ? .blue : .clear, radius: 4)
            
            Text(icon.name)
                .font(.caption2)
                .lineLimit(1)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Compact Icon Picker

/// Compact icon picker - shows selected icon with popover
public struct CompactIconPicker: View {
    @Binding public var selectedIconId: String?
    @State private var showPicker = false
    @State private var selectedIcon: StoredIcon?
    
    public init(selectedIconId: Binding<String?>) {
        self._selectedIconId = selectedIconId
    }
    
    public var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack(spacing: 8) {
                if let icon = selectedIcon {
                    IconDesign(style: icon.iconStyle, size: 32)
                    Text(icon.name)
                        .font(.caption)
                } else {
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text("Select Icon")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPicker) {
            IconPicker(selectedIconId: $selectedIconId)
        }
        .task {
            await loadSelectedIcon()
        }
        .onChange(of: selectedIconId) { _, _ in
            Task { await loadSelectedIcon() }
        }
    }
    
    private func loadSelectedIcon() async {
        guard let id = selectedIconId else {
            selectedIcon = nil
            return
        }
        try? await IconStorageService.shared.initialize()
        selectedIcon = await IconStorageService.shared.fetch(id: id)
    }
}

// MARK: - Style Picker

/// Pick an icon style (not a stored icon)
public struct IconStylePicker: View {
    @Binding public var selectedStyle: IconStyle
    @State private var showPicker = false
    
    private let columns = [GridItem(.adaptive(minimum: 80), spacing: 12)]
    
    public init(selectedStyle: Binding<IconStyle>) {
        self._selectedStyle = selectedStyle
    }
    
    public var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack(spacing: 8) {
                IconDesign(style: selectedStyle, size: 32)
                Text(selectedStyle.rawValue)
                    .font(.caption)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(nsColor: .controlBackgroundColor))
            )
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPicker) {
            VStack(spacing: 0) {
                Text("Select Style")
                    .font(.headline)
                    .padding()
                
                Divider()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(IconStyle.allCases, id: \.self) { style in
                            VStack(spacing: 4) {
                                IconDesign(style: style, size: 48)
                                    .shadow(color: selectedStyle == style ? .blue : .clear, radius: 4)
                                
                                Text(style.rawValue)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedStyle == style ? Color.blue.opacity(0.1) : Color.clear)
                            )
                            .onTapGesture {
                                selectedStyle = style
                                showPicker = false
                            }
                        }
                    }
                    .padding()
                }
            }
            .frame(width: 400, height: 400)
        }
    }
}
