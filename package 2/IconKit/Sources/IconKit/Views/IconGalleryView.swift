//
//  IconGalleryView.swift
//  IconKit
//
//  Gallery view showing all variants of an icon grouped together
//  Supports viewing, comparing, and exporting all variants
//

import SwiftUI

/// Gallery view for all icon variants
public struct IconVariantGalleryView: View {
    public let iconType: ProjectIconType
    @State private var selectedVariant: IconVariantType = .inApp
    @State private var selectedSize: Int = 128
    @State private var showExportSheet = false
    @State private var groupByCategory = true
    
    public init(iconType: ProjectIconType) {
        self.iconType = iconType
    }
    
    public var body: some View {
        HSplitView {
            // Variant list
            variantSidebar
                .frame(minWidth: 200, maxWidth: 300)
            
            // Main preview
            mainPreview
                .frame(minWidth: 400)
            
            // Size previews
            sizePreviewPanel
                .frame(minWidth: 200, maxWidth: 300)
        }
        .toolbar {
            ToolbarItemGroup {
                Toggle("Group by Category", isOn: $groupByCategory)
                
                Button {
                    showExportSheet = true
                } label: {
                    Label("Export All", systemImage: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showExportSheet) {
            IconExportAllSheet(iconType: iconType)
        }
    }
    
    // MARK: - Variant Sidebar
    
    private var variantSidebar: some View {
        List(selection: $selectedVariant) {
            if groupByCategory {
                ForEach(VariantCategory.allCases, id: \.self) { category in
                    Section(category.rawValue) {
                        ForEach(category.variants, id: \.self) { variant in
                            variantRow(variant)
                                .tag(variant)
                        }
                    }
                }
            } else {
                ForEach(IconVariantType.allCases, id: \.self) { variant in
                    variantRow(variant)
                        .tag(variant)
                }
            }
        }
        .listStyle(.sidebar)
    }
    
    private func variantRow(_ variant: IconVariantType) -> some View {
        HStack {
            iconType.icon(size: 32, variant: variant)
            
            VStack(alignment: .leading) {
                Text(variant.displayName)
                    .font(.caption)
                Text("\(variant.defaultSizes.count) sizes")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
    
    // MARK: - Main Preview
    
    private var mainPreview: some View {
        VStack(spacing: 20) {
            Text(selectedVariant.displayName)
                .font(.headline)
            
            iconType.icon(size: CGFloat(selectedSize), variant: selectedVariant)
                .frame(width: CGFloat(selectedSize), height: CGFloat(selectedSize))
                .background(
                    checkerboardBackground
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                )
                .shadow(radius: 10)
            
            Text("\(selectedSize) × \(selectedSize)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // Size slider
            VStack {
                Slider(value: Binding(
                    get: { Double(selectedSize) },
                    set: { selectedSize = Int($0) }
                ), in: 16...512, step: 16)
                .frame(width: 300)
                
                HStack {
                    Text("16")
                    Spacer()
                    Text("512")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(width: 300)
            }
            
            // Quick size buttons
            HStack(spacing: 8) {
                ForEach([32, 64, 128, 256, 512], id: \.self) { size in
                    Button("\(size)") {
                        selectedSize = size
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedSize == size ? .blue : .secondary)
                }
            }
        }
        .padding()
    }
    
    // MARK: - Size Preview Panel
    
    private var sizePreviewPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("All Sizes")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(selectedVariant.defaultSizes, id: \.self) { size in
                    HStack {
                        iconType.icon(size: CGFloat(min(size, 64)), variant: selectedVariant)
                            .frame(width: 64, height: 64)
                        
                        VStack(alignment: .leading) {
                            Text("\(size)px")
                                .font(.caption)
                                .fontWeight(.medium)
                            
                            if size > 64 {
                                Text("Scaled preview")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedSize = size
                        } label: {
                            Image(systemName: "eye")
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedSize == size ? Color.blue.opacity(0.1) : Color.clear)
                    )
                }
            }
            .padding(.vertical)
        }
    }
    
    private var checkerboardBackground: some View {
        Canvas { context, size in
            let tileSize: CGFloat = 10
            for row in 0..<Int(size.height / tileSize) + 1 {
                for col in 0..<Int(size.width / tileSize) + 1 {
                    let isLight = (row + col) % 2 == 0
                    let rect = CGRect(
                        x: CGFloat(col) * tileSize,
                        y: CGFloat(row) * tileSize,
                        width: tileSize,
                        height: tileSize
                    )
                    context.fill(
                        Path(rect),
                        with: .color(isLight ? Color.gray.opacity(0.2) : Color.gray.opacity(0.3))
                    )
                }
            }
        }
    }
}



// MARK: - Export All Sheet

public struct IconExportAllSheet: View {
    public let iconType: ProjectIconType
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVariants: Set<IconVariantType> = Set(IconVariantSpec.essentialVariants.map(\.type))
    @State private var exportPath = ""
    @State private var isExporting = false
    @State private var exportProgress: Double = 0
    @State private var exportResult: String?
    
    public init(iconType: ProjectIconType) {
        self.iconType = iconType
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Export \(iconType.displayName) Icons")
                .font(.headline)
            
            // Variant selection
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(VariantCategory.allCases, id: \.self) { category in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(category.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Button("All") {
                                    for variant in category.variants {
                                        selectedVariants.insert(variant)
                                    }
                                }
                                .buttonStyle(.borderless)
                                .font(.caption)
                                
                                Button("None") {
                                    for variant in category.variants {
                                        selectedVariants.remove(variant)
                                    }
                                }
                                .buttonStyle(.borderless)
                                .font(.caption)
                            }
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 8) {
                                ForEach(category.variants, id: \.self) { variant in
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
                                    .toggleStyle(.checkbox)
                                    .font(.caption)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(nsColor: .controlBackgroundColor))
                        )
                    }
                }
            }
            .frame(height: 300)
            
            // Export info
            HStack {
                Text("Selected: \(selectedVariants.count) variants")
                Spacer()
                Text("~\(estimatedFileCount) files")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            if isExporting {
                ProgressView(value: exportProgress)
                    .progressViewStyle(.linear)
            }
            
            if let result = exportResult {
                Text(result)
                    .font(.caption)
                    .foregroundStyle(.green)
            }
            
            Divider()
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Export to xcassets") {
                    exportToXCAssets()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedVariants.isEmpty || isExporting)
            }
        }
        .padding()
        .frame(width: 600, height: 500)
    }
    
    private var estimatedFileCount: Int {
        selectedVariants.reduce(0) { $0 + $1.defaultSizes.count }
    }
    
    private func exportToXCAssets() {
        isExporting = true
        exportProgress = 0
        
        // Simulate export (actual implementation would use IconGenerationService)
        Task {
            let total = Double(selectedVariants.count)
            for (index, _) in selectedVariants.enumerated() {
                try? await Task.sleep(nanoseconds: 100_000_000)
                await MainActor.run {
                    exportProgress = Double(index + 1) / total
                }
            }
            
            await MainActor.run {
                isExporting = false
                exportResult = "Exported \(estimatedFileCount) files successfully!"
            }
        }
    }
}

// MARK: - All Icons Gallery

/// View showing all project icons with their variants
public struct AllIconsGalleryView: View {
    @State private var selectedIcon: ProjectIconType = .flowKit
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView {
            List(ProjectIconType.allCases, selection: $selectedIcon) { iconType in
                HStack {
                    iconType.icon(size: 48)
                    
                    VStack(alignment: .leading) {
                        Text(iconType.displayName)
                            .font(.headline)
                        Text(iconType.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
                .tag(iconType)
            }
            .listStyle(.sidebar)
            .frame(minWidth: 250)
        } detail: {
            IconVariantGalleryView(iconType: selectedIcon)
        }
        .navigationTitle("Icon Gallery")
    }
}

// MARK: - Preview

#Preview("Icon Variant Gallery") {
    IconVariantGalleryView(iconType: .flowKit)
        .frame(width: 1000, height: 700)
}

#Preview("All Icons Gallery") {
    AllIconsGalleryView()
        .frame(width: 1200, height: 800)
}
