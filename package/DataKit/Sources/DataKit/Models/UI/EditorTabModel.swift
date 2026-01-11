//
//  EditorTabModel.swift
//  DataKit
//
//  Represents an open file/editor tab
//

import Foundation

/// Represents an open file/editor tab
public struct EditorTabModel: Identifiable, Equatable, Hashable, Codable, Sendable {
    public let id: UUID
    public let filePath: String
    public let fileName: String
    public let fileExtension: String
    public let icon: String
    public let colorName: String
    public var isModified: Bool
    public var isPinned: Bool
    public let openedAt: Date
    
    public init(
        id: UUID = UUID(),
        filePath: String,
        fileName: String,
        fileExtension: String,
        icon: String = "doc.text",
        colorName: String = "blue",
        isModified: Bool = false,
        isPinned: Bool = false,
        openedAt: Date = Date()
    ) {
        self.id = id
        self.filePath = filePath
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.icon = icon
        self.colorName = colorName
        self.isModified = isModified
        self.isPinned = isPinned
        self.openedAt = openedAt
    }
    
    public static func forFile(_ path: String) -> EditorTabModel {
        let url = URL(fileURLWithPath: path)
        let ext = url.pathExtension.lowercased()
        let (icon, colorName) = iconAndColor(for: ext)
        return EditorTabModel(
            filePath: path,
            fileName: url.lastPathComponent,
            fileExtension: ext,
            icon: icon,
            colorName: colorName
        )
    }
    
    private static func iconAndColor(for ext: String) -> (String, String) {
        switch ext {
        case "swift": return ("swift", "orange")
        case "js", "jsx": return ("curlybraces", "yellow")
        case "ts", "tsx": return ("curlybraces", "blue")
        case "py": return ("chevron.left.forwardslash.chevron.right", "green")
        case "json": return ("curlybraces.square", "gray")
        case "md", "markdown": return ("doc.richtext", "purple")
        case "html": return ("chevron.left.forwardslash.chevron.right", "orange")
        case "css", "scss": return ("paintbrush", "pink")
        case "yaml", "yml": return ("list.bullet.indent", "cyan")
        default: return ("doc.text", "secondary")
        }
    }
}
