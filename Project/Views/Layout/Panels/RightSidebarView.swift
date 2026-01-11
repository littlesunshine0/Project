//
//  RightSidebarView.swift
//  FlowKit
//
//  Right sidebar showing chat messages and/or other content
//  Can be split to show two contexts (e.g., chat + documentation)
//  Input is handled by the bottom FloatingInputPanel
//

import SwiftUI
import DesignKit

struct RightSidebarView: View {
    @ObservedObject var sidebarManager: RightSidebarManager
    @ObservedObject var inputPanelManager: InputPanelManager
    var forcedMode: RightSidebarMode? = nil
    @Environment(\.colorScheme) private var colorScheme
    
    /// The effective mode to display (forced or from manager)
    private var effectiveMode: RightSidebarMode {
        forcedMode ?? sidebarManager.mode
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with controls
            sidebarTopBar
            
            switch effectiveMode {
            case .minimized:
                EmptyView()
                
            case .single(let contentType):
                singleContentView(contentType)
                
            case .split(let top, let bottom):
                splitContentView(top: top, bottom: bottom)
                
            case .triple(let top, let middle, let bottom):
                tripleContentView(top: top, middle: middle, bottom: bottom)
                
            case .fullFloating(let contentType):
                floatingContentView(contentType)
                
            case .fullChat:
                fullChatView
            }
        }
        // Note: Parent handles background, corner radius, and shadow for floating effect
    }
    
    // MARK: - Top Bar
    
    private var sidebarTopBar: some View {
        HStack(spacing: 8) {
            // Expand/collapse button
            Button(action: {
                withAnimation(FlowMotion.standard) {
                    if sidebarManager.isFloating {
                        sidebarManager.collapse()
                    } else {
                        sidebarManager.expandToFull()
                    }
                }
            }) {
                Image(systemName: sidebarManager.isFloating ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Chat toggle button - shows chat panel
            Button(action: {
                withAnimation(FlowMotion.standard) {
                    sidebarManager.showChat()
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "bubble.right.fill")
                        .font(.system(size: 10, weight: .medium))
                    Text("Chat")
                        .font(FlowTypography.caption(.medium))
                }
                .foregroundStyle(isChatVisible ? SidebarContentType.chat.accentColor : FlowColors.Text.secondary(colorScheme))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(isChatVisible ? SidebarContentType.chat.accentColor.opacity(0.15) : FlowColors.Border.subtle(colorScheme))
                )
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Close button
            Button(action: { withAnimation(FlowMotion.standard) { sidebarManager.minimize() } }) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            VStack {
                Spacer()
                FlowColors.Border.subtle(colorScheme).opacity(0.5).frame(height: 1)
            }
        )
    }
    
    private var isChatVisible: Bool {
        switch sidebarManager.mode {
        case .single(.chat), .fullFloating(.chat):
            return true
        case .split(let top, let bottom):
            return top == .chat || bottom == .chat
        default:
            return false
        }
    }
    
    // MARK: - Single Content View
    
    private func singleContentView(_ type: SidebarContentType) -> some View {
        VStack(spacing: 0) {
            sidebarHeader(for: type, showSplitButton: true)
            
            contentView(for: type)
                .frame(maxHeight: .infinity)
        }
    }
    
    // MARK: - Split Content View
    
    private func splitContentView(top: SidebarContentType, bottom: SidebarContentType) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top content
                VStack(spacing: 0) {
                    sidebarHeader(for: top, showSplitButton: false, position: .top)
                    contentView(for: top)
                }
                .frame(height: geometry.size.height * sidebarManager.splitRatio)
                
                // Divider with drag handle
                splitDivider
                
                // Bottom content
                VStack(spacing: 0) {
                    sidebarHeader(for: bottom, showSplitButton: false, position: .bottom)
                    contentView(for: bottom)
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
    
    // MARK: - Triple Content View
    
    private func tripleContentView(top: SidebarContentType, middle: SidebarContentType, bottom: SidebarContentType) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top content
                VStack(spacing: 0) {
                    sidebarHeader(for: top, showSplitButton: false, position: .top)
                    contentView(for: top)
                }
                .frame(height: geometry.size.height * sidebarManager.middleSplitRatio)
                
                // First divider
                splitDivider
                
                // Middle content
                VStack(spacing: 0) {
                    sidebarHeader(for: middle, showSplitButton: false, position: .middle)
                    contentView(for: middle)
                }
                .frame(height: geometry.size.height * sidebarManager.middleSplitRatio)
                
                // Second divider
                splitDivider
                
                // Bottom content
                VStack(spacing: 0) {
                    sidebarHeader(for: bottom, showSplitButton: false, position: .bottom)
                    contentView(for: bottom)
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
    
    // MARK: - Floating Content View
    
    private func floatingContentView(_ type: SidebarContentType) -> some View {
        VStack(spacing: 0) {
            sidebarHeader(for: type, showSplitButton: true, isFloating: true)
            
            contentView(for: type)
                .frame(maxHeight: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.lg)
                .fill(FlowColors.Semantic.floating(colorScheme))
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.15), radius: 20, x: -4, y: 0)
        )
        .padding(.vertical, 12)
        .padding(.trailing, 12)
    }
    
    // MARK: - Full Chat View (Chat messages only - input is separate floating panel)
    
    private var fullChatView: some View {
        VStack(spacing: 0) {
            // Chat header with collapse button
            fullChatHeader
            
            // Chat messages area (input is now a separate floating panel below)
            ChatMessagesView(inputPanelManager: inputPanelManager)
                .frame(maxHeight: .infinity)
        }
    }
    
    private var fullChatHeader: some View {
        HStack(spacing: 10) {
            // Chat icon with glow
            ZStack {
                Circle()
                    .fill(SidebarContentType.chat.accentColor.opacity(0.2))
                    .frame(width: 28, height: 28)
                    .blur(radius: 3)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [SidebarContentType.chat.accentColor, SidebarContentType.chat.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Text("Chat")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Spacer()
            
            // Collapse to half
            PanelControlButton(icon: "arrow.down.right.and.arrow.up.left", color: SidebarContentType.chat.accentColor) {
                withAnimation(FlowMotion.standard) {
                    sidebarManager.collapse()
                }
            }
            
            // Close
            PanelControlButton(icon: "xmark", color: SidebarContentType.chat.accentColor) {
                withAnimation(FlowMotion.standard) {
                    sidebarManager.minimize()
                    inputPanelManager.hide()
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        SidebarContentType.chat.accentColor.opacity(colorScheme == .dark ? 0.06 : 0.03),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                VStack {
                    Spacer()
                    SidebarContentType.chat.accentColor.opacity(0.2).frame(height: 1)
                }
            }
        )
    }
    
    // MARK: - Header
    
    private func sidebarHeader(
        for type: SidebarContentType,
        showSplitButton: Bool,
        position: SplitPosition? = nil,
        isFloating: Bool = false
    ) -> some View {
        HStack(spacing: 10) {
            // Icon with accent
            ZStack {
                Circle()
                    .fill(type.accentColor.opacity(0.2))
                    .frame(width: 28, height: 28)
                    .blur(radius: 3)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [type.accentColor, type.accentColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                
                Image(systemName: type.icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            Text(type.title)
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Spacer()
            
            // Controls
            HStack(spacing: 4) {
                if showSplitButton {
                    // Split button
                    Menu {
                        ForEach(SidebarContentType.allCases.filter { $0 != type }) { otherType in
                            Button(action: {
                                sidebarManager.splitWith(top: type, bottom: otherType)
                            }) {
                                Label("Split with \(otherType.title)", systemImage: otherType.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "rectangle.split.1x2")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
                    }
                    .menuStyle(.borderlessButton)
                    .menuIndicator(.hidden)
                }
                
                // Expand/collapse for floating
                if isFloating {
                    PanelControlButton(icon: "arrow.down.right.and.arrow.up.left", color: type.accentColor) {
                        sidebarManager.collapse()
                    }
                } else if case .single = sidebarManager.mode {
                    PanelControlButton(icon: "arrow.up.left.and.arrow.down.right", color: type.accentColor) {
                        if type == .chat {
                            sidebarManager.expandChatToFull()
                        } else {
                            sidebarManager.expandContentToFull(type)
                        }
                    }
                }
                
                // Expand to full for split position (pushes other panel out)
                if let position = position {
                    // Expand this panel to full
                    PanelControlButton(icon: "arrow.up.left.and.arrow.down.right", color: type.accentColor) {
                        withAnimation(FlowMotion.standard) {
                            if type == .chat {
                                sidebarManager.expandChatToFull()
                            } else {
                                sidebarManager.expandContentToFull(type)
                            }
                        }
                    }
                    .help("Expand to full")
                    
                    // Close this panel
                    PanelControlButton(icon: "xmark", color: type.accentColor) {
                        closeSplitPanel(position: position)
                    }
                }
                
                // Minimize
                if position == nil {
                    PanelControlButton(icon: "chevron.right", color: type.accentColor) {
                        sidebarManager.minimize()
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            ZStack {
                LinearGradient(
                    colors: [
                        type.accentColor.opacity(colorScheme == .dark ? 0.06 : 0.03),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                
                VStack {
                    Spacer()
                    type.accentColor.opacity(0.2).frame(height: 1)
                }
            }
        )
    }
    
    // MARK: - Content Views
    
    @ViewBuilder
    private func contentView(for type: SidebarContentType) -> some View {
        switch type {
        // Assistant
        case .chat:
            ChatMessagesView(inputPanelManager: inputPanelManager)
        case .quickHelp:
            QuickHelpSidebarContent()
        case .suggestions:
            SuggestionsSidebarContent()
            
        // Inspection
        case .inspector:
            InspectorSidebarContent()
        case .preview:
            PreviewSidebarContent()
        case .diff:
            DiffSidebarContent()
        case .history:
            HistorySidebarContent()
            
        // Navigation
        case .symbols:
            SymbolsSidebarContent()
        case .references:
            ReferencesSidebarContent()
        case .bookmarks:
            BookmarksSidebarContent()
            
        // Notifications
        case .notifications:
            NotificationsSidebarContent()
        case .tasks:
            TasksSidebarContent()
            
        // Learning
        case .documentation:
            DocumentationSidebarContent()
        case .walkthrough:
            WalkthroughSidebarContent()
        case .snippets:
            SnippetsSidebarContent()
            
        // Legacy
        case .search:
            SearchSidebarContent()
        case .outline:
            SymbolsSidebarContent()  // Outline maps to symbols
        }
    }
    
    // MARK: - Split Divider
    
    private var splitDivider: some View {
        Rectangle()
            .fill(FlowColors.Border.medium(colorScheme))
            .frame(height: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .fill(FlowColors.Border.subtle(colorScheme))
                    .frame(width: 40, height: 4)
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Adjust split ratio based on drag
                        let delta = value.translation.height / 500
                        sidebarManager.splitRatio = max(0.2, min(0.8, sidebarManager.splitRatio + delta))
                    }
            )
            .onHover { if $0 { NSCursor.resizeUpDown.push() } else { NSCursor.pop() } }
    }
    
    // MARK: - Background
    
    private var sidebarBackground: some View {
        FlowColors.Semantic.surface(colorScheme)
    }
    
    // MARK: - Helpers
    
    private func closeSplitPanel(position: SplitPosition) {
        switch sidebarManager.mode {
        case .split(let top, let bottom):
            if position == .top {
                sidebarManager.mode = .single(bottom)
            } else {
                sidebarManager.mode = .single(top)
            }
        case .triple(let top, let middle, let bottom):
            switch position {
            case .top:
                sidebarManager.mode = .split(top: middle, bottom: bottom)
            case .middle:
                sidebarManager.mode = .split(top: top, bottom: bottom)
            case .bottom:
                sidebarManager.mode = .split(top: top, bottom: middle)
            }
        default:
            break
        }
    }
    
    enum SplitPosition {
        case top, middle, bottom
    }
}


// MARK: - Chat Messages View (Messages only, input is in bottom panel)

struct ChatMessagesView: View {
    @ObservedObject var inputPanelManager: InputPanelManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var messages: [ChatMessageItem] = []
    
    var body: some View {
        VStack(spacing: 0) {
            if messages.isEmpty {
                emptyState
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(messages) { message in
                                ChatMessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(14)
                    }
                    .onChange(of: messages.count) { _, _ in
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .chatMessageSent)) { notification in
            if let message = notification.userInfo?["message"] as? String {
                addUserMessage(message)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(SidebarContentType.chat.accentColor.opacity(0.15))
                    .frame(width: 64, height: 64)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 28))
                    .foregroundStyle(SidebarContentType.chat.accentColor)
            }
            
            Text("FlowKit Assistant")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Text("Ask me anything about your project,\ncode, or workflows.")
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func addUserMessage(_ text: String) {
        messages.append(ChatMessageItem(content: text, isUser: true))
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            messages.append(ChatMessageItem(
                content: "I received your message: \"\(text)\". How can I help you further?",
                isUser: false
            ))
        }
    }
}

struct ChatMessageItem: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp = Date()
}

struct ChatMessageBubble: View {
    let message: ChatMessageItem
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if !message.isUser {
                // AI avatar
                ZStack {
                    Circle()
                        .fill(SidebarContentType.chat.accentColor.opacity(0.15))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 12))
                        .foregroundStyle(SidebarContentType.chat.accentColor)
                }
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(FlowTypography.body())
                    .foregroundStyle(message.isUser ? .white : FlowColors.Text.primary(colorScheme))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: FlowRadius.md)
                            .fill(message.isUser ? SidebarContentType.chat.accentColor : FlowColors.Semantic.elevated(colorScheme))
                    )
                
                Text(message.timestamp, style: .time)
                    .font(FlowTypography.micro())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            .frame(maxWidth: 280, alignment: message.isUser ? .trailing : .leading)
            
            if message.isUser {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
    }
}

// MARK: - Documentation Sidebar Content

struct DocumentationSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                TextField("Search docs...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.sm)
                    .fill(FlowColors.Semantic.surface(colorScheme))
            )
            .padding(12)
            
            // Doc list
            ScrollView {
                VStack(spacing: 8) {
                    DocListItem(title: "Getting Started", icon: "book", isExpanded: true)
                    DocListItem(title: "Workflows Guide", icon: "arrow.triangle.branch", isExpanded: false)
                    DocListItem(title: "Agent Reference", icon: "cpu", isExpanded: false)
                    DocListItem(title: "API Documentation", icon: "doc.text", isExpanded: false)
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

struct DocListItem: View {
    let title: String
    let icon: String
    let isExpanded: Bool
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(SidebarContentType.documentation.accentColor)
            
            Text(title)
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? SidebarContentType.documentation.accentColor.opacity(0.08) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Walkthrough Sidebar Content

struct WalkthroughSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentStep = 0
    
    private let steps = [
        ("Welcome", "Let's get you started with FlowKit"),
        ("Create Workflow", "Build your first automation"),
        ("Run Agent", "Execute AI-powered tasks"),
        ("Explore", "Discover more features")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress
            HStack(spacing: 4) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentStep ? SidebarContentType.walkthrough.accentColor : FlowColors.Border.subtle(colorScheme))
                        .frame(height: 4)
                }
            }
            .padding(12)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Current step
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Step \(currentStep + 1) of \(steps.count)")
                            .font(FlowTypography.micro(.bold))
                            .foregroundStyle(SidebarContentType.walkthrough.accentColor)
                        
                        Text(steps[currentStep].0)
                            .font(FlowTypography.title3())
                            .foregroundStyle(FlowColors.Text.primary(colorScheme))
                        
                        Text(steps[currentStep].1)
                            .font(FlowTypography.body())
                            .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: FlowRadius.md)
                            .fill(SidebarContentType.walkthrough.accentColor.opacity(0.08))
                    )
                }
                .padding(12)
            }
            
            // Navigation
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        currentStep -= 1
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                }
                
                Spacer()
                
                Button(currentStep < steps.count - 1 ? "Next" : "Done") {
                    if currentStep < steps.count - 1 {
                        currentStep += 1
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(SidebarContentType.walkthrough.accentColor)
            }
            .padding(12)
        }
    }
}

// MARK: - Preview Sidebar Content

struct PreviewSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "eye.slash")
                .font(.system(size: 36))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            Text("No Preview")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Text("Select a file to preview")
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Inspector Sidebar Content

struct InspectorSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                InspectorSection(title: "Properties") {
                    InspectorRow(label: "Name", value: "MyWorkflow")
                    InspectorRow(label: "Type", value: "Automation")
                    InspectorRow(label: "Status", value: "Active")
                }
                
                InspectorSection(title: "Statistics") {
                    InspectorRow(label: "Runs", value: "42")
                    InspectorRow(label: "Success Rate", value: "94%")
                    InspectorRow(label: "Avg Duration", value: "2.3s")
                }
            }
            .padding(12)
        }
    }
}

struct InspectorSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(FlowTypography.micro(.bold))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                .tracking(1)
            
            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: FlowRadius.sm)
                    .fill(FlowColors.Semantic.surface(colorScheme))
            )
        }
    }
}

struct InspectorRow: View {
    let label: String
    let value: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Text(label)
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Spacer()
            
            Text(value)
                .font(FlowTypography.caption(.medium))
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

// MARK: - Notifications Sidebar Content

struct NotificationsSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var notifications: [NotificationItem] = NotificationItem.sampleNotifications
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with clear all
            HStack {
                Text("\(notifications.count) notifications")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                
                Spacer()
                
                if !notifications.isEmpty {
                    Button("Clear All") {
                        withAnimation { notifications.removeAll() }
                    }
                    .font(FlowTypography.caption(.medium))
                    .foregroundStyle(SidebarContentType.notifications.accentColor)
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(FlowColors.Border.subtle(colorScheme).opacity(0.5))
            
            if notifications.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(notifications) { notification in
                            NotificationRow(notification: notification) {
                                withAnimation {
                                    notifications.removeAll { $0.id == notification.id }
                                }
                            }
                        }
                    }
                    .padding(12)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(SidebarContentType.notifications.accentColor.opacity(0.15))
                    .frame(width: 64, height: 64)
                
                Image(systemName: "bell.slash")
                    .font(.system(size: 28))
                    .foregroundStyle(SidebarContentType.notifications.accentColor)
            }
            
            Text("All Caught Up")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Text("No new notifications")
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let icon: String
    let color: Color
    let timestamp: Date
    let isRead: Bool
    
    static var sampleNotifications: [NotificationItem] {
        [
            NotificationItem(
                title: "Workflow Completed",
                message: "Build & Test workflow finished successfully",
                icon: "checkmark.circle.fill",
                color: FlowColors.Status.success,
                timestamp: Date().addingTimeInterval(-300),
                isRead: false
            ),
            NotificationItem(
                title: "Agent Update",
                message: "Code Review Agent has new capabilities",
                icon: "cpu.fill",
                color: FlowColors.Category.agents,
                timestamp: Date().addingTimeInterval(-3600),
                isRead: false
            ),
            NotificationItem(
                title: "System Alert",
                message: "Memory usage is above 80%",
                icon: "exclamationmark.triangle.fill",
                color: FlowColors.Status.warning,
                timestamp: Date().addingTimeInterval(-7200),
                isRead: true
            )
        ]
    }
}

struct NotificationRow: View {
    let notification: NotificationItem
    let onDismiss: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(notification.color.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: notification.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(notification.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(FlowTypography.body(.medium))
                        .foregroundStyle(FlowColors.Text.primary(colorScheme))
                    
                    if !notification.isRead {
                        Circle()
                            .fill(SidebarContentType.notifications.accentColor)
                            .frame(width: 6, height: 6)
                    }
                }
                
                Text(notification.message)
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                    .lineLimit(2)
                
                Text(notification.timestamp, style: .relative)
                    .font(FlowTypography.micro())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
            
            // Dismiss button
            if isHovered {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                        .frame(width: 20, height: 20)
                        .background(Circle().fill(FlowColors.Border.subtle(colorScheme)))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.md)
                .fill(isHovered ? notification.color.opacity(0.05) : FlowColors.Semantic.surface(colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: FlowRadius.md)
                        .strokeBorder(FlowColors.Border.subtle(colorScheme), lineWidth: 1)
                )
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Quick Help Sidebar Content

struct QuickHelpSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "questionmark.circle")
                .font(.system(size: 36))
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            Text("Quick Help")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Text("Select a symbol to see documentation")
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Suggestions Sidebar Content

struct SuggestionsSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var suggestions: [SuggestionItem] = SuggestionItem.samples
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(suggestions) { suggestion in
                    SuggestionRow(suggestion: suggestion)
                }
            }
            .padding(12)
        }
    }
}

struct SuggestionItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let type: SuggestionType
    
    enum SuggestionType { case code, refactor, performance, style }
    
    static var samples: [SuggestionItem] {
        [
            SuggestionItem(title: "Extract Method", description: "Extract selected code into a new method", icon: "arrow.up.doc", type: .refactor),
            SuggestionItem(title: "Add Documentation", description: "Generate documentation for this function", icon: "doc.text", type: .code),
            SuggestionItem(title: "Optimize Loop", description: "Use map instead of for loop", icon: "bolt", type: .performance)
        ]
    }
}

struct SuggestionRow: View {
    let suggestion: SuggestionItem
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: suggestion.icon)
                .font(.system(size: 14))
                .foregroundStyle(FlowColors.Category.chat)
                .frame(width: 28, height: 28)
                .background(Circle().fill(FlowColors.Category.chat.opacity(0.15)))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(suggestion.title)
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                Text(suggestion.description)
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            }
            
            Spacer()
            
            if isHovered {
                Button("Apply") {}
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .tint(FlowColors.Category.chat)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? FlowColors.Category.chat.opacity(0.08) : FlowColors.Semantic.surface(colorScheme))
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Diff Sidebar Content

struct DiffSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 36))
                .foregroundStyle(FlowColors.Category.agents)
            
            Text("No Changes")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Text("Select a file to view changes")
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - History Sidebar Content

struct HistorySidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var historyItems: [HistoryItem] = HistoryItem.samples
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(historyItems) { item in
                    HistoryRow(item: item)
                }
            }
            .padding(12)
        }
    }
}

struct HistoryItem: Identifiable {
    let id = UUID()
    let title: String
    let timestamp: Date
    let author: String
    let changeCount: Int
    
    static var samples: [HistoryItem] {
        [
            HistoryItem(title: "Updated layout", timestamp: Date().addingTimeInterval(-3600), author: "You", changeCount: 12),
            HistoryItem(title: "Fixed bug", timestamp: Date().addingTimeInterval(-7200), author: "You", changeCount: 3),
            HistoryItem(title: "Initial commit", timestamp: Date().addingTimeInterval(-86400), author: "You", changeCount: 45)
        ]
    }
}

struct HistoryRow: View {
    let item: HistoryItem
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(FlowColors.Status.info)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                HStack(spacing: 4) {
                    Text(item.author)
                    Text("•")
                    Text(item.timestamp, style: .relative)
                }
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
            
            Text("+\(item.changeCount)")
                .font(FlowTypography.micro(.bold))
                .foregroundStyle(FlowColors.Status.success)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? FlowColors.Status.info.opacity(0.08) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Symbols Sidebar Content

struct SymbolsSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var symbols: [SymbolItem] = SymbolItem.samples
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                TextField("Filter symbols...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: FlowRadius.sm).fill(FlowColors.Semantic.surface(colorScheme)))
            .padding(12)
            
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(symbols) { symbol in
                        SymbolRow(symbol: symbol)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

struct SymbolItem: Identifiable {
    let id = UUID()
    let name: String
    let kind: SymbolKind
    let line: Int
    
    enum SymbolKind: String { case `class`, `func`, `var`, `struct`, `enum`, `protocol` }
    
    var icon: String {
        switch kind {
        case .class: return "c.square"
        case .func: return "f.square"
        case .var: return "v.square"
        case .struct: return "s.square"
        case .enum: return "e.square"
        case .protocol: return "p.square"
        }
    }
    
    static var samples: [SymbolItem] {
        [
            SymbolItem(name: "RightSidebarView", kind: .struct, line: 12),
            SymbolItem(name: "body", kind: .var, line: 18),
            SymbolItem(name: "sidebarTopBar", kind: .var, line: 45),
            SymbolItem(name: "contentView(for:)", kind: .func, line: 120)
        ]
    }
}

struct SymbolRow: View {
    let symbol: SymbolItem
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol.icon)
                .font(.system(size: 12))
                .foregroundStyle(FlowColors.Status.info)
            
            Text(symbol.name)
                .font(FlowTypography.body())
                .foregroundStyle(FlowColors.Text.primary(colorScheme))
            
            Spacer()
            
            Text(":\(symbol.line)")
                .font(FlowTypography.micro())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.xs)
                .fill(isHovered ? FlowColors.Status.info.opacity(0.1) : Color.clear)
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - References Sidebar Content

struct ReferencesSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "link")
                .font(.system(size: 36))
                .foregroundStyle(FlowColors.Status.info)
            
            Text("No References")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            
            Text("Select a symbol to find references")
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Bookmarks Sidebar Content

struct BookmarksSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var bookmarks: [BookmarkItem] = BookmarkItem.samples
    
    var body: some View {
        VStack(spacing: 0) {
            if bookmarks.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(bookmarks) { bookmark in
                            BookmarkRow(bookmark: bookmark)
                        }
                    }
                    .padding(12)
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "bookmark")
                .font(.system(size: 36))
                .foregroundStyle(FlowColors.Status.warning)
            Text("No Bookmarks")
                .font(FlowTypography.headline())
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            Text("Add bookmarks to quickly navigate")
                .font(FlowTypography.caption())
                .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct BookmarkItem: Identifiable {
    let id = UUID()
    let name: String
    let file: String
    let line: Int
    
    static var samples: [BookmarkItem] {
        [
            BookmarkItem(name: "Main Entry", file: "ContentView.swift", line: 15),
            BookmarkItem(name: "API Handler", file: "NetworkService.swift", line: 42)
        ]
    }
}

struct BookmarkRow: View {
    let bookmark: BookmarkItem
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "bookmark.fill")
                .font(.system(size: 12))
                .foregroundStyle(FlowColors.Status.warning)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(bookmark.name)
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                Text("\(bookmark.file):\(bookmark.line)")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
            }
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? FlowColors.Status.warning.opacity(0.1) : FlowColors.Semantic.surface(colorScheme))
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Tasks Sidebar Content

struct TasksSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var tasks: [TaskItem] = TaskItem.samples
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("\(tasks.filter { $0.isRunning }.count) running")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(FlowColors.Border.subtle(colorScheme).opacity(0.5))
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(tasks) { task in
                        TaskRow(task: task)
                    }
                }
                .padding(12)
            }
        }
    }
}

struct TaskItem: Identifiable {
    let id = UUID()
    let name: String
    let status: TaskStatus
    let progress: Double?
    
    var isRunning: Bool { status == .running }
    
    enum TaskStatus { case running, completed, failed, queued }
    
    static var samples: [TaskItem] {
        [
            TaskItem(name: "Building...", status: .running, progress: 0.65),
            TaskItem(name: "Run Tests", status: .queued, progress: nil),
            TaskItem(name: "Lint Check", status: .completed, progress: nil)
        ]
    }
}

struct TaskRow: View {
    let task: TaskItem
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 10) {
            statusIcon
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.name)
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                
                if let progress = task.progress {
                    ProgressView(value: progress)
                        .tint(FlowColors.Category.workflows)
                }
            }
            
            Spacer()
            
            if task.isRunning {
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: FlowRadius.sm).fill(FlowColors.Semantic.surface(colorScheme)))
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        switch task.status {
        case .running:
            ProgressView().controlSize(.small)
        case .completed:
            Image(systemName: "checkmark.circle.fill").foregroundStyle(FlowColors.Status.success)
        case .failed:
            Image(systemName: "xmark.circle.fill").foregroundStyle(FlowColors.Status.error)
        case .queued:
            Image(systemName: "clock").foregroundStyle(FlowColors.Text.tertiary(colorScheme))
        }
    }
}

// MARK: - Snippets Sidebar Content

struct SnippetsSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var snippets: [SnippetItem] = SnippetItem.samples
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Search
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                TextField("Search snippets...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: FlowRadius.sm).fill(FlowColors.Semantic.surface(colorScheme)))
            .padding(12)
            
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(snippets) { snippet in
                        SnippetRow(snippet: snippet)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
}

struct SnippetItem: Identifiable {
    let id = UUID()
    let name: String
    let language: String
    let preview: String
    
    static var samples: [SnippetItem] {
        [
            SnippetItem(name: "SwiftUI View", language: "Swift", preview: "struct MyView: View { ... }"),
            SnippetItem(name: "Async Function", language: "Swift", preview: "func fetch() async throws { ... }"),
            SnippetItem(name: "Observable", language: "Swift", preview: "@Observable class Model { ... }")
        ]
    }
}

struct SnippetRow: View {
    let snippet: SnippetItem
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(snippet.name)
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                Spacer()
                Text(snippet.language)
                    .font(FlowTypography.micro())
                    .foregroundStyle(FlowColors.Category.commands)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(FlowColors.Category.commands.opacity(0.15)))
            }
            
            Text(snippet.preview)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                .lineLimit(1)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: FlowRadius.sm)
                .fill(isHovered ? FlowColors.Category.commands.opacity(0.08) : FlowColors.Semantic.surface(colorScheme))
        )
        .onHover { isHovered = $0 }
    }
}

// MARK: - Search Sidebar Content

struct SearchSidebarContent: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Search input
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                TextField("Search in workspace...", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: FlowRadius.sm).fill(FlowColors.Semantic.surface(colorScheme)))
            .padding(12)
            
            if searchText.isEmpty {
                Spacer()
                Text("Enter a search term")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.tertiary(colorScheme))
                Spacer()
            } else {
                ScrollView {
                    Text("Results for \"\(searchText)\"")
                        .font(FlowTypography.caption())
                        .foregroundStyle(FlowColors.Text.secondary(colorScheme))
                        .padding(12)
                }
            }
        }
    }
}
