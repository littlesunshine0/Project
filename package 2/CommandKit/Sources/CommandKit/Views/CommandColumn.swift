//
//  CommandColumn.swift
//  CommandKit
//

import SwiftUI

public struct CommandColumn: View {
    public let title: String
    public let commands: [Command]
    public var onSelect: ((Command) -> Void)?
    
    public init(title: String, commands: [Command], onSelect: ((Command) -> Void)? = nil) {
        self.title = title
        self.commands = commands
        self.onSelect = onSelect
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(commands) { command in
                        CommandColumnItem(command: command)
                            .onTapGesture { onSelect?(command) }
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(minWidth: 200)
    }
}

public struct CommandColumnItem: View {
    public let command: Command
    
    public init(command: Command) {
        self.command = command
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: command.type.icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("/\(command.name)")
                .font(.subheadline)
                .fontDesign(.monospaced)
            
            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(.quaternary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
