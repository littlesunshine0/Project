//
//  RightSidebarModeModel.swift
//  DataKit
//
//  Mode for the right sidebar - describes the layout state
//  This is a semantic model that ML can reason about
//

import Foundation

/// Mode for the right sidebar - describes the layout state
/// Panels share space without overlapping - they never touch each other
public enum RightSidebarModeModel: Equatable, Codable, Sendable {
    /// Sidebar is hidden/minimized
    case minimized
    /// Single content taking full height
    case single(SidebarContentTypeModel)
    /// Split view - top and bottom content (with gap between)
    case split(top: SidebarContentTypeModel, bottom: SidebarContentTypeModel)
    /// Triple split - three panels stacked (with gaps between)
    case triple(top: SidebarContentTypeModel, middle: SidebarContentTypeModel, bottom: SidebarContentTypeModel)
    /// Full floating sidebar (non-chat content) - expanded mode
    case fullFloating(SidebarContentTypeModel)
    /// Full chat mode - chat takes full height and includes input panel as a unit
    case fullChat
    
    public var isVisible: Bool {
        if case .minimized = self { return false }
        return true
    }
    
    public var isFloating: Bool {
        switch self {
        case .fullFloating, .fullChat:
            return true
        default:
            return false
        }
    }
    
    public var isFullChatMode: Bool {
        if case .fullChat = self { return true }
        return false
    }
    
    /// All content types currently visible in this mode
    public var visibleContentTypes: [SidebarContentTypeModel] {
        switch self {
        case .minimized:
            return []
        case .single(let type):
            return [type]
        case .split(let top, let bottom):
            return [top, bottom]
        case .triple(let top, let middle, let bottom):
            return [top, middle, bottom]
        case .fullFloating(let type):
            return [type]
        case .fullChat:
            return [.chat]
        }
    }
    
    /// Number of panels visible
    public var panelCount: Int {
        visibleContentTypes.count
    }
    
    /// Check if a specific content type is visible
    public func isShowing(_ type: SidebarContentTypeModel) -> Bool {
        visibleContentTypes.contains(type)
    }
    
    /// Get the position of a content type (nil if not visible)
    public func position(of type: SidebarContentTypeModel) -> SidebarPanelPosition? {
        switch self {
        case .minimized:
            return nil
        case .single(let t):
            return t == type ? .full : nil
        case .split(let top, let bottom):
            if top == type { return .top }
            if bottom == type { return .bottom }
            return nil
        case .triple(let top, let middle, let bottom):
            if top == type { return .top }
            if middle == type { return .middle }
            if bottom == type { return .bottom }
            return nil
        case .fullFloating(let t):
            return t == type ? .full : nil
        case .fullChat:
            return type == .chat ? .full : nil
        }
    }
}

/// Position of a panel within the sidebar
public enum SidebarPanelPosition: String, Codable, Sendable {
    case full
    case top
    case middle
    case bottom
    
    public var title: String {
        switch self {
        case .full: return "Full"
        case .top: return "Top"
        case .middle: return "Middle"
        case .bottom: return "Bottom"
        }
    }
}
