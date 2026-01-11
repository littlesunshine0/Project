//
//  AdaptivePanelEngine.swift
//  DataKit
//
//  Engine that analyzes usage patterns and generates panel recommendations
//  Pure logic - no SwiftUI, can be used by ML systems
//

import Foundation

/// Engine that analyzes panel usage and generates adaptive configurations
public struct AdaptivePanelEngine: Sendable {
    
    // MARK: - Analysis
    
    /// Analyze usage events and generate statistics
    public static func analyzeUsage(events: [PanelUsageEvent]) -> [SidebarContentTypeModel: PanelUsageStats] {
        var stats: [SidebarContentTypeModel: PanelUsageStats] = [:]
        
        // Initialize stats for all panel types
        for panelType in SidebarContentTypeModel.allCases {
            stats[panelType] = PanelUsageStats(panelType: panelType)
        }
        
        // Process events
        for event in events {
            guard var panelStats = stats[event.panelType] else { continue }
            
            if event.action == .opened {
                panelStats.totalOpens += 1
                panelStats.lastUsed = event.timestamp
                
                // Track time of day
                panelStats.usageByTimeOfDay[event.context.timeOfDay, default: 0] += 1
                
                // Track file type
                if let fileType = event.context.activeFileType {
                    panelStats.usageByFileType[fileType, default: 0] += 1
                }
                
                // Track nav item
                if let navItem = event.context.primaryNavItem {
                    panelStats.usageByNavItem[navItem, default: 0] += 1
                }
                
                // Track pairings
                for otherPanel in event.context.otherOpenPanels {
                    if let otherType = SidebarContentTypeModel(rawValue: otherPanel) {
                        panelStats.commonPairings[otherType, default: 0] += 1
                    }
                }
            }
            
            if let duration = event.duration {
                panelStats.totalDuration += duration
                if panelStats.totalOpens > 0 {
                    panelStats.averageDuration = panelStats.totalDuration / Double(panelStats.totalOpens)
                }
            }
            
            stats[event.panelType] = panelStats
        }
        
        return stats
    }
    
    /// Generate recommendations based on current context and usage stats
    public static func generateRecommendations(
        context: PanelContext,
        stats: [SidebarContentTypeModel: PanelUsageStats],
        currentPanels: [SidebarContentTypeModel],
        preferences: UserPanelPreferences
    ) -> [PanelRecommendation] {
        var recommendations: [PanelRecommendation] = []
        
        // Filter out hidden panels
        let availablePanels = SidebarContentTypeModel.allCases.filter { 
            !preferences.hiddenPanels.contains($0) 
        }
        
        // 1. Recommend panels based on file type
        if let fileType = context.activeFileType {
            let relevantPanels = availablePanels.filter { panel in
                guard let panelStats = stats[panel] else { return false }
                return (panelStats.usageByFileType[fileType] ?? 0) > 5
            }.sorted { panel1, panel2 in
                let score1 = stats[panel1]?.usageByFileType[fileType] ?? 0
                let score2 = stats[panel2]?.usageByFileType[fileType] ?? 0
                return score1 > score2
            }
            
            for panel in relevantPanels.prefix(2) where !currentPanels.contains(panel) {
                let confidence = min(Double(stats[panel]?.usageByFileType[fileType] ?? 0) / 50.0, 0.9)
                recommendations.append(PanelRecommendation(
                    type: .openPanel,
                    panels: [panel],
                    reason: "You often use \(panel.title) when editing \(fileType) files",
                    confidence: confidence,
                    context: context
                ))
            }
        }
        
        // 2. Recommend panels based on time of day
        let timeOfDay = context.timeOfDay
        let timeBasedPanels = availablePanels.filter { panel in
            guard let panelStats = stats[panel] else { return false }
            let timeUsage = panelStats.usageByTimeOfDay[timeOfDay] ?? 0
            let totalUsage = panelStats.usageByTimeOfDay.values.reduce(0, +)
            return totalUsage > 0 && Double(timeUsage) / Double(totalUsage) > 0.4
        }
        
        for panel in timeBasedPanels where !currentPanels.contains(panel) {
            recommendations.append(PanelRecommendation(
                type: .openPanel,
                panels: [panel],
                reason: "You typically use \(panel.title) during \(timeOfDay.rawValue)",
                confidence: 0.6,
                context: context
            ))
        }
        
        // 3. Recommend split pairings based on common usage
        if currentPanels.count == 1, let currentPanel = currentPanels.first {
            if let panelStats = stats[currentPanel] {
                let topPairings = panelStats.commonPairings
                    .sorted { $0.value > $1.value }
                    .prefix(3)
                
                for (pairedPanel, count) in topPairings where count > 3 {
                    let confidence = min(Double(count) / 20.0, 0.85)
                    recommendations.append(PanelRecommendation(
                        type: .splitPanels,
                        panels: [currentPanel, pairedPanel],
                        reason: "You often use \(currentPanel.title) with \(pairedPanel.title)",
                        confidence: confidence,
                        context: context
                    ))
                }
            }
        }
        
        // 4. Recommend based on nav item
        if let navItem = context.primaryNavItem {
            let navBasedPanels = availablePanels.filter { panel in
                guard let panelStats = stats[panel] else { return false }
                return (panelStats.usageByNavItem[navItem] ?? 0) > 3
            }
            
            for panel in navBasedPanels where !currentPanels.contains(panel) {
                recommendations.append(PanelRecommendation(
                    type: .openPanel,
                    panels: [panel],
                    reason: "You often use \(panel.title) when in \(navItem)",
                    confidence: 0.65,
                    context: context
                ))
            }
        }
        
        // Sort by confidence and deduplicate
        let uniqueRecommendations = Dictionary(grouping: recommendations) { $0.panels.map(\.rawValue).joined() }
            .compactMap { $0.value.max(by: { $0.confidence < $1.confidence }) }
            .sorted { $0.confidence > $1.confidence }
        
        return Array(uniqueRecommendations.prefix(5))
    }
    
    /// Generate an adaptive configuration based on usage patterns
    public static func generateAdaptiveConfig(
        stats: [SidebarContentTypeModel: PanelUsageStats],
        preferences: UserPanelPreferences
    ) -> AdaptivePanelConfig {
        // Sort panels by usage score
        let sortedPanels = stats.values
            .sorted { $0.usageScore > $1.usageScore }
            .map(\.panelType)
        
        // Top panels for right sidebar
        let rightSidebarPanels = sortedPanels
            .filter { !preferences.hiddenPanels.contains($0) }
            .prefix(6)
        
        // Determine default mode based on most used panel
        let defaultMode: RightSidebarModeModel
        if let topPanel = rightSidebarPanels.first {
            if topPanel == .chat {
                defaultMode = .single(.chat)
            } else {
                defaultMode = .single(topPanel)
            }
        } else {
            defaultMode = .minimized
        }
        
        // Find common pairings
        var pairings: [PanelPairing] = []
        for (panelType, panelStats) in stats {
            if let topPairing = panelStats.commonPairings.max(by: { $0.value < $1.value }) {
                if topPairing.value > 5 {
                    pairings.append(PanelPairing(first: panelType, second: topPairing.key))
                }
            }
        }
        
        // Calculate priorities
        var priorities: [String: Int] = [:]
        for (index, panel) in sortedPanels.enumerated() {
            priorities[panel.rawValue] = 100 - index
        }
        
        // Determine auto-show settings
        let chatStats = stats[.chat]
        let autoShowChat = (chatStats?.totalOpens ?? 0) > 50 && (chatStats?.averageDuration ?? 0) > 60
        
        return AdaptivePanelConfig(
            rightSidebarPanels: Array(rightSidebarPanels),
            bottomPanelTabs: [.terminal, .output, .problems, .debug],
            defaultRightSidebarMode: defaultMode,
            defaultBottomPanelTab: .terminal,
            autoShowChat: autoShowChat,
            autoShowTerminal: false,
            autoShowProblems: true,
            suggestedPairings: pairings,
            panelPriorities: priorities
        )
    }
    
    // MARK: - Contextual Suggestions
    
    /// Get contextual panel suggestion based on current activity
    public static func getContextualSuggestion(
        activeFile: String?,
        primaryNavItem: String?,
        recentActions: [String],
        stats: [SidebarContentTypeModel: PanelUsageStats]
    ) -> SidebarContentTypeModel? {
        // If editing code, suggest documentation or chat
        if let file = activeFile {
            let ext = (file as NSString).pathExtension.lowercased()
            if ["swift", "ts", "js", "py", "rs"].contains(ext) {
                // Check if user typically uses docs when coding
                if let docStats = stats[.documentation], docStats.usageScore > 30 {
                    return .documentation
                }
                // Otherwise suggest chat for help
                if let chatStats = stats[.chat], chatStats.usageScore > 20 {
                    return .chat
                }
            }
        }
        
        // If in workflows, suggest chat or walkthrough
        if primaryNavItem == "workflows" {
            return .walkthrough
        }
        
        // If recent actions include errors, suggest problems panel
        if recentActions.contains(where: { $0.contains("error") || $0.contains("fail") }) {
            return .notifications
        }
        
        return nil
    }
}
