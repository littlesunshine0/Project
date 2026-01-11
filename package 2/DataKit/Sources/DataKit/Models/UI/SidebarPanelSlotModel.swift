//
//  SidebarPanelSlotModel.swift
//  DataKit
//
//  Defines panel slots for the right sidebar - panels share space without overlapping
//  This model is ML-visible and can be reasoned about, validated, and automated
//

import Foundation

/// A slot in the sidebar that can hold content
/// Panels never touch - they share space with proper separation
public struct SidebarPanelSlotModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public var contentType: SidebarContentTypeModel
    public var heightRatio: Double  // 0.0 to 1.0, relative to available space
    public var minHeight: Double    // Minimum height in points
    public var maxHeight: Double?   // Optional maximum height
    public var isCollapsed: Bool
    public var priority: Int        // Higher priority panels get space first
    
    public init(
        id: String = UUID().uuidString,
        contentType: SidebarContentTypeModel,
        heightRatio: Double = 0.5,
        minHeight: Double = 100,
        maxHeight: Double? = nil,
        isCollapsed: Bool = false,
        priority: Int = 0
    ) {
        self.id = id
        self.contentType = contentType
        self.heightRatio = max(0, min(1, heightRatio))
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.isCollapsed = isCollapsed
        self.priority = priority
    }
}

/// Configuration for the entire sidebar panel system
public struct SidebarPanelConfigModel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public var slots: [SidebarPanelSlotModel]
    public var gapBetweenPanels: Double
    public var edgeInset: Double
    public var cornerRadius: Double
    public var animationDuration: Double
    
    public init(
        id: String = UUID().uuidString,
        slots: [SidebarPanelSlotModel] = [],
        gapBetweenPanels: Double = 12,
        edgeInset: Double = 12,
        cornerRadius: Double = 16,
        animationDuration: Double = 0.35
    ) {
        self.id = id
        self.slots = slots
        self.gapBetweenPanels = gapBetweenPanels
        self.edgeInset = edgeInset
        self.cornerRadius = cornerRadius
        self.animationDuration = animationDuration
    }
    
    /// Total number of visible (non-collapsed) slots
    public var visibleSlotCount: Int {
        slots.filter { !$0.isCollapsed }.count
    }
    
    /// Calculate height ratios ensuring they sum to 1.0
    public func normalizedHeightRatios() -> [String: Double] {
        let visibleSlots = slots.filter { !$0.isCollapsed }
        let totalRatio = visibleSlots.reduce(0) { $0 + $1.heightRatio }
        guard totalRatio > 0 else { return [:] }
        
        var result: [String: Double] = [:]
        for slot in visibleSlots {
            result[slot.id] = slot.heightRatio / totalRatio
        }
        return result
    }
    
    /// Add a new slot
    public mutating func addSlot(_ slot: SidebarPanelSlotModel) {
        // Don't add duplicate content types
        guard !slots.contains(where: { $0.contentType == slot.contentType }) else { return }
        slots.append(slot)
        normalizeRatios()
    }
    
    /// Remove a slot by content type
    public mutating func removeSlot(contentType: SidebarContentTypeModel) {
        slots.removeAll { $0.contentType == contentType }
        normalizeRatios()
    }
    
    /// Normalize height ratios to sum to 1.0
    private mutating func normalizeRatios() {
        let visibleSlots = slots.filter { !$0.isCollapsed }
        guard !visibleSlots.isEmpty else { return }
        
        let totalRatio = visibleSlots.reduce(0) { $0 + $1.heightRatio }
        guard totalRatio > 0 else { return }
        
        for i in slots.indices {
            if !slots[i].isCollapsed {
                slots[i].heightRatio = slots[i].heightRatio / totalRatio
            }
        }
    }
}

/// Preset configurations for common sidebar layouts
public enum SidebarPresetModel: String, CaseIterable, Codable, Sendable {
    case chatOnly
    case chatWithNotifications
    case documentationFocus
    case inspectorMode
    case walkthroughMode
    case splitChatDocs
    
    public var title: String {
        switch self {
        case .chatOnly: return "Chat Only"
        case .chatWithNotifications: return "Chat + Notifications"
        case .documentationFocus: return "Documentation Focus"
        case .inspectorMode: return "Inspector Mode"
        case .walkthroughMode: return "Walkthrough Mode"
        case .splitChatDocs: return "Chat + Documentation"
        }
    }
    
    public var config: SidebarPanelConfigModel {
        switch self {
        case .chatOnly:
            return SidebarPanelConfigModel(slots: [
                SidebarPanelSlotModel(contentType: .chat, heightRatio: 1.0, priority: 1)
            ])
            
        case .chatWithNotifications:
            return SidebarPanelConfigModel(slots: [
                SidebarPanelSlotModel(contentType: .notifications, heightRatio: 0.3, minHeight: 150, priority: 2),
                SidebarPanelSlotModel(contentType: .chat, heightRatio: 0.7, minHeight: 200, priority: 1)
            ])
            
        case .documentationFocus:
            return SidebarPanelConfigModel(slots: [
                SidebarPanelSlotModel(contentType: .documentation, heightRatio: 1.0, priority: 1)
            ])
            
        case .inspectorMode:
            return SidebarPanelConfigModel(slots: [
                SidebarPanelSlotModel(contentType: .inspector, heightRatio: 0.6, priority: 1),
                SidebarPanelSlotModel(contentType: .preview, heightRatio: 0.4, priority: 2)
            ])
            
        case .walkthroughMode:
            return SidebarPanelConfigModel(slots: [
                SidebarPanelSlotModel(contentType: .walkthrough, heightRatio: 0.5, priority: 1),
                SidebarPanelSlotModel(contentType: .chat, heightRatio: 0.5, priority: 2)
            ])
            
        case .splitChatDocs:
            return SidebarPanelConfigModel(slots: [
                SidebarPanelSlotModel(contentType: .documentation, heightRatio: 0.5, priority: 1),
                SidebarPanelSlotModel(contentType: .chat, heightRatio: 0.5, priority: 2)
            ])
        }
    }
}
