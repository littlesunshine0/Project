//
//  AgentIcon.swift
//  AgentKit
//

import SwiftUI

public struct AgentIcon: View {
    public let agent: Agent
    public var size: Size
    
    public init(agent: Agent, size: Size = .medium) {
        self.agent = agent
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(color.gradient)
            
            Image(systemName: agent.type.icon)
                .font(size.font)
                .foregroundStyle(.white)
        }
        .frame(width: size.dimension, height: size.dimension)
    }
    
    private var color: Color {
        switch agent.type {
        case .task: return .blue
        case .monitor: return .green
        case .automation: return .purple
        case .assistant: return .orange
        case .scheduler: return .cyan
        case .watcher: return .yellow
        case .builder: return .red
        case .deployer: return .indigo
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
