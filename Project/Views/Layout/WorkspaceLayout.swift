//
//  WorkspaceLayout.swift
//  FlowKit
//
//  Main workspace layout integrating all panels, editors, and navigation
//  
//  Layout Structure:
//  ┌─────────────────────────────────────────────────────────────┐
//  │                        Toolbar                               │
//  ├────────┬────────────────────────────────┬───────────────────┤
//  │        │                                │                   │
//  │  Icon  │      Editor Area               │   Chat Panel      │
//  │  Rail  │   (Tabs + Code Editor)         │   (when open)     │
//  │   +    │                                │                   │
//  │ Files  │                                │                   │
//  │        │                                │                   │
//  │        ├────────────────────────────────┤                   │
//  │        │   Bottom Panel (expandable)    │                   │
//  ├────────┴────────────────────────────────┴───────────────────┤
//  │                    Bottom Navigation Bar                     │
//  └─────────────────────────────────────────────────────────────┘
//

import SwiftUI
import DesignKit
import DataKit

struct WorkspaceLayout: View {
    @StateObject private var workspaceManager = WorkspaceManager.shared
    @Environment(\.colorScheme) private var colorScheme
    
    // Layout constants
    private let iconRailWidth: CGFloat = 56
    private let fileExplorerWidth: CGFloat = 240
    private let chatPanelWidth: CGFloat = 380
    private let panelInset: CGFloat = 12
    private let toolbarHeight: CGFloat = 52
    private let bottomBarHeight: CGFloat = 28
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base background
                FlowPalette.Semantic.background(colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Toolbar
                    workspaceToolbar
                    
                    // Main content area
                    HStack(spacing: 0) {
                        // Left: Icon rail + File explorer
                        leftSidebar
                        
                        // Center: Editor area
                        editorArea(geometry: geometry)
                        
                        // Right: Space for chat panel
                        if workspaceManager.isChatOpen {
                            Color.clear
                                .frame(width: chatPanelWidth + panelInset * 2)
                        }
                    }
                    
                    // Bottom navigation bar
                    BottomNavigationBar(workspaceManager: workspaceManager)
                }
                
                // Floating chat panel (separate from input)
                if workspaceManager.isChatOpen {
                    chatPanelOverlay(geometry: geometry)
                }
                
                // Floating input panel (separate from chat, never touches)
                if workspaceManager.isInputPanelVisible {
                    inputPanelOverlay(geometry: geometry)
                }
                
                // Bottom panel (when expanded from bottom bar)
                if workspaceManager.isBottomBarExpanded {
                    bottomPanelOverlay(geometry: geometry)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Toolbar
    
    private var workspaceToolbar: some View {
        HStack(spacing: 0) {
            // Traffic lights area
            HStack(spacing: 8) {
                TrafficLightButtons()
            }
            .frame(width: iconRailWidth)
            .padding(.leading, 14)
            
            // Navigation buttons
            HStack(spacing: 4) {
                ToolbarButton(icon: "chevron.left", enabled: false) {}
                ToolbarButton(icon: "chevron.right", enabled: false) {}
            }
            .padding(.leading, 8)
            
            // Sidebar toggle
            ToolbarButton(
                icon: "sidebar.left",
                enabled: true,
                isActive: workspaceManager.isLeftSidebarOpen
            ) {
                withAnimation(FlowMotion.sidebarSlide) {
                    workspaceManager.isLeftSidebarOpen.toggle()
                }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Center: Search
            SearchFieldCompact()
                .frame(width: 280)
            
            Spacer()
            
            // Right: Chat toggle + Settings
            HStack(spacing: 6) {
                // Chat toggle
                ToolbarButton(
                    icon: "bubble.right.fill",
                    enabled: true,
                    isActive: workspaceManager.isChatOpen,
                    accentColor: FlowPalette.Category.chat
                ) {
                    withAnimation(FlowMotion.panelTransition) {
                        workspaceManager.toggleChat()
                    }
                }
                
                // Notifications
                ToolbarButton(icon: "bell.fill", enabled: true) {}
                
                // Settings
                ToolbarButton(icon: "gearshape.fill", enabled: true) {}
            }
            .padding(.trailing, 16)
        }
        .frame(height: toolbarHeight)
        .background(toolbarBackground)
    }
    
    private var toolbarBackground: some View {
        ZStack {
            FlowPalette.Semantic.elevated(colorScheme)
            
            VStack {
                Spacer()
                FlowPalette.Border.subtle(colorScheme).frame(height: 1)
            }
        }
    }
    
    // MARK: - Left Sidebar
    
    private var leftSidebar: some View {
        HStack(spacing: 0) {
            // Icon rail
            iconRail
            
            // File explorer
            if workspaceManager.isLeftSidebarOpen {
                FileExplorerView(workspaceManager: workspaceManager)
                    .frame(width: fileExplorerWidth)
                    .background(FlowPalette.Semantic.surface(colorScheme))
                    .overlay(
                        HStack {
                            Spacer()
                            FlowPalette.Border.subtle(colorScheme).frame(width: 1)
                        }
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
    }
    
    private var iconRail: some View {
        VStack(spacing: 0) {
            // User button
            GlowingIconButton(
                icon: "person.circle.fill",
                color: FlowPalette.Base.primary,
                isActive: false
            ) {}
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Divider()
                .frame(width: 32)
                .padding(.bottom, 8)
            
            // Navigation items
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 6) {
                    IconRailButton(icon: "square.grid.2x2", isActive: true) {}
                    IconRailButton(icon: "folder.fill", isActive: false) {}
                    IconRailButton(icon: "magnifyingglass", isActive: false) {}
                    IconRailButton(icon: "arrow.triangle.branch", isActive: false) {}
                    IconRailButton(icon: "cpu.fill", isActive: false) {}
                }
            }
            
            Spacer()
            
            // Footer
            VStack(spacing: 6) {
                Divider().frame(width: 32)
                
                // Terminal toggle - opens input panel
                IconRailButton(
                    icon: "terminal.fill",
                    isActive: workspaceManager.isInputPanelVisible,
                    accentColor: FlowPalette.Category.terminal
                ) {
                    withAnimation(FlowMotion.bottomPanel) {
                        workspaceManager.isInputPanelVisible.toggle()
                    }
                }
            }
            .padding(.bottom, 12)
        }
        .frame(width: iconRailWidth)
        .background(iconRailBackground)
    }
    
    private var iconRailBackground: some View {
        ZStack {
            FlowPalette.Semantic.surface(colorScheme).opacity(0.5)
            
            HStack {
                Spacer()
                FlowPalette.Border.subtle(colorScheme).frame(width: 1)
            }
        }
    }
    
    // MARK: - Editor Area
    
    private func editorArea(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Tab bar
            EditorTabBar(workspaceManager: workspaceManager)
            
            // Editor content
            if let activeTab = workspaceManager.openTabs.first(where: { $0.id == workspaceManager.activeTabId }) {
                CodeEditorView(tab: activeTab)
            } else {
                CodeEditorView(tab: nil)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Chat Panel Overlay (separate from input panel)
    
    private func chatPanelOverlay(geometry: GeometryProxy) -> some View {
        // Chat panel height - leave space for input panel if visible
        let inputPanelSpace = workspaceManager.isInputPanelVisible ? (workspaceManager.inputPanelHeight + panelInset) : 0
        let panelHeight = geometry.size.height - toolbarHeight - bottomBarHeight - panelInset * 2 - inputPanelSpace
        
        return HStack {
            Spacer()
            
            VStack {
                ChatPanel(workspaceManager: workspaceManager)
                    .frame(width: chatPanelWidth, height: panelHeight)
                
                Spacer()
            }
            .padding(.top, toolbarHeight + panelInset)
            .padding(.trailing, panelInset)
            .padding(.bottom, bottomBarHeight + panelInset + inputPanelSpace)
        }
        .transition(.slideFromRight)
    }
    
    // MARK: - Input Panel Overlay (separate from chat, never touches)
    
    private func inputPanelOverlay(geometry: GeometryProxy) -> some View {
        // Input panel sits at bottom right, under chat if chat is open
        // Never touches chat - maintains gap
        let panelWidth = workspaceManager.isChatOpen ? chatPanelWidth : chatPanelWidth
        
        return VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                InputPanel(workspaceManager: workspaceManager, isInputFocused: false)
                    .frame(width: panelWidth, height: workspaceManager.inputPanelHeight)
                
                Spacer().frame(width: panelInset)
            }
        }
        .padding(.bottom, bottomBarHeight + panelInset)
        .transition(.slideFromBottom)
    }
    
    // MARK: - Bottom Panel Overlay
    
    private func bottomPanelOverlay(geometry: GeometryProxy) -> some View {
        let leftOffset = iconRailWidth + (workspaceManager.isLeftSidebarOpen ? fileExplorerWidth : 0)
        let rightOffset = workspaceManager.isChatOpen ? chatPanelWidth + panelInset * 2 : 0
        let panelWidth = geometry.size.width - leftOffset - rightOffset - panelInset * 2
        
        return VStack {
            Spacer()
            
            HStack {
                Spacer().frame(width: leftOffset + panelInset)
                
                BottomPanelContent(
                    workspaceManager: workspaceManager,
                    selectedTab: workspaceManager.selectedBottomTab
                )
                .frame(width: panelWidth, height: workspaceManager.bottomPanelHeight)
                .background(FlowPalette.Semantic.floating(colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(FlowPalette.Border.medium(colorScheme), lineWidth: 1)
                )
                .floatingShadow(colorScheme)
                
                Spacer()
            }
        }
        .padding(.bottom, bottomBarHeight + panelInset)
        .transition(.bottomBarExpand)
    }
}


// MARK: - Supporting Components

struct TrafficLightButtons: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(Color.red.opacity(0.8)).frame(width: 12, height: 12)
            Circle().fill(Color.yellow.opacity(0.8)).frame(width: 12, height: 12)
            Circle().fill(Color.green.opacity(0.8)).frame(width: 12, height: 12)
        }
    }
}

struct ToolbarButton: View {
    let icon: String
    let enabled: Bool
    var isActive: Bool = false
    var accentColor: Color = .blue
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(
                    isActive ? accentColor :
                    enabled ? FlowPalette.Text.secondary(colorScheme) :
                    FlowPalette.Text.disabled(colorScheme)
                )
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            isActive ? accentColor.opacity(0.15) :
                            isHovered ? FlowPalette.Border.subtle(colorScheme) :
                            Color.clear
                        )
                )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .onHover { isHovered = $0 }
    }
}

struct SearchFieldCompact: View {
    @State private var searchText = ""
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 12))
                .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
            
            Text("⌘K")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(FlowPalette.Border.subtle(colorScheme))
                )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(FlowPalette.Semantic.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(FlowPalette.Border.subtle(colorScheme), lineWidth: 1)
                )
        )
    }
}

struct GlowingIconButton: View {
    let icon: String
    let color: Color
    let isActive: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Glow
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 36, height: 36)
                    .blur(radius: 4)
                
                // Icon
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(FlowMotion.hover, value: isHovered)
        .onHover { isHovered = $0 }
    }
}

struct IconRailButton: View {
    let icon: String
    let isActive: Bool
    var accentColor: Color = .blue
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(
                    isActive ? accentColor : FlowPalette.Text.secondary(colorScheme)
                )
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            isActive ? accentColor.opacity(0.15) :
                            isHovered ? FlowPalette.Border.subtle(colorScheme) :
                            Color.clear
                        )
                )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Bottom Panel Content

struct BottomPanelContent: View {
    @ObservedObject var workspaceManager: WorkspaceManager
    let selectedTab: BottomBarTab
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: selectedTab.icon)
                        .font(.system(size: 12))
                        .foregroundStyle(selectedTab.accentColor)
                    
                    Text(selectedTab.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(FlowPalette.Text.primary(colorScheme))
                }
                
                Spacer()
                
                // Close button
                Button(action: {
                    withAnimation(FlowMotion.bottomPanel) {
                        workspaceManager.isBottomBarExpanded = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(FlowPalette.Border.subtle(colorScheme)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                VStack {
                    Spacer()
                    FlowPalette.Border.subtle(colorScheme).frame(height: 1)
                }
            )
            
            // Content
            panelContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    private var panelContent: some View {
        switch selectedTab {
        case .terminal:
            TerminalPanelContent()
        case .problems:
            ProblemsPanelContent()
        case .output:
            OutputPanelContent()
        case .debug:
            DebugPanelContent()
        case .console:
            ConsolePanelContent()
        case .search:
            SearchPanelContent()
        }
    }
}

// MARK: - Panel Content Views

struct TerminalPanelContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var commandHistory: [String] = [
        "$ swift build",
        "Building for debugging...",
        "Build complete! (2.3s)"
    ]
    @State private var currentCommand = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(commandHistory.indices, id: \.self) { index in
                        Text(commandHistory[index])
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(
                                commandHistory[index].hasPrefix("$")
                                    ? FlowPalette.Category.terminal
                                    : FlowPalette.Text.secondary(colorScheme)
                            )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            }
            .background(Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05))
            
            // Input
            HStack(spacing: 8) {
                Text("$")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(FlowPalette.Category.terminal)
                
                TextField("Enter command...", text: $currentCommand)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, design: .monospaced))
            }
            .padding(12)
            .background(FlowPalette.Border.subtle(colorScheme).opacity(0.5))
        }
    }
}

struct ProblemsPanelContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                WorkspaceProblemRow(severity: .warning, message: "Unused variable 'temp'", file: "ViewModel.swift", line: 42)
                WorkspaceProblemRow(severity: .error, message: "Type mismatch", file: "Service.swift", line: 128)
            }
            .padding(12)
        }
    }
}

struct WorkspaceProblemRow: View {
    enum Severity { case warning, error }
    let severity: Severity
    let message: String
    let file: String
    let line: Int
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: severity == .error ? "xmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(severity == .error ? FlowPalette.Status.error : FlowPalette.Status.warning)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(message)
                    .font(.system(size: 12))
                    .foregroundStyle(FlowPalette.Text.primary(colorScheme))
                
                Text("\(file):\(line)")
                    .font(.system(size: 10))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
            }
            
            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(FlowPalette.Semantic.surface(colorScheme))
        )
    }
}

struct OutputPanelContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            Text("[INFO] Build started...\n[INFO] Compiling 42 files...\n[SUCCESS] Build complete!")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
        }
    }
}

struct DebugPanelContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            Text("No active debug session")
                .font(.system(size: 13))
                .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ConsolePanelContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            Text("Console output will appear here...")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
        }
    }
}

struct SearchPanelContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchQuery = ""
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                
                TextField("Search in files...", text: $searchQuery)
                    .textFieldStyle(.plain)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(FlowPalette.Semantic.surface(colorScheme))
            )
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            if searchQuery.isEmpty {
                Spacer()
                Text("Enter a search term")
                    .font(.system(size: 13))
                    .foregroundStyle(FlowPalette.Text.tertiary(colorScheme))
                Spacer()
            } else {
                ScrollView {
                    Text("Search results for '\(searchQuery)'...")
                        .font(.system(size: 12))
                        .foregroundStyle(FlowPalette.Text.secondary(colorScheme))
                        .padding(12)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Workspace Layout - Dark") {
    WorkspaceLayout()
        .preferredColorScheme(.dark)
        .frame(width: 1400, height: 900)
}

#Preview("Workspace Layout - Light") {
    WorkspaceLayout()
        .preferredColorScheme(.light)
        .frame(width: 1400, height: 900)
}
