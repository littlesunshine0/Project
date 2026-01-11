//
//  DocIcon.swift
//  DocKit
//

import SwiftUI

public struct DocIcon: View {
    public let category: DocCategory
    public var size: Size
    
    public init(category: DocCategory, size: Size = .medium) {
        self.category = category
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(color.gradient)
            
            Image(systemName: category.icon)
                .font(size.font)
                .foregroundStyle(.white)
        }
        .frame(width: size.dimension, height: size.dimension)
    }
    
    private var color: Color {
        switch category {
        case .readme: return .blue
        case .api: return .purple
        case .changelog: return .orange
        case .tutorial: return .green
        case .reference: return .cyan
        case .spec: return .red
        case .guide: return .yellow
        case .architecture: return .indigo
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
