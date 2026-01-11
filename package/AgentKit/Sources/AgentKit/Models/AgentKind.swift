//
//  AgentKind.swift
//  AgentKit
//

import Foundation

public enum AgentKind: String, CaseIterable, Codable, Sendable {
    case reactive = "Reactive"
    case proactive = "Proactive"
    case scheduled = "Scheduled"
    case triggered = "Triggered"
    case continuous = "Continuous"
    
    public var icon: String {
        switch self {
        case .reactive: return "bolt"
        case .proactive: return "sparkles"
        case .scheduled: return "calendar.badge.clock"
        case .triggered: return "bell"
        case .continuous: return "repeat"
        }
    }
    
    public var description: String {
        switch self {
        case .reactive: return "Responds to events"
        case .proactive: return "Anticipates needs"
        case .scheduled: return "Runs on schedule"
        case .triggered: return "Activated by triggers"
        case .continuous: return "Always running"
        }
    }
}
