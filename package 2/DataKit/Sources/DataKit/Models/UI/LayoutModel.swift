//
//  LayoutModel.swift
//  DataKit
//

import Foundation

/// Layout configuration
public struct LayoutModel: Codable, Sendable, Hashable {
    public let columns: Int
    public let spacing: Double
    public let padding: EdgeInsets
    public let alignment: Alignment
    
    public init(columns: Int = 1, spacing: Double = 8, padding: EdgeInsets = EdgeInsets(), alignment: Alignment = .leading) {
        self.columns = columns
        self.spacing = spacing
        self.padding = padding
        self.alignment = alignment
    }
    
    public struct EdgeInsets: Codable, Sendable, Hashable {
        public let top: Double
        public let leading: Double
        public let bottom: Double
        public let trailing: Double
        
        public init(top: Double = 0, leading: Double = 0, bottom: Double = 0, trailing: Double = 0) {
            self.top = top
            self.leading = leading
            self.bottom = bottom
            self.trailing = trailing
        }
    }
    
    public enum Alignment: String, Codable, Sendable {
        case leading, center, trailing
    }
}
