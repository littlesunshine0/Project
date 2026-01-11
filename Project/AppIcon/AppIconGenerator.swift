//
//  AppIconGenerator.swift
//  FlowKit
//
//  App icon generation using IconKit
//  This file provides project-specific icon configuration
//

import SwiftUI
import IconKit

// MARK: - Project Icon Configuration

/// FlowKit project icon definitions
struct FlowKitIcons {
    
    /// Main app icon
    static let appIcon = IconDefinition(
        id: "flowkit_app",
        name: "FlowKit",
        category: .project,
        style: .glowOrb,
        label: "FK"
    )
    
    /// Package icons
    static let packages: [IconDefinition] = [
        IconDefinition(id: "pkg_ideakit", name: "IdeaKit", category: .package, style: .cube),
        IconDefinition(id: "pkg_iconkit", name: "IconKit", category: .package, style: .hexagon),
        IconDefinition(id: "pkg_docmodule", name: "DocModule", category: .package, style: .cube),
        IconDefinition(id: "pkg_hig", name: "HIG", category: .package, style: .cube),
        IconDefinition(id: "pkg_orchestrator", name: "Orchestrator", category: .package, style: .cube),
        IconDefinition(id: "pkg_spatialviews", name: "SpatialViews", category: .package, style: .cube),
        IconDefinition(id: "pkg_generic", name: "GenericModule", category: .package, style: .cube)
    ]
    
    /// Capability icons (8 universal capabilities)
    static let capabilities: [IconDefinition] = [
        IconDefinition(id: "cap_intent", name: "Intent", category: .capability, style: .lightbulb),
        IconDefinition(id: "cap_context", name: "Context", category: .capability, style: .layers),
        IconDefinition(id: "cap_structure", name: "Structure", category: .capability, style: .grid),
        IconDefinition(id: "cap_work", name: "Work", category: .capability, style: .gear),
        IconDefinition(id: "cap_decisions", name: "Decisions", category: .capability, style: .diamond),
        IconDefinition(id: "cap_risk", name: "Risk", category: .capability, style: .badge),
        IconDefinition(id: "cap_feedback", name: "Feedback", category: .capability, style: .circuit),
        IconDefinition(id: "cap_outcome", name: "Outcome", category: .capability, style: .star)
    ]
    
    /// All icons
    static var all: [IconDefinition] {
        [appIcon] + packages + capabilities
    }
}

// MARK: - Icon Generator

/// Generates all FlowKit icons
@MainActor
class FlowKitIconGenerator {
    
    private let exporter = XCAssetExporter()
    
    /// Generate all app icon sizes
    func generateAppIcon(to outputPath: String) throws {
        try exporter.exportAppIcon(FlowKitIcons.appIcon, to: outputPath)
        print("✅ Generated FlowKit app icon")
    }
    
    /// Generate all package icons
    func generatePackageIcons(to outputPath: String) throws {
        try exporter.export(icons: FlowKitIcons.packages, to: outputPath)
        print("✅ Generated \(FlowKitIcons.packages.count) package icons")
    }
    
    /// Generate all capability icons
    func generateCapabilityIcons(to outputPath: String) throws {
        try exporter.export(icons: FlowKitIcons.capabilities, to: outputPath)
        print("✅ Generated \(FlowKitIcons.capabilities.count) capability icons")
    }
    
    /// Generate all icons
    func generateAllIcons(to outputPath: String) throws {
        try generateAppIcon(to: outputPath)
        try generatePackageIcons(to: outputPath)
        try generateCapabilityIcons(to: outputPath)
        print("✅ Generated all FlowKit icons")
    }
}

// MARK: - Preview

#Preview("FlowKit App Icon") {
    IconDesign(style: .brain, size: 512, label: "")
}

#Preview("Package Icons") {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
        ForEach(FlowKitIcons.packages) { icon in
            VStack {
                IconDesign(style: icon.style, size: 64)
                Text(icon.name)
                    .font(.caption)
            }
        }
    }
    .padding()
}

#Preview("Capability Icons") {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
        ForEach(FlowKitIcons.capabilities) { icon in
            VStack {
                IconDesign(style: icon.style, size: 64)
                Text(icon.name)
                    .font(.caption)
            }
        }
    }
    .padding()
}

// MARK: - Usage Instructions

/*
 To generate all FlowKit icons:
 
 ```swift
 let generator = FlowKitIconGenerator()
 let outputPath = "/path/to/Project/Assets.xcassets"
 
 // Generate all icons
 try generator.generateAllIcons(to: outputPath)
 
 // Or generate specific icon types
 try generator.generateAppIcon(to: outputPath)
 try generator.generatePackageIcons(to: outputPath)
 try generator.generateCapabilityIcons(to: outputPath)
 ```
 
 Icons generated:
 - App icon (all macOS sizes)
 - 7 package icons
 - 8 capability icons
 */
