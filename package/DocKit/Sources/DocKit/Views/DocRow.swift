//
//  DocRow.swift
//  DocKit
//

import SwiftUI

public struct DocRow: View {
    public let document: Document
    
    public init(document: Document) {
        self.document = document
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: document.format.icon)
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(document.title)
                    .font(.headline)
                
                Text(document.description.prefix(50) + "...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(document.format.rawValue)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.quaternary)
                .clipShape(Capsule())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}
