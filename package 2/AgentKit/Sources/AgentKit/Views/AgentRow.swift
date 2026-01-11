//
//  AgentRow.swift
//  AgentKit
//

import SwiftUI

public struct AgentRow: View {
    public let agent: Agent
    public var onTap: (() -> Void)?
    public var onToggle: (() -> Void)?
    
    public init(agent: Agent, onTap: (() -> Void)? = nil, onToggle: (() -> Void)? = nil) {
        self.agent = agent
        self.onTap = onTap
        self.onToggle = onToggle
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: agent.type.icon)
                .font(.title3)
                .foregroundStyle(statusColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(agent.name)
                        .font(.headline)
                    
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)
                }
                
                Text(agent.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(agent.status.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor.opacity(0.2))
                    .clipShape(Capsule())
                
                if let onToggle {
                    Button(action: onToggle) {
                        Image(systemName: agent.status == .running ? "stop.fill" : "play.fill")
                            .foregroundStyle(agent.status == .running ? .red : .green)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
    
    private var statusColor: Color {
        switch agent.status {
        case .idle: return .gray
        case .running: return .green
        case .paused: return .orange
        case .error: return .red
        case .disabled: return .gray
        }
    }
}
