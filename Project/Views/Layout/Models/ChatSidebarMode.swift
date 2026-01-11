//
//  ChatSidebarMode.swift
//  FlowKit
//
//  Chat sidebar display modes
//

import Foundation

public enum ChatSidebarMode: Equatable {
    case minimized  // Just icon strip
    case half       // Half width sidebar
    case full       // Full width sidebar
    
    public var width: CGFloat {
        switch self {
        case .minimized: return 60
        case .half: return 380
        case .full: return 500
        }
    }
    
    public var next: ChatSidebarMode {
        switch self {
        case .minimized: return .half
        case .half: return .full
        case .full: return .minimized
        }
    }
    
    public var previous: ChatSidebarMode {
        switch self {
        case .minimized: return .full
        case .half: return .minimized
        case .full: return .half
        }
    }
}
