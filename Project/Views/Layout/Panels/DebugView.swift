//
//  DebugView.swift
//  FlowKit
//
//  Debug panel view
//

import SwiftUI
import DesignKit

struct DebugView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(FlowColors.Category.agents.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: "ant.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(FlowColors.Category.agents)
            }
            
            VStack(spacing: 4) {
                Text("No active debug session")
                    .font(FlowTypography.body(.medium))
                    .foregroundStyle(FlowColors.Text.primary(colorScheme))
                Text("Start debugging to see variables and call stack")
                    .font(FlowTypography.caption())
                    .foregroundStyle(FlowColors.Text.secondary(colorScheme))
            }
            
            Button("Start Debugging") {}
                .buttonStyle(FlowButtonStyle(color: FlowColors.Category.agents, size: .small))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityLabel("Debug panel, no active session")
    }
}

// MARK: - Flow Button Style

struct FlowButtonStyle: ButtonStyle {
    let color: Color
    let size: Size
    
    enum Size {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            case .medium: return EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            case .large: return EdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)
            }
        }
        
        var font: Font {
            switch self {
            case .small: return FlowTypography.caption(.medium)
            case .medium: return FlowTypography.body(.medium)
            case .large: return FlowTypography.headline()
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.font)
            .foregroundStyle(.white)
            .padding(size.padding)
            .background(color)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
