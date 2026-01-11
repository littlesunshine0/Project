//
//  DocComposer.swift
//  DocKit
//
//  Documentation composition and template system
//

import Foundation

// MARK: - Doc Composer

@MainActor
public class DocComposer: ObservableObject {
    public static let shared = DocComposer()
    
    @Published public var documents: [Document] = []
    @Published public var templates: [DocTemplate] = []
    @Published public var draftDocument: DocumentDraft?
    
    private init() {
        loadTemplates()
    }
    
    // MARK: - Composition
    
    public func startComposition(from template: DocTemplate? = nil) -> DocumentDraft {
        let draft = DocumentDraft(template: template)
        draftDocument = draft
        return draft
    }
    
    public func addSection(_ section: DocumentSection) {
        draftDocument?.sections.append(section)
    }
    
    public func finalize() -> Document? {
        guard let draft = draftDocument else { return nil }
        
        let document = Document(
            title: draft.title,
            description: draft.description,
            sections: draft.sections,
            format: draft.format,
            tags: draft.tags
        )
        
        documents.append(document)
        draftDocument = nil
        saveDocuments()
        
        return document
    }
    
    public func cancelComposition() {
        draftDocument = nil
    }
    
    // MARK: - Generation
    
    public func generateREADME(for project: ProjectInfo) -> String {
        DocKit.generateREADME(for: project)
    }
    
    public func generateAPIDocs(from symbols: [CodeSymbol]) -> String {
        DocKit.generateAPIDocs(from: symbols)
    }
    
    public func generateChangelog(from commits: [CommitInfo]) -> String {
        DocKit.generateChangelog(from: commits)
    }
    
    // MARK: - Templates
    
    public func templates(for format: DocumentFormat) -> [DocTemplate] {
        templates.filter { $0.format == format }
    }
    
    private func loadTemplates() {
        templates = DocTemplate.builtInTemplates
    }
    
    // MARK: - Persistence
    
    private func saveDocuments() {
        if let encoded = try? JSONEncoder().encode(documents) {
            UserDefaults.standard.set(encoded, forKey: "composedDocuments")
        }
    }
    
    public func loadDocuments() {
        if let data = UserDefaults.standard.data(forKey: "composedDocuments"),
           let decoded = try? JSONDecoder().decode([Document].self, from: data) {
            documents = decoded
        }
    }
}

// MARK: - Document Draft

public struct DocumentDraft {
    public var title: String
    public var description: String
    public var sections: [DocumentSection]
    public var format: DocumentFormat
    public var tags: [String]
    
    public init(template: DocTemplate? = nil) {
        if let template = template {
            self.title = template.name
            self.description = template.description
            self.sections = template.defaultSections
            self.format = template.format
            self.tags = template.tags
        } else {
            self.title = "New Document"
            self.description = ""
            self.sections = []
            self.format = .markdown
            self.tags = []
        }
    }
}

// MARK: - Document

public struct Document: Codable, Identifiable, Sendable {
    public let id: UUID
    public var title: String
    public var description: String
    public var sections: [DocumentSection]
    public var format: DocumentFormat
    public var tags: [String]
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        sections: [DocumentSection] = [],
        format: DocumentFormat = .markdown,
        tags: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.sections = sections
        self.format = format
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var wordCount: Int {
        sections.reduce(0) { $0 + $1.content.split(separator: " ").count }
    }
}

// MARK: - Doc Template

public struct DocTemplate: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let description: String
    public let format: DocumentFormat
    public let defaultSections: [DocumentSection]
    public let tags: [String]
    public let icon: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        format: DocumentFormat = .markdown,
        defaultSections: [DocumentSection] = [],
        tags: [String] = [],
        icon: String = "doc.text"
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.format = format
        self.defaultSections = defaultSections
        self.tags = tags
        self.icon = icon
    }
    
    public static let builtInTemplates: [DocTemplate] = [
        DocTemplate(
            name: "README",
            description: "Standard project README",
            format: .markdown,
            defaultSections: [
                DocumentSection(title: "Overview", content: "Project description goes here.", level: 1),
                DocumentSection(title: "Installation", content: "Installation instructions.", level: 2),
                DocumentSection(title: "Usage", content: "Usage examples.", level: 2),
                DocumentSection(title: "License", content: "MIT License", level: 2)
            ],
            tags: ["readme", "project"],
            icon: "doc.text"
        ),
        DocTemplate(
            name: "API Documentation",
            description: "API reference documentation",
            format: .markdown,
            defaultSections: [
                DocumentSection(title: "API Reference", content: "API documentation.", level: 1),
                DocumentSection(title: "Endpoints", content: "List of endpoints.", level: 2),
                DocumentSection(title: "Authentication", content: "Auth details.", level: 2)
            ],
            tags: ["api", "reference"],
            icon: "doc.badge.gearshape"
        ),
        DocTemplate(
            name: "Changelog",
            description: "Version changelog",
            format: .markdown,
            defaultSections: [
                DocumentSection(title: "Changelog", content: "All notable changes.", level: 1),
                DocumentSection(title: "[Unreleased]", content: "Upcoming changes.", level: 2)
            ],
            tags: ["changelog", "versions"],
            icon: "clock.arrow.circlepath"
        ),
        DocTemplate(
            name: "Technical Spec",
            description: "Technical specification document",
            format: .markdown,
            defaultSections: [
                DocumentSection(title: "Technical Specification", content: "Overview.", level: 1),
                DocumentSection(title: "Requirements", content: "Requirements list.", level: 2),
                DocumentSection(title: "Architecture", content: "System architecture.", level: 2),
                DocumentSection(title: "Implementation", content: "Implementation details.", level: 2)
            ],
            tags: ["spec", "technical"],
            icon: "doc.text.magnifyingglass"
        )
    ]
}
