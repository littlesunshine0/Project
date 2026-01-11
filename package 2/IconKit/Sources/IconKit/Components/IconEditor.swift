//
//  IconEditor.swift
//  IconKit
//
//  Drop-in icon editor component
//  Create and edit icons in any project
//

import SwiftUI

/// Drop-in icon editor - create and modify icons
public struct IconEditor: View {
    @Binding public var icon: StoredIcon
    @State private var previewSize: CGFloat = 128
    @Environment(\.dismiss) private var dismiss
    
    public init(icon: Binding<StoredIcon>) {
        self._icon = icon
    }
    
    public var body: some View {
        HSplitView {
            // Editor panel
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    basicInfoSection
                    Divider()
                    styleSection
                    Divider()
                    colorsSection
                    Divider()
                    tagsSection
                    Divider()
                    metadataSection
                }
                .padding()
            }
            .frame(minWidth: 300)
            
            // Preview panel
            VStack(spacing: 20) {
                Text("Preview")
                    .font(.headline)
                
                IconDesign(style: icon.iconStyle, size: previewSize)
                    .shadow(radius: 8)
                
                Slider(value: $previewSize, in: 32...512, step: 32) {
                    Text("Size")
                }
                .frame(width: 200)
                
                Text("\(Int(previewSize)) × \(Int(previewSize))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // Size previews
                HStack(spacing: 16) {
                    ForEach([32, 64, 128, 256], id: \.self) { size in
                        VStack {
                            IconDesign(style: icon.iconStyle, size: CGFloat(size))
                            Text("\(size)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding()
            .frame(minWidth: 400)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
    
    // MARK: - Basic Info
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Basic Info")
                .font(.headline)
            
            LabeledContent("Name") {
                TextField("Icon name", text: $icon.name)
                    .textFieldStyle(.roundedBorder)
            }
            
            LabeledContent("Description") {
                TextField("Description", text: $icon.description)
                    .textFieldStyle(.roundedBorder)
            }
            
            LabeledContent("Category") {
                Picker("Category", selection: Binding(
                    get: { icon.iconCategory },
                    set: { icon.category = $0.rawValue }
                )) {
                    ForEach(IconKit.IconCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
    
    // MARK: - Style
    
    private var styleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Style")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 8) {
                ForEach(IconStyle.allCases, id: \.self) { style in
                    VStack(spacing: 4) {
                        IconDesign(style: style, size: 48)
                            .shadow(color: icon.style == style.rawValue ? .blue : .clear, radius: 4)
                        
                        Text(style.rawValue)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(icon.style == style.rawValue ? Color.blue.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(icon.style == style.rawValue ? Color.blue : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        icon.style = style.rawValue
                    }
                }
            }
        }
    }
    
    // MARK: - Colors
    
    private var colorsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Colors")
                    .font(.headline)
                Spacer()
                Button {
                    icon.colors.append("#3498DB")
                } label: {
                    Image(systemName: "plus.circle")
                }
                .buttonStyle(.plain)
            }
            
            if icon.colors.isEmpty {
                Text("No custom colors - using default")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(icon.colors.enumerated()), id: \.offset) { index, hex in
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: hex) ?? .gray)
                            .frame(width: 24, height: 24)
                        
                        TextField("Hex", text: Binding(
                            get: { icon.colors[index] },
                            set: { icon.colors[index] = $0 }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                        
                        Button {
                            icon.colors.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // Preset colors
            HStack(spacing: 8) {
                Text("Presets:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                ForEach(presetColors, id: \.self) { hex in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: hex) ?? .gray)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            if !icon.colors.contains(hex) {
                                icon.colors.append(hex)
                            }
                        }
                }
            }
        }
    }
    
    private var presetColors: [String] {
        ["#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7", "#DDA0DD", "#98D8C8", "#F7DC6F"]
    }
    
    // MARK: - Tags
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tags")
                    .font(.headline)
                Spacer()
                Button {
                    icon.tags.append("new-tag")
                } label: {
                    Image(systemName: "plus.circle")
                }
                .buttonStyle(.plain)
            }
            
            FlowLayout(spacing: 8) {
                ForEach(Array(icon.tags.enumerated()), id: \.offset) { index, tag in
                    HStack(spacing: 4) {
                        TextField("Tag", text: Binding(
                            get: { icon.tags[index] },
                            set: { icon.tags[index] = $0 }
                        ))
                        .textFieldStyle(.plain)
                        .frame(width: 80)
                        
                        Button {
                            icon.tags.remove(at: index)
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption2)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.secondary.opacity(0.2)))
                }
            }
        }
    }
    
    // MARK: - Metadata
    
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metadata")
                .font(.headline)
            
            Toggle("Custom Icon", isOn: $icon.isCustom)
            
            LabeledContent("ID") {
                Text(icon.id)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent("Created") {
                Text(formatDate(icon.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent("Updated") {
                Text(formatDate(icon.updatedAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
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

// MARK: - Create Icon Sheet

/// Sheet for creating a new icon
public struct CreateIconSheet: View {
    @State private var newIcon: StoredIcon
    @Environment(\.dismiss) private var dismiss
    let onSave: (StoredIcon) -> Void
    
    public init(category: IconKit.IconCategory = .module, onSave: @escaping (StoredIcon) -> Void) {
        self._newIcon = State(initialValue: StoredIcon(
            name: "New Icon",
            category: category,
            style: category.defaultIcon,
            isCustom: true
        ))
        self.onSave = onSave
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Text("Create Icon")
                    .font(.headline)
                
                Spacer()
                
                Button("Save") {
                    onSave(newIcon)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(newIcon.name.isEmpty)
            }
            .padding()
            
            Divider()
            
            IconEditor(icon: $newIcon)
        }
    }
}
