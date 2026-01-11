//
//  UIKit.swift
//  UIKit
//
//  Comprehensive UI System Kit
//  Contains all UI systems, layouts, templates, and kit contexts
//

import Foundation
import DataKit

// MARK: - UIKit Entry Point

/// UIKit provides a complete UI system library for building complex interfaces
/// 
/// Architecture:
/// - Systems: Core UI building blocks (sidebars, panels, toolbars, etc.)
/// - Layouts: Pre-built layout configurations
/// - Templates: Complete page/screen templates
/// - Components: Reusable UI components
/// - KitContexts: Kit-specific UI configurations
/// - Models: UI state and configuration models
/// - Protocols: Contracts for UI systems
///
public struct UIKit {
    public static let version = "1.0.0"
    
    /// Initialize UIKit and register all systems
    public static func initialize() {
        // Register all kit contexts
        KitContextRegistry.shared.registerAll()
        
        // Register all layout templates
        LayoutTemplateRegistry.shared.registerAll()
        
        // Register all system definitions
        UISystemRegistry.shared.registerAll()
    }
}

// MARK: - Re-exports

// Systems
@_exported import struct UIKit.DoubleSidebarSystem
@_exported import struct UIKit.FloatingPanelSystem
@_exported import struct UIKit.BottomBarSystem
@_exported import struct UIKit.ToolbarSystem
@_exported import struct UIKit.BreadcrumbSystem
@_exported import struct UIKit.InspectorSystem
@_exported import struct UIKit.TabSystem
@_exported import struct UIKit.NavigationSystem
@_exported import struct UIKit.ModalSystem
@_exported import struct UIKit.ToastSystem
@_exported import struct UIKit.ContextMenuSystem
@_exported import struct UIKit.CommandPaletteSystem
@_exported import struct UIKit.SplitViewSystem
@_exported import struct UIKit.GridSystem
@_exported import struct UIKit.CardSystem
@_exported import struct UIKit.ListSystem
