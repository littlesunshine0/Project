//
//  CommandRow.swift
//  CommandKit
//

import SwiftUI

public struct CommandRow: View {
    public let command: Command
    public var onTap: (() -> Void)?
    public var onFavorite: (() -> Void)?
    public var isFavorite: Bool
    
    public init(command: Command, isFavorite: Bool = false, onTap: (() -> Void)? = nil, onFavorite: (() -> Void)? = nil) {
        self.command = command
        self.isFavorite = isFavorite
        self.onTap = onTap
        self.onFavorite = onFavorite
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: command.type.icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("/\(command.name)")
                    .font(.headline)
                    .fontDesign(.monospaced)
                
                Text(command.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(command.category.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary)
                    .clipShape(Capsule())
                
                if let onFavorite {
                    Button(action: onFavorite) {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundStyle(isFavorite ? .yellow : .secondary)
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
}
