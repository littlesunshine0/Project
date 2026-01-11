//
//  IconDetailView.swift
//  IconKit
//
//  Detailed view of a single icon with all variants
//  Drop-in ready - works with any project
//

import SwiftUI

/// Detailed view for a single icon
public struct IconDetailView: View {
    public let icon: StoredIcon
    @State private var selectedVariant: VariantType = .appIcon
    @State private var selectedSize: Int = 256
    @State private var showExportSheet = false
    
    public init(icon: StoredIcon) {
        self.icon = icon
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                Divider()
                previewSection
                Divider()
                variantsSection
                Divider()
                metadataSection
                Divider()
                actionsSection
            }
            .padding()
        }
        .navigationTitle(icon.name)
        .sheet(isPresented: $showExportSheet) {
            IconExportSheet(icon: icon)
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(spacing: 20) {
            IconDesign(style: icon.iconStyle, size: 128)
                .shadow(radius: 8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(icon.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(icon.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 8) {
                    CategoryBadge(category: icon.category)
                    StyleBadge(style: icon.style)
                }
                
                HStack(spacing: 4) {
                    ForEach(icon.tags, id: \.self) { tag in
                        TagBadge(tag: tag)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Preview Section
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preview")
                .font(.headline)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Size")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Picker("Size", selection: $selectedSize) {
                        ForEach([16, 32, 64, 128, 256, 512], id: \.self) { size in
                            Text("\(size)px").tag(size)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Spacer()
                
                VStack {
                    IconDesign(style: icon.iconStyle, size: CGFloat(selectedSize))
                        .frame(width: CGFloat(selectedSize), height: CGFloat(selectedSize))
                    
                    Text("\(selectedSize) × \(selectedSize)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    // MARK: - Variants Section
    
    private var variantsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Variants")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                ForEach(icon.variants) { variant in
                    VariantCard(
                        icon: icon,
                        variant: variant,
                        isSelected: selectedVariant == variant.type
                    )
                    .onTapGesture {
                        selectedVariant = variant.type
                    }
                }
            }
        }
    }
    
    // MARK: - Metadata Section
    
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Metadata")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetadataRow(label: "ID", value: icon.id)
                MetadataRow(label: "Category", value: icon.category)
                MetadataRow(label: "Style", value: icon.style)
                MetadataRow(label: "Custom", value: icon.isCustom ? "Yes" : "No")
                MetadataRow(label: "Created", value: formatDate(icon.createdAt))
                MetadataRow(label: "Updated", value: formatDate(icon.updatedAt))
            }
            
            if !icon.colors.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Colors")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: 8) {
                        ForEach(icon.colors, id: \.self) { hex in
                            ColorSwatch(hex: hex)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Actions Section
    
    private var actionsSection: some View {
        HStack(spacing: 16) {
            Button {
                showExportSheet = true
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                copyToClipboard()
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            if icon.isCustom {
                Button(role: .destructive) {
                    Task { await deleteIcon() }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString("IconDesign(style: .\(icon.style), size: \(selectedSize))", forType: .string)
    }
    
    private func deleteIcon() async {
        try? await IconStorageService.shared.delete(id: icon.id)
    }
}

// MARK: - Supporting Views

public struct CategoryBadge: View {
    public let category: String
    
    public init(category: String) {
        self.category = category
    }
    
    public var body: some View {
        Text(category)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(.blue.opacity(0.2)))
    }
}

public struct StyleBadge: View {
    public let style: String
    
    public init(style: String) {
        self.style = style
    }
    
    public var body: some View {
        Text(style)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(.purple.opacity(0.2)))
    }
}

public struct TagBadge: View {
    public let tag: String
    
    public init(tag: String) {
        self.tag = tag
    }
    
    public var body: some View {
        Text(tag)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(.secondary.opacity(0.2)))
    }
}

public struct VariantCard: View {
    public let icon: StoredIcon
    public let variant: IconVariant
    public let isSelected: Bool
    
    public init(icon: StoredIcon, variant: IconVariant, isSelected: Bool) {
        self.icon = icon
        self.variant = variant
        self.isSelected = isSelected
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            IconDesign(style: icon.iconStyle, size: 64)
                .opacity(variant.type == .monochrome ? 0.7 : 1.0)
                .saturation(variant.type == .monochrome ? 0 : 1)
            
            Text(variant.type.displayName)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
            
            HStack(spacing: 2) {
                Image(systemName: variant.isGenerated ? "checkmark.circle.fill" : "circle")
                    .font(.caption2)
                    .foregroundStyle(variant.isGenerated ? .green : .secondary)
                Text(variant.isGenerated ? "Generated" : "Pending")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

public struct MetadataRow: View {
    public let label: String
    public let value: String
    
    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }
    
    public var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

public struct ColorSwatch: View {
    public let hex: String
    
    public init(hex: String) {
        self.hex = hex
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(hex: hex) ?? .gray)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
            
            Text(hex)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Export Sheet

public struct IconExportSheet: View {
    public let icon: StoredIcon
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVariants: Set<VariantType> = [.appIcon]
    @State private var exportPath = ""
    @State private var isExporting = false
    
    public init(icon: StoredIcon) {
        self.icon = icon
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Export \(icon.name)")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Variants")
                    .font(.subheadline)
                
                ForEach(VariantType.allCases, id: \.self) { variant in
                    Toggle(variant.displayName, isOn: Binding(
                        get: { selectedVariants.contains(variant) },
                        set: { isOn in
                            if isOn {
                                selectedVariants.insert(variant)
                            } else {
                                selectedVariants.remove(variant)
                            }
                        }
                    ))
                }
            }
            
            Divider()
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Export") {
                    Task { await exportIcon() }
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedVariants.isEmpty)
            }
        }
        .padding()
        .frame(width: 400)
    }
    
    private func exportIcon() async {
        isExporting = true
        // Export logic using XCAssetExporter
        dismiss()
    }
}
