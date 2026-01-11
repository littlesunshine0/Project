//
//  KitIconComparisonView.swift
//  IconKit
//
//  Comparison view showing all Kit icons with their consistent design
//  Deep squircle + Blue gradient + Unique symbol per Kit
//

import SwiftUI

/// Comparison view for all Kit icons
/// Shows the consistent design system: deep squircle + blue gradient
public struct KitIconComparisonView: View {
    @State private var selectedVariant: IconVariantType = .inApp
    @State private var iconSize: CGFloat = 128
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Kit Icon Design System")
                    .font(.title.bold())
                
                Text("Deep Squircle + Blue Gradient + Unique Symbol")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
            
            // Kit icons comparison
            HStack(spacing: 40) {
                kitIconCard(
                    title: "IdeaKit",
                    subtitle: "Project Operating System",
                    symbol: "lightbulb.fill"
                ) {
                    IdeaKitIcon(size: iconSize, variant: selectedVariant)
                }
                
                kitIconCard(
                    title: "IconKit",
                    subtitle: "Universal Icon System",
                    symbol: "paintbrush.pointed.fill"
                ) {
                    IconKitIcon(size: iconSize, variant: selectedVariant)
                }
            }
            
            Divider()
            
            // Project icon (different design)
            VStack(spacing: 12) {
                Text("Project Icon (Different Design)")
                    .font(.headline)
                
                Text("FlowKit is a Project, not a Kit - uses warm glowing orb")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                kitIconCard(
                    title: "FlowKit",
                    subtitle: "Main Application",
                    symbol: "circle.fill"
                ) {
                    FlowKitIcon(size: iconSize, variant: selectedVariant)
                }
            }
            
            Divider()
            
            // Controls
            VStack(spacing: 16) {
                // Variant picker
                HStack {
                    Text("Variant:")
                        .font(.subheadline)
                    
                    Picker("Variant", selection: $selectedVariant) {
                        ForEach([
                            IconVariantType.inApp,
                            .solidBlack,
                            .solidWhite,
                            .outline,
                            .accessible,
                            .darkMode,
                            .lightMode
                        ], id: \.self) { variant in
                            Text(variant.displayName).tag(variant)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 500)
                }
                
                // Size slider
                HStack {
                    Text("Size: \(Int(iconSize))px")
                        .font(.subheadline)
                        .frame(width: 100, alignment: .leading)
                    
                    Slider(value: $iconSize, in: 48...256, step: 16)
                        .frame(maxWidth: 300)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
            )
        }
        .padding()
    }
    
    @ViewBuilder
    private func kitIconCard<Content: View>(
        title: String,
        subtitle: String,
        symbol: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 12) {
            content()
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: symbol)
                        .font(.caption2)
                    Text("Symbol")
                        .font(.caption2)
                }
                .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.05))
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - All Variants Grid

/// Grid showing all variants for all Kit icons
public struct KitIconAllVariantsView: View {
    public init() {}
    
    private let variants: [IconVariantType] = [
        .inApp, .solidBlack, .solidWhite, .outline,
        .accessible, .darkMode, .lightMode
    ]
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("All Kit Icon Variants")
                    .font(.title.bold())
                
                // IdeaKit variants
                variantSection(title: "IdeaKit", subtitle: "Lightbulb Symbol") { variant in
                    IdeaKitIcon(size: 80, variant: variant)
                }
                
                // IconKit variants
                variantSection(title: "IconKit", subtitle: "Paintbrush Symbol") { variant in
                    IconKitIcon(size: 80, variant: variant)
                }
                
                Divider()
                    .padding(.vertical)
                
                // FlowKit variants (different design)
                VStack(spacing: 8) {
                    Text("FlowKit (Project Icon)")
                        .font(.headline)
                    Text("Different design - warm glowing orb")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                variantSection(title: "FlowKit", subtitle: "Warm Orb") { variant in
                    FlowKitIcon(size: 80, variant: variant)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func variantSection<Content: View>(
        title: String,
        subtitle: String,
        @ViewBuilder icon: @escaping (IconVariantType) -> Content
    ) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 16) {
                ForEach(variants, id: \.self) { variant in
                    VStack(spacing: 8) {
                        icon(variant)
                        Text(variant.displayName)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.05))
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.02))
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview("Kit Icon Comparison") {
    KitIconComparisonView()
        .frame(width: 800, height: 900)
}

#Preview("All Kit Variants") {
    KitIconAllVariantsView()
        .frame(width: 900, height: 1200)
}
