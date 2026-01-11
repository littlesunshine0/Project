//
//  DashboardView.swift
//  FlowKit
//
//  Professional dashboard with adaptive widgets, live data, and accessibility
//  HIG-compliant adaptive grid layout that responds to available space
//

import SwiftUI
import Combine
import DesignKit
import NavigationKit

struct DashboardView: View {
    var selectedSection: String? = nil
    
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private var animation: Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : FlowMotion.standard
    }
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let columnCount = adaptiveColumnCount(for: availableWidth)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Overview Section
                        welcomeHeader
                            .id("overview")
                        
                        // Metrics/Overview - Adaptive grid
                        metricsSection(columns: columnCount, width: availableWidth)
                        
                        // Quick Actions Section - Adaptive grid
                        quickActionsSection(columns: columnCount, width: availableWidth)
                            .id("quickactions")
                        
                        // Two-column layout for status and activity when space allows
                        if availableWidth >= 900 {
                            HStack(alignment: .top, spacing: 16) {
                                systemStatusSection
                                    .frame(maxWidth: .infinity)
                                    .id("systemstatus")
                                
                                recentActivitySection
                                    .frame(maxWidth: .infinity)
                                    .id("recentactivity")
                            }
                        } else {
                            systemStatusSection
                                .id("systemstatus")
                            
                            recentActivitySection
                                .id("recentactivity")
                        }
                        
                        // Analytics Section
                        analyticsSection
                            .id("analytics")
                        
                        // Resources Section - Adaptive grid
                        resourcesSection(columns: columnCount, width: availableWidth)
                            .id("resources")
                    }
                    .padding(20)
                }
                .background(FlowColors.Semantic.canvas(colorScheme))
                .onChange(of: selectedSection) { _, newSection in
                    if let section = newSection {
                        withAnimation(animation) {
                            proxy.scrollTo(section, anchor: .top)
                        }
                    }
                }
                .onAppear {
                    if let section = selectedSection {
                        proxy.scrollTo(section, anchor: .top)
                    }
                }
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
    
    // MARK: - Adaptive Layout Helpers
    
    /// Calculate optimal column count based on available width
    private func adaptiveColumnCount(for width: CGFloat) -> Int {
        switch width {
        case ..<500: return 2
        case 500..<700: return 3
        case 700..<1000: return 4
        default: return min(6, Int(width / 180))
        }
    }
    
    // MARK: - Welcome Header
    
    private var welcomeHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 12) {
                    Text(viewModel.greeting)
                        .font(FlowTypography.title1())
                        .foregroundStyle(FlowColors.Text.primary(colorScheme))
                    
                    // Live status indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(viewModel.systemHealthy ? FlowColors.Status.success : FlowColors.Status.warning)
                            .frame(width: 8, height: 8)
                        
                        Text(viewModel.systemHealthy ? "All systems operational" : "Issues detected")
                            .font(FlowTypography.caption(.medium))
                            .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(FlowColors.Border.subtle(colorScheme)))
                }
                
                Text("Here's what's happening with your workflows today.")
                    .font(FlowTypography.body())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            }
            
            Spacer()
            
            // Date/time widget
            VStack(alignment: .trailing, spacing: 4) {
                Text(viewModel.currentTime, style: .time)
                    .font(FlowTypography.title3(.medium))
                    .monospacedDigit()
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text(viewModel.currentTime, style: .date)
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.md, style: .continuous)
                    .fill(FlowColors.Semantic.surface(colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: FlowRadius.md, style: .continuous)
                            .strokeBorder(FlowColors.Border.subtle(colorScheme), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Metrics Section (Adaptive)
    
    private func metricsSection(columns: Int, width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Overview", icon: "chart.bar.fill", color: FlowColors.Category.dashboard)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: min(columns, 4)), spacing: 12) {
                MetricWidget(
                    title: "Workflows Run",
                    value: "\(viewModel.workflowsRun)",
                    subtitle: "This week",
                    icon: "arrow.triangle.branch",
                    color: FlowColors.Category.workflows,
                    trend: viewModel.workflowsTrend,
                    size: columns <= 2 ? .compact : .small
                )
                
                MetricWidget(
                    title: "Success Rate",
                    value: "\(viewModel.successRate)%",
                    subtitle: "Last 7 days",
                    icon: "checkmark.seal.fill",
                    color: FlowColors.Status.success,
                    trend: viewModel.successTrend,
                    size: columns <= 2 ? .compact : .small
                )
                
                MetricWidget(
                    title: "Active Agents",
                    value: "\(viewModel.activeAgents)",
                    subtitle: "Running now",
                    icon: "cpu.fill",
                    color: FlowColors.Category.agents,
                    size: columns <= 2 ? .compact : .small
                )
                
                MetricWidget(
                    title: "Commands",
                    value: "\(viewModel.commandCount)",
                    subtitle: "Available",
                    icon: "terminal.fill",
                    color: FlowColors.Category.commands,
                    size: columns <= 2 ? .compact : .small
                )
            }
        }
    }
    
    // MARK: - Quick Actions Section (Adaptive)
    
    private func quickActionsSection(columns: Int, width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Quick Actions", icon: "bolt.fill", color: FlowColors.Status.warning)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: min(columns, 4)), spacing: 12) {
                ActionWidget(
                    title: "New Workflow",
                    description: "Create automation",
                    icon: "plus",
                    color: FlowColors.Category.workflows,
                    size: columns <= 2 ? .compact : .small
                ) {
                    NavigationCoordinator.shared.navigate(to: .newWorkflow)
                }
                
                ActionWidget(
                    title: "Run Agent",
                    description: "Execute AI task",
                    icon: "play.fill",
                    color: FlowColors.Category.agents,
                    size: columns <= 2 ? .compact : .small
                ) {
                    NavigationCoordinator.shared.runRecommendedAgent()
                }
                
                ActionWidget(
                    title: "Search Docs",
                    description: "Find documentation",
                    icon: "magnifyingglass",
                    color: FlowColors.Category.documentation,
                    size: columns <= 2 ? .compact : .small
                ) {
                    NavigationCoordinator.shared.navigate(to: .documentation(section: .search))
                }
                
                ActionWidget(
                    title: "Open Terminal",
                    description: "Run commands",
                    icon: "terminal",
                    color: FlowColors.Category.commands,
                    size: columns <= 2 ? .compact : .small
                ) {
                    NavigationCoordinator.shared.showTerminal()
                }
            }
        }
    }
    
    // MARK: - System Status Section
    
    private var systemStatusSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "System Status", icon: "server.rack", color: FlowColors.Status.info)
            
            WidgetCard(style: .elevated, size: .wide, accentColor: FlowColors.Status.info) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(viewModel.systemServices.enumerated()), id: \.element.id) { index, service in
                        SystemStatusRow(service: service, colorScheme: colorScheme)
                        if index < viewModel.systemServices.count - 1 {
                            Divider().padding(.vertical, 8)
                        }
                    }
                }
                .padding(16)
            }
        }
    }
    
    // MARK: - Recent Activity Section
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Recent Activity", icon: "clock.arrow.circlepath", color: FlowColors.Category.chat)
            
            WidgetCard(style: .elevated, size: .wide, accentColor: FlowColors.Category.chat) {
                VStack(alignment: .leading, spacing: 0) {
                    if viewModel.recentActivities.isEmpty {
                        emptyActivityView
                    } else {
                        ForEach(Array(viewModel.recentActivities.enumerated()), id: \.element.id) { index, activity in
                            RecentsRow(activity: activity, colorScheme: colorScheme)
                            if index < viewModel.recentActivities.count - 1 {
                                Divider().padding(.vertical, 8)
                            }
                        }
                    }
                }
                .padding(16)
            }
        }
    }
    
    private var emptyActivityView: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 36))
                .foregroundStyle(.quaternary)
            
            Text("No recent activity")
                .font(FlowTypography.body(.medium))
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Text("Run a workflow to see activity here")
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
        }
        .frame(maxWidth: .infinity, minHeight: 150)
    }
    
    // MARK: - Analytics Section
    
    private var analyticsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Analytics", icon: "chart.xyaxis.line", color: FlowColors.Status.success)
            
            WidgetCard(style: .glass, size: .wide, accentColor: FlowColors.Status.success) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Detailed Analytics")
                            .font(FlowTypography.headline())
                            .foregroundStyle(FlowColors.Text.primary(colorScheme))
                        Text("View comprehensive workflow analytics, bottleneck detection, and optimization suggestions")
                            .font(FlowTypography.body())
                            .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        NavigationCoordinator.shared.navigate(to: .dashboard(section: .analytics))
                    }) {
                        HStack {
                            Text("Open Dashboard")
                            Image(systemName: "arrow.right")
                        }
                        .font(FlowTypography.body(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(FlowColors.Status.success)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
            }
        }
    }
    
    // MARK: - Resources Section (Adaptive)
    
    private func resourcesSection(columns: Int, width: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Resources", icon: "square.stack.3d.up.fill", color: FlowColors.Category.projects)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: min(columns, 4)), spacing: 12) {
                ResourceCard(
                    title: "Workflows",
                    count: viewModel.workflowCount,
                    icon: "arrow.triangle.branch",
                    color: FlowColors.Category.workflows
                ) {
                    NavigationCoordinator.shared.navigate(to: .workflows())
                }
                
                ResourceCard(
                    title: "Projects",
                    count: viewModel.projectCount,
                    icon: "folder.fill",
                    color: FlowColors.Category.projects
                ) {
                    NavigationCoordinator.shared.navigate(to: .projects())
                }
                
                ResourceCard(
                    title: "Documentation",
                    count: viewModel.docCount,
                    icon: "book.closed.fill",
                    color: FlowColors.Category.documentation
                ) {
                    NavigationCoordinator.shared.navigate(to: .documentation())
                }
                
                ResourceCard(
                    title: "Templates",
                    count: viewModel.templateCount,
                    icon: "doc.on.doc.fill",
                    color: FlowColors.Status.neutral
                ) {
                    NavigationCoordinator.shared.navigate(to: .projects(section: .templates))
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func sectionHeader(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(color)
            
            Text(title)
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Spacer()
        }
    }
}


// MARK: - View Model

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var currentTime = Date()
    @Published var systemHealthy = true
    
    // Metrics
    @Published var workflowsRun = 0
    @Published var successRate = 0
    @Published var activeAgents = 0
    @Published var commandCount = 0
    
    // Trends
    @Published var workflowsTrend: MetricWidget.Trend? = nil
    @Published var successTrend: MetricWidget.Trend? = nil
    
    // Resources
    @Published var workflowCount = 0
    @Published var projectCount = 0
    @Published var docCount = 0
    @Published var templateCount = 0
    
    // Services
    @Published var systemServices: [SystemService] = []
    
    // Activity
    @Published var recentActivities: [RecentActivity] = []
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }
    
    init() {
        // Update time every second
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.currentTime = Date()
            }
        }
        
        // Subscribe to workflow completion
        NotificationCenter.default.addObserver(
            forName: .workflowCompleted,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let name = userInfo["workflowName"] as? String,
                  let success = userInfo["success"] as? Bool else { return }
            
            Task { @MainActor in
                self?.handleWorkflowCompleted(name: name, success: success)
            }
        }
    }
    
    private func handleWorkflowCompleted(name: String, success: Bool) {
        
        workflowsRun += 1
        workflowsTrend = .up("+\(workflowsRun)")
        
        recentActivities.insert(RecentActivity(
            title: success ? "Workflow Completed" : "Workflow Failed",
            description: name,
            icon: success ? "checkmark.circle.fill" : "xmark.circle.fill",
            color: success ? FlowColors.Status.success : FlowColors.Status.error,
            timestamp: Date()
        ), at: 0)
        
        if recentActivities.count > 10 {
            recentActivities = Array(recentActivities.prefix(10))
        }
    }
    
    func loadData() async {
        // Initialize with sample data
        systemHealthy = true
        workflowsRun = 12
        successRate = 94
        activeAgents = 2
        commandCount = 48
        
        workflowCount = 8
        projectCount = 3
        docCount = 24
        templateCount = 6
        
        workflowsTrend = .up("+3")
        successTrend = .up("+2%")
        
        systemServices = [
            SystemService(name: "Workflow Engine", status: "Running", isHealthy: true, responseTime: 12),
            SystemService(name: "Agent Manager", status: "Running", isHealthy: true, responseTime: 8),
            SystemService(name: "Command Library", status: "Loaded", isHealthy: true, responseTime: 5),
            SystemService(name: "Documentation Index", status: "Indexed", isHealthy: true, responseTime: 15),
            SystemService(name: "Analytics Engine", status: "Active", isHealthy: true, responseTime: 22)
        ]
        
        recentActivities = [
            RecentActivity(
                title: "Welcome to FlowKit",
                description: "Run a workflow or agent to see activity here",
                icon: "sparkles",
                color: FlowColors.Status.info,
                timestamp: Date()
            )
        ]
    }
}

// MARK: - Data Models

struct SystemService: Identifiable {
    let id = UUID()
    let name: String
    let status: String
    let isHealthy: Bool
    let responseTime: Double?
}

struct RecentActivity: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let timestamp: Date
}

// MARK: - Supporting Views

struct SystemStatusRow: View {
    let service: SystemService
    let colorScheme: ColorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(service.isHealthy ? FlowColors.Status.success.opacity(0.15) : FlowColors.Status.error.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: service.isHealthy ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(service.isHealthy ? FlowColors.Status.success : FlowColors.Status.error)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name)
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                HStack(spacing: 8) {
                    Text(service.status)
                        .font(FlowTypography.caption())
                        .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    
                    if let responseTime = service.responseTime {
                        Text("•")
                            .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                        Text("\(Int(responseTime))ms")
                            .font(FlowTypography.caption())
                            .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                    }
                }
            }
            
            Spacer()
            
            Text(service.isHealthy ? "Healthy" : "Issue")
                .font(FlowTypography.micro(.bold))
                .foregroundStyle(service.isHealthy ? FlowColors.Status.success : FlowColors.Status.error)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(service.isHealthy ? FlowColors.Status.success.opacity(0.15) : FlowColors.Status.error.opacity(0.15))
                )
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                .opacity(isHovered ? 1 : 0.5)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? FlowColors.Border.subtle(colorScheme).opacity(0.5) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

struct RecentsRow: View {
    let activity: RecentActivity
    let colorScheme: ColorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(activity.color.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: activity.icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(activity.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                Text(activity.description)
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(activity.timestamp, style: .relative)
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                
                Text(activity.timestamp, style: .time)
                    .font(FlowTypography.micro())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                .opacity(isHovered ? 1 : 0.5)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? FlowColors.Border.subtle(colorScheme).opacity(0.5) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Preview

#Preview("Dashboard - Dark") {
    DashboardView()
        .preferredColorScheme(.dark)
        .frame(width: 1000, height: 800)
}

#Preview("Dashboard - Light") {
    DashboardView()
        .preferredColorScheme(.light)
        .frame(width: 1000, height: 800)
}
