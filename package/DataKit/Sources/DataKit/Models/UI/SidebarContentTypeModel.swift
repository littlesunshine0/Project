//
//  SidebarContentTypeModel.swift
//  DataKit
//
//  Content types that can appear in the right sidebar
//  These are semantic models - ML can reason about them, validate them, automate them
//

import Foundation

/// Content types that can appear in the right sidebar
/// Each type represents a distinct capability that can share space with others
public enum SidebarContentTypeModel: String, CaseIterable, Identifiable, Codable, Sendable {
    case notifications
    case chat
    case documentation
    case walkthrough
    case preview
    case inspector
    case search
    case history
    case bookmarks
    case outline
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .notifications: return "Notifications"
        case .chat: return "Chat"
        case .documentation: return "Documentation"
        case .walkthrough: return "Walkthrough"
        case .preview: return "Preview"
        case .inspector: return "Inspector"
        case .search: return "Search"
        case .history: return "History"
        case .bookmarks: return "Bookmarks"
        case .outline: return "Outline"
        }
    }
    
    public var icon: String {
        switch self {
        case .notifications: return "bell.fill"
        case .chat: return "bubble.left.and.bubble.right"
        case .documentation: return "book"
        case .walkthrough: return "list.bullet.clipboard"
        case .preview: return "eye"
        case .inspector: return "sidebar.right"
        case .search: return "magnifyingglass"
        case .history: return "clock.arrow.circlepath"
        case .bookmarks: return "bookmark.fill"
        case .outline: return "list.bullet.indent"
        }
    }
    
    /// Color category for theming (maps to FlowColors in SwiftUI layer)
    public var colorCategory: String {
        switch self {
        case .notifications: return "warning"
        case .chat: return "chat"
        case .documentation: return "documentation"
        case .walkthrough: return "info"
        case .preview: return "projects"
        case .inspector: return "neutral"
        case .search: return "search"
        case .history: return "info"
        case .bookmarks: return "warning"
        case .outline: return "neutral"
        }
    }
    
    /// Whether this content type supports being in a split view
    public var supportsSplit: Bool {
        switch self {
        case .chat, .notifications, .documentation, .walkthrough, .search, .history, .bookmarks, .outline:
            return true
        case .preview, .inspector:
            return true
        }
    }
    
    /// Whether this content type can expand to full sidebar
    public var supportsFullExpand: Bool {
        switch self {
        case .chat, .documentation, .preview, .inspector:
            return true
        case .notifications, .walkthrough, .search, .history, .bookmarks, .outline:
            return false
        }
    }
    
    /// Default minimum height for this content type
    public var defaultMinHeight: Double {
        switch self {
        case .chat: return 200
        case .notifications: return 120
        case .documentation: return 150
        case .walkthrough: return 180
        case .preview: return 200
        case .inspector: return 150
        case .search: return 100
        case .history: return 100
        case .bookmarks: return 100
        case .outline: return 120
        }
    }
    
    /// Suggested content types to pair with in split view
    public var suggestedPairings: [SidebarContentTypeModel] {
        switch self {
        case .chat:
            return [.notifications, .documentation, .walkthrough]
        case .notifications:
            return [.chat]
        case .documentation:
            return [.chat, .preview, .outline]
        case .walkthrough:
            return [.chat]
        case .preview:
            return [.inspector, .documentation]
        case .inspector:
            return [.preview]
        case .search:
            return [.chat, .documentation]
        case .history:
            return [.chat]
        case .bookmarks:
            return [.documentation]
        case .outline:
            return [.documentation, .preview]
        }
    }
    
    /// Priority for space allocation (higher = more important)
    public var defaultPriority: Int {
        switch self {
        case .chat: return 10
        case .notifications: return 8
        case .documentation: return 7
        case .walkthrough: return 9
        case .preview: return 6
        case .inspector: return 5
        case .search: return 4
        case .history: return 3
        case .bookmarks: return 2
        case .outline: return 1
        }
    }
}
