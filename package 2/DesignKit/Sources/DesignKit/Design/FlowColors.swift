//
//  FlowColors.swift
//  DesignKit
//
//  Semantic color system for FlowKit
//

import SwiftUI

public struct FlowColors {
    
    public struct Semantic {
        public static func canvas(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color(hex: "0D0D0F") : Color(hex: "F5F5F7")
        }
        
        public static func surface(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color(hex: "1C1C1E") : Color(hex: "FFFFFF")
        }
        
        public static func elevated(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color(hex: "2C2C2E") : Color(hex: "FFFFFF")
        }
        
        public static func floating(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color(hex: "1C1C1E").opacity(0.95) : Color(hex: "FFFFFF").opacity(0.95)
        }
    }
    
    public struct Category {
        public static let dashboard = Color(hex: "007AFF")
        public static let workflows = Color(hex: "5856D6")
        public static let agents = Color(hex: "FF9500")
        public static let projects = Color(hex: "34C759")
        public static let commands = Color(hex: "FF2D55")
        public static let documentation = Color(hex: "00C7BE")
        public static let files = Color(hex: "64D2FF")
        public static let chat = Color(hex: "AF52DE")
        public static let search = Color(hex: "5AC8FA")
        public static let settings = Color(hex: "8E8E93")
        public static let knowledge = Color(hex: "BF5AF2")
        public static let learn = Color(hex: "FF375F")
        public static let inventory = Color(hex: "30D158")
        
        /// Returns a category color for a given item identifier
        public static func forItem(_ item: String) -> Color {
            switch item.lowercased() {
            case "dashboard": return dashboard
            case "workflows": return workflows
            case "agents": return agents
            case "projects": return projects
            case "commands": return commands
            case "documentation", "docs": return documentation
            case "files": return files
            case "chat", "aiassistant": return chat
            case "search": return search
            case "settings": return settings
            case "knowledge": return knowledge
            case "learn": return learn
            case "inventory": return inventory
            case "mltemplates": return Color(hex: "BF5AF2")
            case "mlarchitect": return Color(hex: "00C7BE")
            case "indexeddocs": return documentation
            case "indexedcode": return projects
            default: return Color(hex: "8E8E93")
            }
        }
    }
    
    public struct Status {
        public static let success = Color(hex: "34C759")
        public static let warning = Color(hex: "FF9500")
        public static let error = Color(hex: "FF3B30")
        public static let info = Color(hex: "007AFF")
        public static let neutral = Color(hex: "8E8E93")
    }
    
    public struct Text {
        public static func primary(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? .white : .black
        }
        
        public static func secondary(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
        }
        
        public static func tertiary(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.3)
        }
    }
    
    public struct Border {
        public static func subtle(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06)
        }
        
        public static func medium(_ scheme: ColorScheme) -> Color {
            scheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1)
        }
    }
}
