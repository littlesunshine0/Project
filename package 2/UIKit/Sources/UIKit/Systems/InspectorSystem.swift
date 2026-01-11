//
//  InspectorSystem.swift
//  UIKit
//
//  Inspector and properties panel systems
//

import Foundation
import DataKit

// MARK: - Inspector System

public struct InspectorSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "inspector"
    public let name = "Inspector"
    public let description = "Multi-tab inspector panel for viewing and editing properties"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS, .visionOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let width: CGFloat
        public let minWidth: CGFloat
        public let maxWidth: CGFloat
        public let showTabBar: Bool
        public let tabBarPosition: TabBarPosition
        public let allowMultipleSections: Bool
        public let collapsibleSections: Bool
        public let showSearch: Bool
        
        public static let `default` = Configuration(
            width: 320,
            minWidth: 260,
            maxWidth: 500,
            showTabBar: true,
            tabBarPosition: .top,
            allowMultipleSections: true,
            collapsibleSections: true,
            showSearch: false
        )
        
        public init(width: CGFloat = 320, minWidth: CGFloat = 260, maxWidth: CGFloat = 500, showTabBar: Bool = true, tabBarPosition: TabBarPosition = .top, allowMultipleSections: Bool = true, collapsibleSections: Bool = true, showSearch: Bool = false) {
            self.width = width
            self.minWidth = minWidth
            self.maxWidth = maxWidth
            self.showTabBar = showTabBar
            self.tabBarPosition = tabBarPosition
            self.allowMultipleSections = allowMultipleSections
            self.collapsibleSections = collapsibleSections
            self.showSearch = showSearch
        }
        
        public enum TabBarPosition: String, Codable, Sendable { case top, bottom }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var tabs: [InspectorTab]
        public var selectedTabId: String?
        public var sections: [InspectorSection]
        public var collapsedSectionIds: Set<String>
        public var searchQuery: String
        public var width: CGFloat
        
        public static let initial = State(
            tabs: [],
            selectedTabId: nil,
            sections: [],
            collapsedSectionIds: [],
            searchQuery: "",
            width: 320
        )
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

// MARK: - Inspector Types

public struct InspectorTab: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let type: InspectorTabType
    public let badge: String?
    
    public init(id: String, title: String, icon: String, type: InspectorTabType, badge: String? = nil) {
        self.id = id
        self.title = title
        self.icon = icon
        self.type = type
        self.badge = badge
    }
}

public enum InspectorTabType: String, Codable, Sendable, CaseIterable {
    case properties
    case fileInspector
    case historyInspector
    case quickHelp
    case accessibility
    case connections
    case diagnostics
    case performance
    case debug
    case custom
    
    public var defaultIcon: String {
        switch self {
        case .properties: return "slider.horizontal.3"
        case .fileInspector: return "doc.text.fill"
        case .historyInspector: return "clock.arrow.circlepath"
        case .quickHelp: return "questionmark.circle.fill"
        case .accessibility: return "accessibility"
        case .connections: return "point.3.connected.trianglepath.dotted"
        case .diagnostics: return "exclamationmark.triangle.fill"
        case .performance: return "gauge.with.dots.needle.bottom.50percent"
        case .debug: return "ant.fill"
        case .custom: return "square.fill"
        }
    }
}

public struct InspectorSection: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String?
    public let fields: [InspectorField]
    public let isCollapsible: Bool
    public let isExpanded: Bool
    
    public init(id: String, title: String, icon: String? = nil, fields: [InspectorField], isCollapsible: Bool = true, isExpanded: Bool = true) {
        self.id = id
        self.title = title
        self.icon = icon
        self.fields = fields
        self.isCollapsible = isCollapsible
        self.isExpanded = isExpanded
    }
}

public struct InspectorField: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let label: String
    public let type: InspectorFieldType
    public let value: String
    public let isEditable: Bool
    public let placeholder: String?
    public let options: [String]?
    public let validation: FieldValidation?
    
    public init(id: String, label: String, type: InspectorFieldType, value: String = "", isEditable: Bool = true, placeholder: String? = nil, options: [String]? = nil, validation: FieldValidation? = nil) {
        self.id = id
        self.label = label
        self.type = type
        self.value = value
        self.isEditable = isEditable
        self.placeholder = placeholder
        self.options = options
        self.validation = validation
    }
}

public enum InspectorFieldType: String, Codable, Sendable {
    case text
    case number
    case toggle
    case slider
    case dropdown
    case color
    case date
    case stepper
    case segmented
    case multiline
    case file
    case image
    case link
    case custom
}

public struct FieldValidation: Codable, Sendable, Hashable {
    public let required: Bool
    public let minLength: Int?
    public let maxLength: Int?
    public let pattern: String?
    public let errorMessage: String?
    
    public init(required: Bool = false, minLength: Int? = nil, maxLength: Int? = nil, pattern: String? = nil, errorMessage: String? = nil) {
        self.required = required
        self.minLength = minLength
        self.maxLength = maxLength
        self.pattern = pattern
        self.errorMessage = errorMessage
    }
}

// MARK: - Quick Help System

public struct QuickHelpSystem: UISystemProtocol, ConfigurableSystem, StatefulSystem {
    public let id = "quickHelp"
    public let name = "Quick Help"
    public let description = "Contextual help panel showing documentation for selected items"
    public let version = "1.0.0"
    public let supportedPlatforms: [UIPlatform] = [.macOS, .iPadOS]
    
    public struct Configuration: UIConfigurationProtocol {
        public let showSymbolInfo: Bool
        public let showDeclaration: Bool
        public let showDescription: Bool
        public let showParameters: Bool
        public let showRelated: Bool
        public let linkStyle: LinkStyle
        
        public static let `default` = Configuration(
            showSymbolInfo: true,
            showDeclaration: true,
            showDescription: true,
            showParameters: true,
            showRelated: true,
            linkStyle: .inline
        )
        
        public init(showSymbolInfo: Bool = true, showDeclaration: Bool = true, showDescription: Bool = true, showParameters: Bool = true, showRelated: Bool = true, linkStyle: LinkStyle = .inline) {
            self.showSymbolInfo = showSymbolInfo
            self.showDeclaration = showDeclaration
            self.showDescription = showDescription
            self.showParameters = showParameters
            self.showRelated = showRelated
            self.linkStyle = linkStyle
        }
        
        public enum LinkStyle: String, Codable, Sendable { case inline, button, card }
    }
    
    public var defaultConfiguration: Configuration { .default }
    
    public struct State: UIStateProtocol {
        public var currentSymbol: SymbolInfo?
        public var history: [SymbolInfo]
        public var isLoading: Bool
        
        public static let initial = State(currentSymbol: nil, history: [], isLoading: false)
    }
    
    public var initialState: State { .initial }
    
    public init() {}
}

public struct SymbolInfo: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let kind: SymbolKind
    public let declaration: String?
    public let description: String?
    public let parameters: [ParameterInfo]?
    public let returnType: String?
    public let availability: String?
    public let relatedSymbols: [String]?
    
    public init(id: String, name: String, kind: SymbolKind, declaration: String? = nil, description: String? = nil, parameters: [ParameterInfo]? = nil, returnType: String? = nil, availability: String? = nil, relatedSymbols: [String]? = nil) {
        self.id = id
        self.name = name
        self.kind = kind
        self.declaration = declaration
        self.description = description
        self.parameters = parameters
        self.returnType = returnType
        self.availability = availability
        self.relatedSymbols = relatedSymbols
    }
}

public enum SymbolKind: String, Codable, Sendable {
    case `class`, `struct`, `enum`, `protocol`, `extension`
    case function, method, property, variable, constant
    case `typealias`, `associatedtype`
    case `case`, `subscript`, `init`, `deinit`
    case macro, module, unknown
}

public struct ParameterInfo: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let type: String
    public let description: String?
    public let defaultValue: String?
    
    public init(id: String, name: String, type: String, description: String? = nil, defaultValue: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.defaultValue = defaultValue
    }
}
