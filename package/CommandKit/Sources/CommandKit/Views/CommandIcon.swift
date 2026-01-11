//
//  CommandIcon.swift
//  CommandKit
//

import SwiftUI

public struct CommandIcon: View {
    public let command: Command
    public var size: Size
    
    public init(command: Command, size: Size = .medium) {
        self.command = command
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(color.gradient)
            
            Image(systemName: command.type.icon)
                .font(size.font)
                .foregroundStyle(.white)
        }
        .frame(width: size.dimension, height: size.dimension)
    }
    
    private var color: Color {
        switch command.category {
        case .workflow: return .blue
        case .documentation: return .purple
        case .analytics: return .orange
        case .configuration: return .gray
        case .system: return .green
        case .general: return .teal
        case .file: return .yellow
        case .project: return .indigo
        case .navigation: return .cyan
        case .editing: return .pink
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
