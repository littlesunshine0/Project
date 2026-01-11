//
//  DoubleSidebarLayoutV2.swift
//  FlowKit
//
//  Professional layered layout with floating panel system
//  
//  Architecture:
//  - Left: Icon Rail (with footer actions) → Category Panel
//  - Center: Context Area (Dashboard adapts to panel sizes)
//  - Right: Floating Chat Panel (half or full height)
//  - Bottom: Floating Input Panel (terminal, output, etc.)
//
//  Key Features:
//  - Chat starts closed, opens half-way, can expand to full
//  - Terminal toggle in icon rail footer
//  - Floating panels don't touch window edges or each other
//  - Dashboard adapts when panels open (not obstructed)
//  - All floating panels have dashboard widget styling
//

import SwiftUI
import Combine
import DesignKit
import NavigationKit
import DataKit

struct DoubleSidebarLayoutV2: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    // Managers
    @StateObject private var navigationCoordinator = NavigationCoordinator.shared
    @StateObject private var rightSidebarManager = RightSidebarManager.shared
    @StateObject private var inputPanelManager = InputPanelManager.shared
    
    // Navigation state
    @State private var selectedPrimary: PrimaryNavItem = .dashboard
    @State private var selectedSecondary: String? = nil
    @State private var isSecondaryCollapsed: Bool = false
    @State private var expandedCategories: Set<String> = []
    @State private var hoveredPrimary: PrimaryNavItem? = nil
    @State private var hoveredSecondary: String? = nil
    @State private var searchText: String = ""
    
    // Layout constants
    private let iconRailWidth: CGFloat = 64
    private let categoryCollapsedWidth: CGFloat = 56
    private let categoryExpandedWidth: CGFloat = 240
    private let floatingPanelInset: CGFloat = 12
    private let chatHalfWidth: CGFloat = 380
    private let chatFullWidth: CGFloat = 480
    private let panelCornerRadius: CGFloat = 16
    
    // Bottom bar height constant
    private let bottomBarHeight: CGFloat = 28
    
    var body: some View {
        GeometryReader { geometry in
            let contentWidth = calculateContentWidth(totalWidth: geometry.size.width)
            
            ZStack {
                // Base canvas
                FlowColors.Semantic.canvas(colorScheme)
                    .ignoresSafeArea(.all)
                
                // Main layout layer
                VStack(spacing: 0) {
                    // Toolbar (title bar) - spans full width
                    globalToolbar
                    
                    // Main content row - sidebars extend full height
                    HStack(spacing: 0) {
                        // Left: Icon Rail + Category Panel (full height below toolbar)
                        iconRailPanel
                        categoryPanel
                        
                        // Center: Content area
                        contextArea
                            .frame(width: contentWidth)
                        
                        // Spacer for right panel area (chat + input panel below)
                        if rightSidebarManager.isVisible || inputPanelManager.isVisible {
                            Color.clear.frame(width: rightPanelAreaWidth + floatingPanelInset * 2)
                        }
                    }
                    
                    // Full-width bottom bar with panel toggles
                    workspaceBottomBar
                }
                
                // Floating panels layer - chat and input panel on right side
                floatingPanelsOverlay(geometry: geometry)
            }
        }
        .ignoresSafeArea(.all)
        .animation(reduceMotion ? .none : FlowMotion.standard, value: isSecondaryCollapsed)
        .animation(reduceMotion ? .none : FlowMotion.standard, value: rightSidebarManager.mode)
        .animation(reduceMotion ? .none : FlowMotion.standard, value: inputPanelManager.isVisible)
        .animation(reduceMotion ? .none : FlowMotion.standard, value: inputPanelManager.widthMode)
        .setupNotificationHandlers(
            selectedPrimary: $selectedPrimary,
            rightSidebarManager: rightSidebarManager,
            inputPanelManager: inputPanelManager
        )
        .setupNavigationSync(
            selectedPrimary: $selectedPrimary,
            selectedSecondary: $selectedSecondary,
            navigationCoordinator: navigationCoordinator
        )
    }
    
    // MARK: - Layout Calculations
    
    private var chatPanelWidth: CGFloat {
        switch rightSidebarManager.mode {
        case .minimized: return 0
        case .single, .split, .triple: return chatHalfWidth
        case .fullFloating, .fullChat: return chatFullWidth
        }
    }
    
    /// Width of the right panel area (chat sidebar width or extended input panel width)
    private var rightPanelAreaWidth: CGFloat {
        if inputPanelManager.isVisible && inputPanelManager.isWidthExtended {
            // When extended, panel takes more space but we still reserve chat width for the right column
            return chatHalfWidth
        }
        return rightSidebarManager.isVisible ? chatPanelWidth : chatHalfWidth
    }
    
    /// Input panel width - either matches chat or extends across
    private func inputPanelWidth(totalWidth: CGFloat) -> CGFloat {
        let leftPanelsWidth = iconRailWidth + (isSecondaryCollapsed ? categoryCollapsedWidth : categoryExpandedWidth)
        
        if inputPanelManager.isWidthExtended {
            // Extended: from left sidebar edge to right edge (with insets)
            // But leave space for chat column on the right
            return totalWidth - leftPanelsWidth - chatHalfWidth - floatingPanelInset * 3
        } else {
            // Match chat width
            return chatHalfWidth
        }
    }
    
    private func calculateContentWidth(totalWidth: CGFloat) -> CGFloat {
        let leftPanelsWidth = iconRailWidth + (isSecondaryCollapsed ? categoryCollapsedWidth : categoryExpandedWidth)
        var width = totalWidth - leftPanelsWidth
        
        // Reserve space for right panel area
        if rightSidebarManager.isVisible || inputPanelManager.isVisible {
            width -= (chatHalfWidth + floatingPanelInset * 2)
        }
        
        return max(width, 400)
    }
    
    /// Check if we should use split layout (input extended + chat visible)
    private var shouldUseSplitLayout: Bool {
        inputPanelManager.isVisible && inputPanelManager.isWidthExtended && rightSidebarManager.isVisible
    }
    
    // MARK: - Floating Panels Overlay
    
    /// Height of the unified bottom panel
    private var unifiedBottomPanelHeight: CGFloat {
        inputPanelManager.isExpanded ? 350 : 200
    }
    
    /// Whether the unified bottom panel should be visible
    private var isUnifiedBottomPanelVisible: Bool {
        inputPanelManager.isVisible
    }
    
    /// Toolbar height (title bar)
    private let toolbarHeight: CGFloat = 52
    
    @ViewBuilder
    private func floatingPanelsOverlay(geometry: GeometryProxy) -> some View {
        // Right floating chat panel (messages only)
        if rightSidebarManager.isVisible {
            floatingChatPanel(geometry: geometry)
        }
        
        // Unified bottom panel - contains ALL bottom content (Terminal, Chat Input, Problems, Output, Debug)
        // Positioned below the chat panel, controlled by bottom bar toggles
        if isUnifiedBottomPanelVisible {
            unifiedBottomPanel(geometry: geometry)
        }
        
        // Minimized chat button (only when chat is hidden)
        if !rightSidebarManager.isVisible {
            minimizedChatButton
        }
    }
    
    private func floatingChatPanel(geometry: GeometryProxy) -> some View {
        // Chat panel floats on right side
        // Top: below toolbar with proper inset (not overlapping toolbar/breadcrumbs)
        let topInset = toolbarHeight + floatingPanelInset
        
        // Bottom: leave space for unified bottom panel when visible, otherwise just bottom bar
        let bottomSpace: CGFloat = {
            let barSpace = bottomBarHeight + floatingPanelInset
            if isUnifiedBottomPanelVisible {
                // Leave space for unified bottom panel + gap + bottom bar
                return unifiedBottomPanelHeight + floatingPanelInset * 2 + bottomBarHeight
            }
            return barSpace
        }()
        let totalPanelHeight = geometry.size.height - topInset - bottomSpace
        
        // Determine panel width
        let panelWidth: CGFloat = chatPanelWidth
        
        // When input is extended, force split mode with current content on top, chat on bottom
        // Note: Notifications is independent - don't force it to pair with chat
        let effectiveMode: RightSidebarMode = {
            if shouldUseSplitLayout {
                switch rightSidebarManager.mode {
                case .single(.chat):
                    // Just chat - keep it single, no need to force notifications
                    return .single(.chat)
                case .single(let content):
                    // Other content - split with chat on bottom
                    return .split(top: content, bottom: .chat)
                case .split(_, let bottom) where bottom == .chat:
                    // Already has chat on bottom - keep as is
                    return rightSidebarManager.mode
                case .split(let top, _):
                    // Has something else on bottom - put chat there
                    return .split(top: top, bottom: .chat)
                default:
                    return rightSidebarManager.mode
                }
            }
            return rightSidebarManager.mode
        }()
        
        return HStack {
            Spacer()
            VStack(spacing: 0) {
                RightSidebarView(
                    sidebarManager: rightSidebarManager,
                    inputPanelManager: inputPanelManager,
                    forcedMode: shouldUseSplitLayout ? effectiveMode : nil
                )
                .frame(width: panelWidth, height: totalPanelHeight)
                .background(floatingPanelBackground)
                .clipShape(RoundedRectangle(cornerRadius: panelCornerRadius, style: .continuous))
                .overlay(floatingPanelBorder)
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 20, x: -4, y: 4)
                
                Spacer()
            }
            .padding(.top, topInset)
            .padding(.trailing, floatingPanelInset)
        }
        .transition(.move(edge: .trailing).combined(with: .opacity))
    }
    
    // MARK: - Unified Bottom Panel (Terminal, Chat Input, Problems, Output, Debug)
    
    private func unifiedBottomPanel(geometry: GeometryProxy) -> some View {
        // Unified bottom panel sits below the chat panel
        // Width: matches chat width by default, or extends to left sidebar when expanded
        let panelWidth = inputPanelWidth(totalWidth: geometry.size.width)
        let leftPanelsWidth = iconRailWidth + (isSecondaryCollapsed ? categoryCollapsedWidth : categoryExpandedWidth)
        
        return VStack {
            Spacer()
            HStack(spacing: 0) {
                if inputPanelManager.isWidthExtended {
                    // Extended mode: position after left sidebar with gap
                    Spacer().frame(width: leftPanelsWidth + floatingPanelInset)
                    
                    UnifiedBottomPanelView(panelManager: inputPanelManager)
                        .frame(width: panelWidth, height: unifiedBottomPanelHeight)
                        .background(unifiedPanelBackground)
                        .clipShape(RoundedRectangle(cornerRadius: panelCornerRadius, style: .continuous))
                        .overlay(unifiedPanelBorder)
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 20, x: 0, y: -4)
                    
                    // Gap between panel and chat column
                    Spacer().frame(width: floatingPanelInset)
                    
                    // Reserve space for chat column
                    Spacer().frame(width: chatHalfWidth + floatingPanelInset)
                } else {
                    // Default mode: align with right edge (under chat)
                    Spacer()
                    
                    UnifiedBottomPanelView(panelManager: inputPanelManager)
                        .frame(width: panelWidth, height: unifiedBottomPanelHeight)
                        .background(unifiedPanelBackground)
                        .clipShape(RoundedRectangle(cornerRadius: panelCornerRadius, style: .continuous))
                        .overlay(unifiedPanelBorder)
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 20, x: 0, y: -4)
                    
                    Spacer().frame(width: floatingPanelInset)
                }
            }
        }
        .padding(.bottom, floatingPanelInset + bottomBarHeight)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var unifiedPanelBackground: some View {
        ZStack {
            FlowColors.Semantic.floating(colorScheme)
            
            // Subtle accent tint based on selected tab
            LinearGradient(
                colors: [
                    inputPanelManager.selectedTab.accentColor.opacity(colorScheme == .dark ? 0.04 : 0.02),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    private var unifiedPanelBorder: some View {
        RoundedRectangle(cornerRadius: panelCornerRadius, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: [
                        inputPanelManager.selectedTab.accentColor.opacity(0.4),
                        FlowColors.Border.medium(colorScheme)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 1
            )
    }
    
    private var floatingPanelBackground: some View {
        FlowColors.Semantic.floating(colorScheme)
    }
    
    private var floatingPanelBorder: some View {
        RoundedRectangle(cornerRadius: panelCornerRadius, style: .continuous)
            .strokeBorder(FlowColors.Border.medium(colorScheme), lineWidth: 1)
    }
    
    // MARK: - Minimized Chat Button
    
    private var minimizedChatButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(FlowMotion.standard) {
                        rightSidebarManager.showChat()
                    }
                }) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(SidebarContentType.chat.accentColor.opacity(0.2))
                                .frame(width: 32, height: 32)
                                .blur(radius: 4)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [SidebarContentType.chat.accentColor, SidebarContentType.chat.accentColor.opacity(0.7)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                        Text("Chat")
                            .font(FlowTypography.body(.medium))
                            .foregroundStyle(FlowColors.Text.primary(colorScheme))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: panelCornerRadius, style: .continuous)
                            .fill(FlowColors.Semantic.floating(colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: panelCornerRadius, style: .continuous)
                            .strokeBorder(FlowColors.Border.medium(colorScheme), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 16, x: 0, y: 4)
                }
                .buttonStyle(.plain)
                .padding(.trailing, floatingPanelInset)
                // Position above bottom bar (and bottom panel if visible)
                .padding(.bottom, bottomBarHeight + floatingPanelInset + (inputPanelManager.isVisible ? inputPanelManager.panelHeight + floatingPanelInset : 0))
            }
        }
    }
}


// MARK: - Global Toolbar (Title Bar)

extension DoubleSidebarLayoutV2 {
    private var globalToolbar: some View {
        HStack(spacing: 0) {
            // Traffic lights area
            HStack(spacing: 8) {
                CustomWindowControls()
            }
            .frame(width: iconRailWidth)
            .padding(.leading, 14)
            
            // Navigation buttons
            HStack(spacing: 4) {
                ToolbarNavButton(icon: "chevron.left", enabled: false) {}
                ToolbarNavButton(icon: "chevron.right", enabled: false) {}
            }
            .padding(.leading, 8)
            
            // Sidebar toggle
            ToolbarToggle(icon: "sidebar.left", isActive: !isSecondaryCollapsed, tooltip: "Toggle Sidebar") {
                withAnimation { isSecondaryCollapsed.toggle() }
            }
            .padding(.leading, 8)
            
            Spacer()
            
            // Center: Search field
            SearchField(text: $searchText)
                .frame(width: 320)
            
            Spacer()
            
            // Right side controls - Notifications and Settings only
            HStack(spacing: 6) {
                // Notifications toggle - opens notification panel in right sidebar
                ToolbarToggle(
                    icon: "bell.fill",
                    isActive: rightSidebarManager.isShowingNotifications,
                    tooltip: "Notifications"
                ) {
                    withAnimation(FlowMotion.standard) {
                        rightSidebarManager.toggleNotifications()
                    }
                }
                
                // Settings
                ToolbarNavButton(icon: "gearshape.fill", enabled: true) {
                    selectedPrimary = .settings
                }
            }
            .padding(.trailing, 16)
        }
        .frame(height: 52)
        .background(toolbarBackground)
    }
    
    private var toolbarBackground: some View {
        ZStack {
            FlowColors.Semantic.elevated(colorScheme)
            
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color.white.opacity(colorScheme == .dark ? 0.04 : 0.6), .clear],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 1)
                Spacer()
            }
            
            VStack {
                Spacer()
                FlowColors.Border.subtle(colorScheme).frame(height: 1)
            }
        }
    }
}

// MARK: - Workspace Bottom Bar (Full Width)

extension DoubleSidebarLayoutV2 {
    private var workspaceBottomBar: some View {
        HStack(spacing: 0) {
            // Left side: Panel toggles
            HStack(spacing: 2) {
                // Terminal
                BottomBarPanelToggle(
                    icon: "terminal.fill",
                    label: "Terminal",
                    isActive: inputPanelManager.isVisible && inputPanelManager.selectedTab == .terminal,
                    color: InputPanelTab.terminal.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        if inputPanelManager.isVisible && inputPanelManager.selectedTab == .terminal {
                            inputPanelManager.hide()
                        } else {
                            inputPanelManager.show(tab: .terminal)
                        }
                    }
                }
                
                // Problems
                BottomBarPanelToggle(
                    icon: "exclamationmark.triangle.fill",
                    label: "Problems",
                    isActive: inputPanelManager.isVisible && inputPanelManager.selectedTab == .problems,
                    color: InputPanelTab.problems.accentColor,
                    badge: 3
                ) {
                    withAnimation(FlowMotion.standard) {
                        if inputPanelManager.isVisible && inputPanelManager.selectedTab == .problems {
                            inputPanelManager.hide()
                        } else {
                            inputPanelManager.show(tab: .problems)
                        }
                    }
                }
                
                // Output
                BottomBarPanelToggle(
                    icon: "doc.text.fill",
                    label: "Output",
                    isActive: inputPanelManager.isVisible && inputPanelManager.selectedTab == .output,
                    color: InputPanelTab.output.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        if inputPanelManager.isVisible && inputPanelManager.selectedTab == .output {
                            inputPanelManager.hide()
                        } else {
                            inputPanelManager.show(tab: .output)
                        }
                    }
                }
                
                // Debug
                BottomBarPanelToggle(
                    icon: "ant.fill",
                    label: "Debug",
                    isActive: inputPanelManager.isVisible && inputPanelManager.selectedTab == .debug,
                    color: InputPanelTab.debug.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        if inputPanelManager.isVisible && inputPanelManager.selectedTab == .debug {
                            inputPanelManager.hide()
                        } else {
                            inputPanelManager.show(tab: .debug)
                        }
                    }
                }
                
                Divider()
                    .frame(height: 14)
                    .padding(.horizontal, 6)
                
                // Chat toggle
                BottomBarPanelToggle(
                    icon: "bubble.left.and.bubble.right.fill",
                    label: "Chat",
                    isActive: rightSidebarManager.isVisible && rightSidebarManager.mode.isShowing(.chat),
                    color: SidebarContentType.chat.accentColor
                ) {
                    withAnimation(FlowMotion.standard) {
                        if rightSidebarManager.isVisible && rightSidebarManager.mode.isShowing(.chat) {
                            rightSidebarManager.minimize()
                        } else {
                            rightSidebarManager.showChat()
                        }
                    }
                }
            }
            .padding(.leading, 12)
            
            Spacer()
            
            // Center: Status indicators
            HStack(spacing: 16) {
                BottomBarStatusIndicator(icon: "checkmark.circle.fill", text: "Ready", color: FlowColors.Status.success)
                BottomBarStatusIndicator(icon: "arrow.triangle.branch", text: "main", color: FlowColors.Category.agents)
            }
            
            Spacer()
            
            // Right side: Editor info
            HStack(spacing: 8) {
                Text("Ln 42, Col 18")
                    .font(.system(size: 11))
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                
                Divider().frame(height: 12)
                
                Text("UTF-8")
                    .font(.system(size: 11))
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                
                Divider().frame(height: 12)
                
                Text("Swift")
                    .font(.system(size: 11))
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            .padding(.trailing, 12)
        }
        .frame(height: bottomBarHeight)
        .background(bottomBarBackground)
    }
    
    private var bottomBarBackground: some View {
        ZStack {
            FlowColors.Semantic.elevated(colorScheme)
            
            VStack {
                FlowColors.Border.subtle(colorScheme).frame(height: 1)
                Spacer()
            }
        }
    }
}

// MARK: - Bottom Bar Panel Toggle

struct BottomBarPanelToggle: View {
    let icon: String
    let label: String
    let isActive: Bool
    let color: Color
    var badge: Int? = nil
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                
                Text(label)
                    .font(.system(size: 11, weight: isActive ? .medium : .regular))
                
                if let badge = badge, badge > 0 {
                    Text("\(badge)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(Capsule().fill(color))
                }
            }
            .foregroundStyle(isActive ? color : FlowColors.Text.secondary(colorScheme))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isActive ? color.opacity(0.15) : (isHovered ? FlowColors.Border.subtle(colorScheme) : .clear))
            )
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}

// MARK: - Bottom Bar Status Indicator

struct BottomBarStatusIndicator: View {
    let icon: String
    let text: String
    let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundStyle(color)
            
            Text(text)
                .font(.system(size: 11))
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
        }
    }
}

// MARK: - Floating Chat Input (separate panel below chat)

struct FloatingChatInput: View {
    @ObservedObject var inputPanelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var inputText: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(SidebarContentType.chat.accentColor.opacity(0.15))
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "text.bubble.fill")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(SidebarContentType.chat.accentColor)
                }
                
                Text("Message")
                    .font(FlowTypography.caption(.medium))
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                
                Spacer()
                
                // Attachment button
                Button(action: {}) {
                    Image(systemName: "paperclip")
                        .font(.system(size: 12))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                VStack {
                    Spacer()
                    SidebarContentType.chat.accentColor.opacity(0.15).frame(height: 1)
                }
            )
            
            // Input area
            HStack(alignment: .bottom, spacing: 10) {
                TextEditor(text: $inputText)
                    .font(FlowTypography.body())
                    .scrollContentBackground(.hidden)
                    .focused($isInputFocused)
                    .frame(minHeight: 36)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: FlowRadius.md)
                            .fill(FlowColors.Semantic.surface(colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: FlowRadius.md)
                            .strokeBorder(
                                isInputFocused ? SidebarContentType.chat.accentColor.opacity(0.5) : FlowColors.Border.subtle(colorScheme),
                                lineWidth: 1
                            )
                    )
                
                // Send button
                Button(action: sendMessage) {
                    ZStack {
                        Circle()
                            .fill(inputText.isEmpty ? FlowColors.Border.subtle(colorScheme) : SidebarContentType.chat.accentColor)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(inputText.isEmpty ? FlowColors.Text.tertiary(colorScheme) : .white)
                    }
                }
                .buttonStyle(.plain)
                .disabled(inputText.isEmpty)
            }
            .padding(12)
        }
    }
    
    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        
        // Post notification with message
        NotificationCenter.default.post(
            name: .chatMessageSent,
            object: nil,
            userInfo: ["message": inputText]
        )
        
        inputText = ""
    }
}

// MARK: - Icon Rail Panel

extension DoubleSidebarLayoutV2 {
    private var iconRailPanel: some View {
        VStack(spacing: 0) {
            // User account with glow effect at top
            GlowingUserButton {
                selectedPrimary = .settings
            }
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Capsule()
                .fill(FlowColors.Border.subtle(colorScheme))
                .frame(width: 32, height: 2)
                .padding(.bottom, 8)
            
            // Main navigation items
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(PrimaryNavItem.allCases) { item in
                        IconRailItem(
                            item: item,
                            isSelected: selectedPrimary == item,
                            isHovered: hoveredPrimary == item
                        )
                        .onTapGesture {
                            withAnimation(FlowMotion.quick) {
                                selectedPrimary = item
                                selectedSecondary = nil
                            }
                        }
                        .onHover { hoveredPrimary = $0 ? item : nil }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Spacer()
        }
        .frame(width: iconRailWidth)
        .background(iconRailBackground)
    }
    
    private var iconRailBackground: some View {
        ZStack {
            FlowColors.Semantic.canvas(colorScheme)
            
            HStack {
                LinearGradient(
                    colors: [Color.black.opacity(colorScheme == .dark ? 0.3 : 0.05), .clear],
                    startPoint: .leading, endPoint: .trailing
                )
                .frame(width: 4)
                Spacer()
            }
            
            HStack {
                Spacer()
                FlowColors.Border.subtle(colorScheme).frame(width: 1)
            }
        }
    }
}
// MARK: - Category Panel

extension DoubleSidebarLayoutV2 {
    private var categoryPanel: some View {
        VStack(spacing: 0) {
            categoryHeader
            
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(categoriesForPrimary(selectedPrimary)) { category in
                        CategoryRow(
                            category: category,
                            isCollapsed: isSecondaryCollapsed,
                            isSelected: selectedSecondary == category.id,
                            isExpanded: expandedCategories.contains(category.id),
                            isHovered: hoveredSecondary == category.id,
                            onTap: { handleCategoryTap(category) },
                            onToggle: { toggleCategory(category) }
                        )
                        .onHover { hoveredSecondary = $0 ? category.id : nil }
                        
                        if !isSecondaryCollapsed && expandedCategories.contains(category.id) {
                            ForEach(category.children) { child in
                                CategoryRow(
                                    category: child,
                                    isCollapsed: false,
                                    isSelected: selectedSecondary == child.id,
                                    isExpanded: false,
                                    isHovered: hoveredSecondary == child.id,
                                    isChild: true,
                                    onTap: { selectedSecondary = child.id },
                                    onToggle: {}
                                )
                                .onHover { hoveredSecondary = $0 ? child.id : nil }
                            }
                        }
                    }
                }
                .padding(.horizontal, isSecondaryCollapsed ? 8 : 12)
                .padding(.vertical, 12)
            }
        }
        .frame(width: isSecondaryCollapsed ? categoryCollapsedWidth : categoryExpandedWidth)
        .background(categoryBackground)
    }
    
    private var categoryHeader: some View {
        HStack {
            if !isSecondaryCollapsed {
                HStack(spacing: 8) {
                    Circle()
                        .fill(selectedPrimary.color)
                        .frame(width: 8, height: 8)
                    
                    Text(selectedPrimary.title.uppercased())
                        .font(FlowTypography.micro(.bold))
                        .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                        .tracking(1)
                }
                
                Spacer()
            }
            
            Button(action: { withAnimation { isSecondaryCollapsed.toggle() } }) {
                Image(systemName: isSecondaryCollapsed ? "chevron.right" : "chevron.left")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            VStack { Spacer(); FlowColors.Border.subtle(colorScheme).frame(height: 1) }
        )
    }
    
    private var categoryBackground: some View {
        ZStack {
            FlowColors.Semantic.surface(colorScheme)
            
            HStack {
                LinearGradient(
                    colors: [Color.black.opacity(colorScheme == .dark ? 0.15 : 0.03), .clear],
                    startPoint: .leading, endPoint: .trailing
                )
                .frame(width: 6)
                Spacer()
            }
            
            HStack {
                Spacer()
                FlowColors.Border.medium(colorScheme).frame(width: 1)
            }
        }
    }
    
    private func handleCategoryTap(_ category: SecondaryCategory) {
        withAnimation(FlowMotion.quick) {
            if category.children.isEmpty {
                selectedSecondary = category.id
            } else {
                toggleCategory(category)
            }
        }
    }
    
    private func toggleCategory(_ category: SecondaryCategory) {
        withAnimation(FlowMotion.quick) {
            if expandedCategories.contains(category.id) {
                expandedCategories.remove(category.id)
            } else {
                expandedCategories.insert(category.id)
            }
        }
    }
}


// MARK: - Context Area

extension DoubleSidebarLayoutV2 {
    private var contextArea: some View {
        VStack(spacing: 0) {
            contextHeader
            
            contextContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(FlowColors.Semantic.canvas(colorScheme))
    }
    
    private var contextHeader: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: selectedPrimary.icon)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(selectedPrimary.color)
                
                Text(contextTitle)
                    .font(FlowTypography.headline())
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                if let subtitle = contextSubtitle {
                    Text("›")
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                    Text(subtitle)
                        .font(FlowTypography.body())
                        .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                }
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                ContextButton(icon: "arrow.clockwise") {}
                ContextButton(icon: "ellipsis") {}
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            ZStack {
                FlowColors.Semantic.surface(colorScheme).opacity(0.6)
                VStack { Spacer(); FlowColors.Border.subtle(colorScheme).frame(height: 1) }
            }
        )
    }
    
    @ViewBuilder
    private var contextContent: some View {
        switch selectedPrimary {
        case .dashboard:
            DashboardView(selectedSection: selectedSecondary)
        case .aiAssistant:
            PlaceholderContentView(title: "AI Assistant", icon: "brain.head.profile", color: .purple)
        case .inventory:
            PlaceholderContentView(title: "Inventory", icon: "shippingbox.fill", color: .orange)
        case .workflows:
            PlaceholderContentView(title: "Workflows", icon: "arrow.triangle.branch", color: FlowColors.Category.workflows)
        case .agents:
            PlaceholderContentView(title: "Agents", icon: "cpu.fill", color: FlowColors.Category.agents)
        case .projects:
            PlaceholderContentView(title: "Projects", icon: "folder.fill", color: FlowColors.Category.projects)
        case .commands:
            PlaceholderContentView(title: "Commands", icon: "terminal.fill", color: FlowColors.Category.commands)
        case .documentation:
            PlaceholderContentView(title: "Documentation", icon: "doc.text.fill", color: FlowColors.Category.documentation)
        case .files:
            PlaceholderContentView(title: "Files", icon: "externaldrive.fill", color: .blue)
        case .mlTemplates:
            PlaceholderContentView(title: "ML Templates", icon: "wand.and.stars", color: .purple)
        case .mlArchitect:
            PlaceholderContentView(title: "ML Architect", icon: "cube.transparent", color: .cyan)
        case .settings:
            PlaceholderContentView(title: "Settings", icon: "gearshape.fill", color: .gray)
        case .search:
            PlaceholderContentView(title: "Search", icon: "magnifyingglass", color: .blue)
        case .indexedDocs:
            PlaceholderContentView(title: "Indexed Documents", icon: "doc.text.magnifyingglass", color: .green)
        case .indexedCode:
            PlaceholderContentView(title: "Indexed Code", icon: "chevron.left.forwardslash.chevron.right", color: .orange)
        }
    }
    
    private var contextTitle: String {
        if let secondary = selectedSecondary {
            return categoriesForPrimary(selectedPrimary)
                .flatMap { [$0] + $0.children }
                .first { $0.id == secondary }?.title ?? selectedPrimary.title
        }
        return selectedPrimary.title
    }
    
    private var contextSubtitle: String? {
        selectedSecondary != nil ? selectedPrimary.title : nil
    }
}

// MARK: - Category Data

extension DoubleSidebarLayoutV2 {
    func categoriesForPrimary(_ primary: PrimaryNavItem) -> [SecondaryCategory] {
        switch primary {
        case .dashboard:
            return [
                SecondaryCategory(id: "overview", title: "Overview", icon: "square.grid.2x2", color: FlowColors.Category.dashboard),
                SecondaryCategory(id: "quickactions", title: "Quick Actions", icon: "bolt.fill", color: FlowColors.Status.warning),
                SecondaryCategory(id: "analytics", title: "Analytics", icon: "chart.xyaxis.line", color: FlowColors.Status.success),
                SecondaryCategory(id: "systemstatus", title: "System Status", icon: "server.rack", color: FlowColors.Status.info),
                SecondaryCategory(id: "resources", title: "Resources", icon: "square.stack.3d.up.fill", color: FlowColors.Category.projects)
            ]
        case .workflows:
            return [
                SecondaryCategory(id: "all", title: "All Workflows", icon: "list.bullet", color: FlowColors.Category.workflows),
                SecondaryCategory(id: "development", title: "Development", icon: "hammer.fill", color: FlowColors.Category.workflows),
                SecondaryCategory(id: "testing", title: "Testing", icon: "checkmark.seal.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "templates", title: "Templates", icon: "doc.on.doc.fill", color: FlowColors.Status.neutral)
            ]
        case .agents:
            return [
                SecondaryCategory(id: "active", title: "Active", icon: "play.circle.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "all", title: "All Agents", icon: "list.bullet", color: FlowColors.Category.agents),
                SecondaryCategory(id: "history", title: "Run History", icon: "clock.arrow.circlepath", color: FlowColors.Status.info)
            ]
        case .projects:
            return [
                SecondaryCategory(id: "connected", title: "Connected", icon: "link.circle.fill", color: FlowColors.Category.projects),
                SecondaryCategory(id: "templates", title: "Templates", icon: "doc.text.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "packages", title: "Packages", icon: "shippingbox.fill", color: FlowColors.Status.warning)
            ]
        case .commands:
            return [
                SecondaryCategory(id: "library", title: "All Commands", icon: "books.vertical.fill", color: FlowColors.Category.commands),
                SecondaryCategory(id: "shell", title: "Shell", icon: "terminal.fill", color: FlowColors.Category.commands),
                SecondaryCategory(id: "favorites", title: "Favorites", icon: "star.fill", color: FlowColors.Status.warning)
            ]
        case .documentation:
            return [
                SecondaryCategory(id: "apple", title: "Apple Docs", icon: "apple.logo", color: FlowColors.Category.documentation),
                SecondaryCategory(id: "swift", title: "Swift.org", icon: "swift", color: .orange),
                SecondaryCategory(id: "search", title: "Search", icon: "magnifyingglass", color: FlowColors.Status.info)
            ]
        default:
            return [
                SecondaryCategory(id: "all", title: "All", icon: "list.bullet", color: FlowColors.Status.neutral)
            ]
        }
    }
}

// MARK: - View Modifiers for Notification Handling

extension View {
    func setupNotificationHandlers(
        selectedPrimary: Binding<PrimaryNavItem>,
        rightSidebarManager: RightSidebarManager,
        inputPanelManager: InputPanelManager
    ) -> some View {
        self
            .onReceive(NotificationCenter.default.publisher(for: .showTerminalPanel)) { _ in
                withAnimation { inputPanelManager.show(tab: .terminal) }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showOutputPanel)) { _ in
                withAnimation { inputPanelManager.show(tab: .output) }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showProblemsPanel)) { _ in
                withAnimation { inputPanelManager.show(tab: .problems) }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showChat)) { _ in
                withAnimation { rightSidebarManager.showChat() }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showWorkflows)) { _ in
                withAnimation { selectedPrimary.wrappedValue = .workflows }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showProjects)) { _ in
                withAnimation { selectedPrimary.wrappedValue = .projects }
            }
            .onReceive(NotificationCenter.default.publisher(for: .showDashboard)) { _ in
                withAnimation { selectedPrimary.wrappedValue = .dashboard }
            }
            .onReceive(NotificationCenter.default.publisher(for: .inputPanelWidthModeChanged)) { notification in
                // When input panel extends, ensure chat is visible for split layout
                // Note: Don't force notifications - it's independent of chat
                if let isExtended = notification.userInfo?["isExtended"] as? Bool, isExtended {
                    withAnimation(FlowMotion.standard) {
                        if !rightSidebarManager.isVisible {
                            // Open chat if not visible
                            rightSidebarManager.showChat()
                        }
                        // If showing single non-chat content, split with chat on bottom
                        if case .single(let content) = rightSidebarManager.mode, content != .chat {
                            rightSidebarManager.splitWith(top: content, bottom: .chat)
                        }
                        // If minimized, just show chat
                        if case .minimized = rightSidebarManager.mode {
                            rightSidebarManager.showChat()
                        }
                    }
                }
            }
    }
    
    func setupNavigationSync(
        selectedPrimary: Binding<PrimaryNavItem>,
        selectedSecondary: Binding<String?>,
        navigationCoordinator: NavigationCoordinator
    ) -> some View {
        self
            .onReceive(navigationCoordinator.$currentPrimaryTab) { tab in
                if let primary = PrimaryNavItem(rawValue: tab) {
                    withAnimation { selectedPrimary.wrappedValue = primary }
                }
            }
            .onReceive(navigationCoordinator.$currentSecondarySection) { section in
                withAnimation { selectedSecondary.wrappedValue = section }
            }
            .onChange(of: selectedPrimary.wrappedValue) { _, newValue in
                navigationCoordinator.currentPrimaryTab = newValue.rawValue
            }
            .onChange(of: selectedSecondary.wrappedValue) { _, newValue in
                navigationCoordinator.currentSecondarySection = newValue
            }
    }
}

// MARK: - Preview

#Preview("DoubleSidebarLayoutV2 - Dark") {
    DoubleSidebarLayoutV2()
        .preferredColorScheme(.dark)
        .frame(width: 1400, height: 900)
}

#Preview("DoubleSidebarLayoutV2 - Light") {
    DoubleSidebarLayoutV2()
        .preferredColorScheme(.light)
        .frame(width: 1400, height: 900)
}
