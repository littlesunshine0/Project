//
//  ProjectIconType.swift
//  IconKit
//
//  Enum for project-specific custom icons
//

import SwiftUI

/// Enum for project-specific icons
public enum ProjectIconType: String, CaseIterable, Identifiable, Sendable {
    case flowKit = "FlowKit"
    case ideaKit = "IdeaKit"
    case iconKit = "IconKit"
    
    public var id: String { rawValue }
    
    public var displayName: String { rawValue }
    
    public var description: String {
        switch self {
        case .flowKit: return "Main FlowKit Application"
        case .ideaKit: return "Project Operating System"
        case .iconKit: return "Universal Icon System"
        }
    }
    
    @MainActor @ViewBuilder
    public func icon(size: CGFloat, variant: IconVariantType = .inApp) -> some View {
        switch self {
        case .flowKit:
            FlowKitIcon(size: size, variant: variant)
        case .ideaKit:
            IdeaKitIcon(size: size, variant: variant)
        case .iconKit:
            IconKitIcon(size: size, variant: variant)
        }
    }
    
    @MainActor @ViewBuilder
    public func animatedIcon(size: CGFloat) -> some View {
        switch self {
        case .flowKit:
            FlowKitIconAnimated(size: size)
        case .ideaKit:
            IdeaKitIconAnimated(size: size)
        case .iconKit:
            IconKitIconAnimated(size: size)
        }
    }
}
