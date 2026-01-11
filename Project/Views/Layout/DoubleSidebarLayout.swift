//
//  DoubleSidebarLayout.swift
//  FlowKit
//
//  Professional layered layout with floating panels, adaptive colors, and accessibility
//  Structure: Icon Rail → Category Panel → Context (with floating panels)
//
//  Floating Panel System:
//  - Chat, Terminal, Output, Problems, Debug can share space
//  - Walkthroughs/Docs can float in upper half while chat is in lower half
//  - Each panel has its own accent color
//  - Panels match dashboard widget style
//

import SwiftUI
import Combine
import DesignKit
import NavigationKit
import DataKit

struct DoubleSidebarLayout: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    // Navigation Coordinator integration
    @StateObject private var navigationCoordinator = NavigationCoordinator.shared
    
    // Floating Panel Manager
    @StateObject private var panelManager = FloatingPanelManager.shared
    
    // Navigation state
    @State private var selectedPrimary: PrimaryNavItem = .dashboard
    @State private var selectedSecondary: String? = nil
    @State private var isSecondaryCollapsed: Bool = false
    @State private var expandedCategories: Set<String> = []
    @State private var hoveredPrimary: PrimaryNavItem? = nil
    @State private var hoveredSecondary: String? = nil
    
    // Search
    @State private var searchText: String = ""
    
    // Chat sidebar state
    @State private var chatSidebarMode: ChatSidebarMode = .minimized
    
    // Bottom panel state
    @State private var isBottomPanelVisible: Bool = false
    @State private var selectedBottomTab: BottomPanelTab = .terminal
    @State private var bottomPanelHeight: CGFloat = 200
    
    // Constants
    private let iconRailWidth: CGFloat = 64
    private let categoryCollapsedWidth: CGFloat = 56
    private let categoryExpandedWidth: CGFloat = 240
    private let minBottomHeight: CGFloat = 100
    private let maxBottomHeight: CGFloat = 400
    private let fullChatWidth: CGFloat = 380
    
    /// Whether any floating panels are visible
    private var hasFloatingPanels: Bool { panelManager.isPanelAreaVisible }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Base canvas
                FlowColors.Semantic.canvas(colorScheme)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Global toolbar
                    globalToolbar
                    
                    // Main content
                    HStack(spacing: 0) {
                        iconRailPanel
                        categoryPanel
                        
                        // Context area - adapts width when chat is in full mode
                        contextArea
                        
                        // Integrated chat panel (only when in full mode)
                        if chatSidebarMode == .full {
                            integratedChatPanel
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Floating chat panel (minimized button or half-size floating panel)
                // Only shown when NOT in full mode
                if chatSidebarMode != .full {
                    floatingChatPanel
                }
            }
        }
        .ignoresSafeArea(.all)
        .animation(reduceMotion ? .none : FlowMotion.standard, value: isSecondaryCollapsed)
        .animation(reduceMotion ? .none : FlowMotion.standard, value: chatSidebarMode)
        .animation(reduceMotion ? .none : FlowMotion.standard, value: isBottomPanelVisible)
        .onReceive(NotificationCenter.default.publisher(for: .showTerminalPanel)) { _ in
            withAnimation { isBottomPanelVisible = true; selectedBottomTab = .terminal }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showOutputPanel)) { _ in
            withAnimation { isBottomPanelVisible = true; selectedBottomTab = .output }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showProblemsPanel)) { _ in
            withAnimation { isBottomPanelVisible = true; selectedBottomTab = .problems }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showWorkflows)) { _ in
            withAnimation { selectedPrimary = .workflows }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showProjects)) { _ in
            withAnimation { selectedPrimary = .projects }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showDashboard)) { _ in
            withAnimation { selectedPrimary = .dashboard }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showChat)) { _ in
            withAnimation { chatSidebarMode = .half }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showAIAssistant)) { _ in
            withAnimation { selectedPrimary = .aiAssistant }
        }
        .onReceive(NotificationCenter.default.publisher(for: .toggleSidebar)) { _ in
            withAnimation { isSecondaryCollapsed.toggle() }
        }
        .onReceive(NotificationCenter.default.publisher(for: .toggleBottomPanel)) { notification in
            withAnimation {
                if let tab = notification.object as? String {
                    switch tab {
                    case "terminal": selectedBottomTab = .terminal
                    case "output": selectedBottomTab = .output
                    case "problems": selectedBottomTab = .problems
                    case "debug": selectedBottomTab = .debug
                    default: break
                    }
                }
                isBottomPanelVisible.toggle()
            }
        }
        .onReceive(NavigationCoordinator.shared.$currentPrimaryTab) { tab in
            if let primary = PrimaryNavItem(rawValue: tab) {
                withAnimation { selectedPrimary = primary }
            }
        }
        .onReceive(NavigationCoordinator.shared.$currentSecondarySection) { section in
            withAnimation { selectedSecondary = section }
        }
        .onChange(of: selectedPrimary) { _, newValue in
            navigationCoordinator.currentPrimaryTab = newValue.rawValue
        }
        .onChange(of: selectedSecondary) { _, newValue in
            navigationCoordinator.currentSecondarySection = newValue
        }
        .sheet(item: $navigationCoordinator.showingSheet) { sheetType in
            sheetContent(for: sheetType)
        }
        .alert(item: $navigationCoordinator.showingAlert) { alertInfo in
            Alert(
                title: Text(alertInfo.title),
                message: Text(alertInfo.message),
                primaryButton: .default(Text(alertInfo.primaryButton), action: alertInfo.primaryAction),
                secondaryButton: alertInfo.secondaryButton.map { .cancel(Text($0), action: alertInfo.secondaryAction ?? {}) } ?? .cancel()
            )
        }
    }
    
    // MARK: - Sheet Content Builder
    
    @ViewBuilder
    private func sheetContent(for sheetType: NavigationCoordinator.SheetType) -> some View {
        switch sheetType {
        case .newWorkflow:
            PlaceholderSheetView(title: "New Workflow")
        case .newProject:
            PlaceholderSheetView(title: "New Project")
        case .newAgent:
            PlaceholderSheetView(title: "New Agent")
        case .addInventoryItem:
            PlaceholderSheetView(title: "Add Inventory Item")
        case .connectMarketplace:
            PlaceholderSheetView(title: "Connect Marketplace")
        case .exportData:
            PlaceholderSheetView(title: "Export Data")
        case .importData:
            PlaceholderSheetView(title: "Import Data")
        case .search:
            PlaceholderSheetView(title: "Search")
        case .help:
            PlaceholderSheetView(title: "Help")
        case .onboarding:
            PlaceholderSheetView(title: "Onboarding")
        case .settings:
            PlaceholderSheetView(title: "Settings")
        case .workflowEditor:
            PlaceholderSheetView(title: "Workflow Editor")
        case .projectDetails:
            PlaceholderSheetView(title: "Project Details")
        case .marketplaceConnection:
            PlaceholderSheetView(title: "Marketplace Connection")
        }
    }
}

// MARK: - Placeholder Sheet View

struct PlaceholderSheetView: View {
    let title: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title)
            Text("Coming soon...")
                .foregroundStyle(.secondary)
            Button("Close") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .frame(width: 400, height: 300)
        .padding()
    }
}


// MARK: - Global Toolbar

extension DoubleSidebarLayout {
    private var globalToolbar: some View {
        HStack(spacing: 0) {
            CustomWindowControls()
                .padding(.leading, 14)
            
            Color.clear.frame(width: 20)
            
            HStack(spacing: 4) {
                ToolbarNavButton(icon: "chevron.left", enabled: false) {}
                ToolbarNavButton(icon: "chevron.right", enabled: false) {}
            }
            
            Spacer()
            
            SearchField(text: $searchText)
                .frame(width: 300)
            
            Spacer()
            
            HStack(spacing: 8) {
                ToolbarToggle(icon: "sidebar.left", isActive: !isSecondaryCollapsed, tooltip: "Toggle Sidebar") {
                    withAnimation { isSecondaryCollapsed.toggle() }
                }
                
                ToolbarToggle(icon: "rectangle.bottomhalf.filled", isActive: isBottomPanelVisible, tooltip: "Toggle Console") {
                    withAnimation { isBottomPanelVisible.toggle() }
                }
                
                ToolbarToggle(icon: "bubble.right.fill", isActive: chatSidebarMode != .minimized, tooltip: "Toggle Chat") {
                    withAnimation {
                        chatSidebarMode = chatSidebarMode == .minimized ? .half : .minimized
                    }
                }
                
                Divider().frame(height: 20).padding(.horizontal, 8)
                
                ToolbarNavButton(icon: "person.circle.fill", enabled: true) {
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

// MARK: - Icon Rail Panel

extension DoubleSidebarLayout {
    private var iconRailPanel: some View {
        VStack(spacing: 0) {
            AppIconBadge()
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            Capsule()
                .fill(FlowColors.Border.subtle(colorScheme))
                .frame(width: 32, height: 2)
                .padding(.bottom, 8)
            
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
                        .accessibilityLabel(item.title)
                        .accessibilityAddTraits(selectedPrimary == item ? .isSelected : [])
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .frame(width: iconRailWidth)
        .background(iconRailBackground)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Main Navigation")
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

extension DoubleSidebarLayout {
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
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(selectedPrimary.title) Categories")
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
            .accessibilityLabel(isSecondaryCollapsed ? "Expand sidebar" : "Collapse sidebar")
        }
        .padding(.horizontal, isSecondaryCollapsed ? 16 : 16)
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
}


// MARK: - Context Area

extension DoubleSidebarLayout {
    private var contextArea: some View {
        VStack(spacing: 0) {
            contextHeader
            
            contextContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if isBottomPanelVisible {
                bottomPanelDivider
                bottomPanel
            }
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

// MARK: - Placeholder Content View

struct PlaceholderContentView: View {
    let title: String
    let icon: String
    let color: Color
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 80, height: 80)
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundStyle(color)
            }
            
            Text(title)
                .font(FlowTypography.title2())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Text("This section is coming soon")
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Integrated Chat Panel (Adaptive Layout)

extension DoubleSidebarLayout {
    /// Integrated chat panel that sits beside the content area (full mode only)
    private var integratedChatPanel: some View {
        VStack(spacing: 0) {
            // Chat header
            integratedChatHeader
            
            // Chat content
            IntegratedChatContent()
                .frame(maxHeight: .infinity)
        }
        .frame(width: fullChatWidth)
        .background(integratedChatBackground)
        .overlay(
            HStack {
                FlowColors.Border.medium(colorScheme).frame(width: 1)
                Spacer()
            }
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Chat Panel")
    }
    
    private var integratedChatHeader: some View {
        HStack(spacing: 10) {
            // Chat icon with glow
            ZStack {
                Circle()
                    .fill(FlowColors.Category.chat.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .blur(radius: 4)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [FlowColors.Category.chat, FlowColors.Category.chat.opacity(0.7)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("FlowKit Assistant")
                    .font(FlowTypography.headline())
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text("AI-powered help")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
            
            // Size controls
            HStack(spacing: 4) {
                ChatSizeButton(
                    icon: chatSidebarMode == .full ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right",
                    tooltip: chatSidebarMode == .full ? "Half Size" : "Full Size"
                ) {
                    withAnimation(FlowMotion.standard) {
                        chatSidebarMode = chatSidebarMode == .full ? .half : .full
                    }
                }
                
                ChatSizeButton(icon: "xmark", tooltip: "Close Chat") {
                    withAnimation(FlowMotion.standard) { chatSidebarMode = .minimized }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            VStack {
                Spacer()
                FlowColors.Border.subtle(colorScheme).frame(height: 1)
            }
        )
    }
    
    private var integratedChatBackground: some View {
        ZStack {
            FlowColors.Semantic.surface(colorScheme)
            
            LinearGradient(
                colors: [
                    FlowColors.Category.chat.opacity(colorScheme == .dark ? 0.03 : 0.01),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    /// Floating chat panel - shows minimized button or half-size floating panel
    /// This is the original look: bottom-right, expands upward, rounded corners, shadow
    private var floatingChatPanel: some View {
        GeometryReader { _ in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    if chatSidebarMode == .minimized {
                        // Minimized: Just a button
                        minimizedChatButtonContent
                    } else {
                        // Half mode: Floating panel that expands upward
                        floatingHalfChatPanel
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Chat Panel")
    }
    
    /// Minimized chat button content
    private var minimizedChatButtonContent: some View {
        Button(action: {
            withAnimation(FlowMotion.standard) { chatSidebarMode = .half }
        }) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(FlowColors.Category.chat.opacity(0.2))
                        .frame(width: 32, height: 32)
                        .blur(radius: 4)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [FlowColors.Category.chat, FlowColors.Category.chat.opacity(0.7)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                }
                
                Text("Chat with FlowKit")
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Image(systemName: "chevron.up")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.xl, style: .continuous)
                    .fill(FlowColors.Semantic.floating(colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: FlowRadius.xl, style: .continuous)
                    .strokeBorder(FlowColors.Border.medium(colorScheme), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 20, x: 0, y: 8)
            .shadow(color: FlowColors.Category.chat.opacity(0.1), radius: 30, x: 0, y: 0)
        }
        .buttonStyle(.plain)
        .padding(.trailing, 16)
        .padding(.bottom, 16)
    }
    
    /// Floating half-size chat panel (original look - expands upward from bottom-right)
    private var floatingHalfChatPanel: some View {
        VStack(spacing: 0) {
            // Header
            floatingChatHeader
            
            // Content
            IntegratedChatContent()
                .frame(maxHeight: .infinity)
        }
        .frame(width: 380, height: 450)
        .background(floatingChatBackground)
        .clipShape(RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: FlowRadius.lg, style: .continuous)
                .strokeBorder(FlowColors.Border.medium(colorScheme), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 20, x: 0, y: 8)
        .shadow(color: FlowColors.Category.chat.opacity(0.1), radius: 30, x: 0, y: 0)
        .padding(.trailing, 16)
        .padding(.bottom, 16)
    }
    
    /// Header for floating chat panel
    private var floatingChatHeader: some View {
        HStack(spacing: 10) {
            // Chat icon with glow
            ZStack {
                Circle()
                    .fill(FlowColors.Category.chat.opacity(0.2))
                    .frame(width: 32, height: 32)
                    .blur(radius: 4)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [FlowColors.Category.chat, FlowColors.Category.chat.opacity(0.7)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("FlowKit Assistant")
                    .font(FlowTypography.headline())
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text("AI-powered help")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
            
            // Size controls
            HStack(spacing: 4) {
                // Expand to full (integrated) mode
                ChatSizeButton(
                    icon: "arrow.up.left.and.arrow.down.right",
                    tooltip: "Full Size (Integrated)"
                ) {
                    withAnimation(FlowMotion.standard) { chatSidebarMode = .full }
                }
                
                // Minimize
                ChatSizeButton(icon: "chevron.down", tooltip: "Minimize") {
                    withAnimation(FlowMotion.standard) { chatSidebarMode = .minimized }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            VStack {
                Spacer()
                FlowColors.Border.subtle(colorScheme).frame(height: 1)
            }
        )
    }
    
    /// Background for floating chat panel
    private var floatingChatBackground: some View {
        ZStack {
            FlowColors.Semantic.floating(colorScheme)
            
            LinearGradient(
                colors: [
                    FlowColors.Category.chat.opacity(colorScheme == .dark ? 0.05 : 0.02),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Integrated Chat Content

struct IntegratedChatContent: View {
    @State private var inputText = ""
    @State private var messages: [SimpleChatMessage] = []
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    if messages.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 32))
                                .foregroundStyle(FlowColors.Category.chat)
                            Text("How can I help you today?")
                                .font(FlowTypography.body())
                                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        ForEach(messages) { message in
                            SimpleChatBubble(message: message)
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            HStack(spacing: 8) {
                TextField("Ask anything...", text: $inputText)
                    .textFieldStyle(.plain)
                    .font(FlowTypography.body())
                    .onSubmit { sendMessage() }
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(inputText.isEmpty ? FlowColors.Text.tertiary(colorScheme) : FlowColors.Category.chat)
                }
                .buttonStyle(.plain)
                .disabled(inputText.isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
    }
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        messages.append(SimpleChatMessage(content: inputText, isUser: true))
        let userMessage = inputText
        inputText = ""
        
        // Simulate response
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            messages.append(SimpleChatMessage(content: "I received: \"\(userMessage)\". How can I help further?", isUser: false))
        }
    }
}

struct SimpleChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

struct SimpleChatBubble: View {
    let message: SimpleChatMessage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .font(FlowTypography.body())
                .foregroundStyle(message.isUser ? .white : FlowColors.Text.primary(colorScheme))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: FlowRadius.md)
                        .fill(message.isUser ? FlowColors.Category.chat : FlowColors.Semantic.surface(colorScheme))
                )
            
            if !message.isUser { Spacer() }
        }
    }
}


// MARK: - Bottom Panel

extension DoubleSidebarLayout {
    private var bottomPanelDivider: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: 6)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        bottomPanelHeight = min(max(bottomPanelHeight - value.translation.height, minBottomHeight), maxBottomHeight)
                    }
            )
            .onHover { if $0 { NSCursor.resizeUpDown.push() } else { NSCursor.pop() } }
    }
    
    private var bottomPanel: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(BottomPanelTab.allCases) { tab in
                    BottomTabItem(
                        tab: tab,
                        isSelected: selectedBottomTab == tab,
                        action: { selectedBottomTab = tab }
                    )
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    ContextButton(icon: "trash") {}
                    ContextButton(icon: "xmark") {
                        withAnimation { isBottomPanelVisible = false }
                    }
                }
                .padding(.trailing, 12)
            }
            .padding(.leading, 8)
            .frame(height: 36)
            .background(
                ZStack {
                    FlowColors.Semantic.elevated(colorScheme)
                    VStack { FlowColors.Border.medium(colorScheme).frame(height: 1); Spacer() }
                }
            )
            
            bottomPanelContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: bottomPanelHeight)
        .background(FlowColors.Semantic.surface(colorScheme))
    }
    
    @ViewBuilder
    private var bottomPanelContent: some View {
        switch selectedBottomTab {
        case .terminal: TerminalView()
        case .output: OutputView()
        case .problems: ProblemsView()
        case .debug: DebugView()
        }
    }
}

// MARK: - Helper Methods

extension DoubleSidebarLayout {
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
    
    private func categoriesForPrimary(_ primary: PrimaryNavItem) -> [SecondaryCategory] {
        switch primary {
        case .dashboard:
            return [
                SecondaryCategory(id: "overview", title: "Overview", icon: "square.grid.2x2", color: FlowColors.Category.dashboard),
                SecondaryCategory(id: "quickactions", title: "Quick Actions", icon: "bolt.fill", color: FlowColors.Status.warning),
                SecondaryCategory(id: "recent", title: "Recent", icon: "clock.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "analytics", title: "Analytics", icon: "chart.xyaxis.line", color: FlowColors.Status.success),
                SecondaryCategory(id: "systemstatus", title: "System Status", icon: "server.rack", color: FlowColors.Status.info),
                SecondaryCategory(id: "recentactivity", title: "Recent Activity", icon: "clock.arrow.circlepath", color: FlowColors.Category.chat),
                SecondaryCategory(id: "resources", title: "Resources", icon: "square.stack.3d.up.fill", color: FlowColors.Category.projects)
            ]
        case .aiAssistant:
            return [
                SecondaryCategory(id: "ai.overview", title: "Overview", icon: "sparkles", color: .purple),
                SecondaryCategory(id: "ai.create", title: "Project Creation", icon: "hammer.fill", color: .blue),
                SecondaryCategory(id: "ai.docs", title: "Documentation", icon: "doc.text.fill", color: .green),
                SecondaryCategory(id: "ai.analyze", title: "Code Analysis", icon: "magnifyingglass", color: .orange),
                SecondaryCategory(id: "ai.workflows", title: "Workflows", icon: "arrow.triangle.branch", color: .purple),
                SecondaryCategory(id: "ai.history", title: "History", icon: "clock.fill", color: FlowColors.Status.info)
            ]
        case .inventory:
            return [
                SecondaryCategory(id: "inv.dashboard", title: "Dashboard", icon: "chart.bar.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "inv.items", title: "All Items", icon: "shippingbox.fill", color: FlowColors.Category.projects),
                SecondaryCategory(id: "inv.sales", title: "Sales", icon: "dollarsign.circle.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "inv.customers", title: "Customers", icon: "person.2.fill", color: FlowColors.Category.agents),
                SecondaryCategory(id: "inv.listings", title: "Listings", icon: "list.bullet.rectangle.fill", color: FlowColors.Category.commands),
                SecondaryCategory(id: "inv.shipping", title: "Shipping", icon: "truck.box.fill", color: FlowColors.Category.workflows)
            ]
        case .workflows:
            return [
                SecondaryCategory(id: "all", title: "All Workflows", icon: "list.bullet", color: FlowColors.Category.workflows),
                SecondaryCategory(id: "development", title: "Development", icon: "hammer.fill", color: FlowColors.Category.workflows),
                SecondaryCategory(id: "testing", title: "Testing", icon: "checkmark.seal.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "deployment", title: "Deployment", icon: "arrow.up.doc.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "automation", title: "Automation", icon: "gearshape.2.fill", color: FlowColors.Status.warning),
                SecondaryCategory(id: "templates", title: "Templates", icon: "doc.on.doc.fill", color: FlowColors.Status.neutral),
                SecondaryCategory(id: "shared", title: "Shared", icon: "person.2.fill", color: FlowColors.Category.workflows),
                SecondaryCategory(id: "create", title: "Create New", icon: "plus.circle.fill", color: FlowColors.Status.success)
            ]
        case .agents:
            return [
                SecondaryCategory(id: "active", title: "Active", icon: "play.circle.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "all", title: "All Agents", icon: "list.bullet", color: FlowColors.Category.agents),
                SecondaryCategory(id: "create", title: "Create", icon: "plus.circle.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "history", title: "Run History", icon: "clock.arrow.circlepath", color: FlowColors.Status.info)
            ]
        case .projects:
            return [
                SecondaryCategory(id: "connected", title: "Connected", icon: "link.circle.fill", color: FlowColors.Category.projects),
                SecondaryCategory(id: "builtApps", title: "Built Apps", icon: "app.badge.checkmark.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "uiProjects", title: "UI Projects", icon: "app.fill", color: FlowColors.Category.commands),
                SecondaryCategory(id: "templates", title: "Templates", icon: "doc.text.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "packages", title: "Packages", icon: "shippingbox.fill", color: FlowColors.Status.warning),
                SecondaryCategory(id: "components", title: "Components", icon: "square.stack.3d.up.fill", color: FlowColors.Status.neutral)
            ]
        case .commands:
            return [
                SecondaryCategory(id: "library", title: "All Commands", icon: "books.vertical.fill", color: FlowColors.Category.commands),
                SecondaryCategory(id: "shell", title: "Shell", icon: "terminal.fill", color: FlowColors.Category.commands),
                SecondaryCategory(id: "git", title: "Git", icon: "arrow.triangle.branch", color: .orange),
                SecondaryCategory(id: "docker", title: "Docker", icon: "shippingbox.fill", color: .blue),
                SecondaryCategory(id: "swift", title: "Swift", icon: "swift", color: .orange),
                SecondaryCategory(id: "python", title: "Python", icon: "chevron.left.forwardslash.chevron.right", color: .yellow),
                SecondaryCategory(id: "recent", title: "Recent", icon: "clock.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "favorites", title: "Favorites", icon: "star.fill", color: FlowColors.Status.warning),
                SecondaryCategory(id: "custom", title: "Custom", icon: "plus.square.fill", color: FlowColors.Status.success)
            ]
        case .documentation:
            return [
                SecondaryCategory(id: "apple", title: "Apple Docs", icon: "apple.logo", color: FlowColors.Category.documentation),
                SecondaryCategory(id: "swift", title: "Swift.org", icon: "swift", color: .orange),
                SecondaryCategory(id: "community", title: "Community", icon: "person.3.fill", color: .purple),
                SecondaryCategory(id: "custom", title: "Custom Docs", icon: "folder.fill", color: FlowColors.Status.neutral),
                SecondaryCategory(id: "bookmarks", title: "Bookmarks", icon: "bookmark.fill", color: FlowColors.Status.warning),
                SecondaryCategory(id: "search", title: "Search", icon: "magnifyingglass", color: FlowColors.Status.info)
            ]
        case .files:
            return [
                SecondaryCategory(id: "home", title: "Home", icon: "house.fill", color: .blue),
                SecondaryCategory(id: "documents", title: "Documents", icon: "doc.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "downloads", title: "Downloads", icon: "arrow.down.circle.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "recent", title: "Recent", icon: "clock.fill", color: FlowColors.Status.warning)
            ]
        case .mlTemplates:
            return [
                SecondaryCategory(id: "ml.chat", title: "Chat Systems", icon: "bubble.left.and.bubble.right.fill", color: .purple),
                SecondaryCategory(id: "ml.ui", title: "UI Enhancement", icon: "wand.and.stars", color: .blue),
                SecondaryCategory(id: "ml.automation", title: "Automation", icon: "gearshape.2.fill", color: .green),
                SecondaryCategory(id: "ml.devtools", title: "Dev Tools", icon: "hammer.fill", color: .orange),
                SecondaryCategory(id: "ml.apps", title: "App Templates", icon: "app.gift.fill", color: .pink),
                SecondaryCategory(id: "ml.advanced", title: "Advanced Chat", icon: "message.badge.waveform.fill", color: .cyan)
            ]
        case .mlArchitect:
            return [
                SecondaryCategory(id: "arch.meta", title: "Meta-Generators", icon: "cube.transparent", color: .purple),
                SecondaryCategory(id: "arch.capabilities", title: "Advanced Capabilities", icon: "brain.head.profile", color: .blue),
                SecondaryCategory(id: "arch.devtools", title: "Autonomous Dev Tools", icon: "wrench.and.screwdriver.fill", color: .green),
                SecondaryCategory(id: "arch.projects", title: "New Project Types", icon: "app.badge.checkmark.fill", color: .orange),
                SecondaryCategory(id: "arch.infra", title: "ML Infrastructure", icon: "server.rack", color: .red),
                SecondaryCategory(id: "arch.ui", title: "Ultra-Advanced UI", icon: "rectangle.3.group.bubble.fill", color: .cyan),
                SecondaryCategory(id: "arch.blueprints", title: "My Blueprints", icon: "doc.text.fill", color: .indigo)
            ]
        case .settings:
            return [
                SecondaryCategory(id: "profile", title: "Profile", icon: "person.circle.fill", color: .gray),
                SecondaryCategory(id: "account", title: "Account", icon: "person.badge.key.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "marketplaces", title: "Marketplaces", icon: "cart.fill", color: FlowColors.Status.success),
                SecondaryCategory(id: "privacy", title: "Privacy", icon: "lock.shield.fill", color: FlowColors.Status.warning),
                SecondaryCategory(id: "agents", title: "Agents", icon: "cpu.fill", color: FlowColors.Category.agents),
                SecondaryCategory(id: "assets", title: "Asset Library", icon: "square.stack.3d.up.fill", color: FlowColors.Category.projects),
                SecondaryCategory(id: "appearance", title: "Appearance", icon: "paintbrush.fill", color: FlowColors.Category.chat)
            ]
        case .search:
            return [
                SecondaryCategory(id: "all", title: "All Results", icon: "magnifyingglass", color: FlowColors.Category.chat),
                SecondaryCategory(id: "recent", title: "Recent Searches", icon: "clock.fill", color: FlowColors.Status.info)
            ]
        case .indexedDocs:
            return [
                SecondaryCategory(id: "all", title: "All Documents", icon: "doc.text.fill", color: FlowColors.Category.documentation),
                SecondaryCategory(id: "json", title: "JSON Files", icon: "curlybraces", color: FlowColors.Status.info),
                SecondaryCategory(id: "markdown", title: "Markdown", icon: "text.alignleft", color: FlowColors.Status.success)
            ]
        case .indexedCode:
            return [
                SecondaryCategory(id: "all", title: "All Code", icon: "chevron.left.forwardslash.chevron.right", color: FlowColors.Category.projects),
                SecondaryCategory(id: "classes", title: "Classes", icon: "cube.fill", color: FlowColors.Status.info),
                SecondaryCategory(id: "functions", title: "Functions", icon: "function", color: FlowColors.Status.success),
                SecondaryCategory(id: "protocols", title: "Protocols", icon: "doc.plaintext", color: FlowColors.Status.warning)
            ]
        }
    }
}

// MARK: - Previews

#Preview("Full Layout - Dark") {
    DoubleSidebarLayout()
        .preferredColorScheme(.dark)
        .frame(width: 1400, height: 900)
}

#Preview("Full Layout - Light") {
    DoubleSidebarLayout()
        .preferredColorScheme(.light)
        .frame(width: 1400, height: 900)
}
