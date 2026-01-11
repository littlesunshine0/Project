//
//  InspectorPanel.swift
//  DataKit
//

import Foundation

/// Inspector panel
public struct InspectorPanel: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let sections: [InspectorSection]
    
    public init(id: String, title: String, icon: String = "info.circle", sections: [InspectorSection] = []) {
        self.id = id
        self.title = title
        self.icon = icon
        self.sections = sections
    }
}
