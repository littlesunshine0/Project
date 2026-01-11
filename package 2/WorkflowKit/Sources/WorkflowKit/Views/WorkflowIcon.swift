//
//  WorkflowIcon.swift
//  WorkflowKit
//

import SwiftUI

public struct WorkflowIcon: View {
    public let workflow: Workflow
    public var size: Size
    
    public init(workflow: Workflow, size: Size = .medium) {
        self.workflow = workflow
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(color.gradient)
            
            Image(systemName: workflow.category.icon)
                .font(size.font)
                .foregroundStyle(.white)
        }
        .frame(width: size.dimension, height: size.dimension)
    }
    
    private var color: Color {
        switch workflow.category {
        case .all: return .gray
        case .general: return .blue
        case .development: return .purple
        case .testing: return .green
        case .documentation: return .orange
        case .deployment: return .red
        case .systemAdmin: return .gray
        case .analytics: return .cyan
        case .automation: return .indigo
        case .collaboration: return .pink
        case .database: return .brown
        case .api: return .teal
        case .git: return .orange
        case .build: return .yellow
        case .debug: return .red
        case .security: return .gray
        case .performance: return .green
        case .ui: return .purple
        case .backend: return .blue
        case .mobile: return .cyan
        case .web: return .indigo
        case .cloud: return .blue
        case .ai: return .purple
        }
    }
    
    public enum Size {
        case small, medium, large
        
        var dimension: CGFloat {
            switch self {
            case .small: return 24
            case .medium: return 40
            case .large: return 64
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 8
            case .large: return 12
            }
        }
        
        var font: Font {
            switch self {
            case .small: return .caption
            case .medium: return .title3
            case .large: return .title
            }
        }
    }
}
