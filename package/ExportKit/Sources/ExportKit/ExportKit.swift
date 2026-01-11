//
//  ExportKit.swift
//  ExportKit
//
//  Data export in multiple formats
//

import Foundation

public struct ExportKit {
    public static let version = "1.0.0"
    public static let identifier = "com.flowkit.exportkit"
    public init() {}
}

// MARK: - Export Service

public actor ExportService {
    public static let shared = ExportService()
    
    private var exports: [UUID: ExportJob] = [:]
    private var templates: [String: ExportTemplate] = [
        "json": ExportTemplate(id: "json", name: "JSON", format: .json),
        "csv": ExportTemplate(id: "csv", name: "CSV", format: .csv),
        "markdown": ExportTemplate(id: "markdown", name: "Markdown", format: .markdown),
        "html": ExportTemplate(id: "html", name: "HTML", format: .html)
    ]
    
    private init() {}
    
    // MARK: - Export
    
    public func export(data: ExportData, format: ExportFormat) -> ExportResult {
        let job = ExportJob(data: data, format: format)
        exports[job.id] = job
        
        let content: String
        switch format {
        case .json: content = exportToJSON(data)
        case .csv: content = exportToCSV(data)
        case .markdown: content = exportToMarkdown(data)
        case .html: content = exportToHTML(data)
        case .xml: content = exportToXML(data)
        case .yaml: content = exportToYAML(data)
        }
        
        return ExportResult(jobId: job.id, format: format, content: content, size: content.utf8.count)
    }

    private func exportToJSON(_ data: ExportData) -> String {
        var json = "{\n"
        json += "  \"title\": \"\(data.title)\",\n"
        json += "  \"records\": [\n"
        for (i, record) in data.records.enumerated() {
            json += "    {"
            json += record.map { "\"\($0.key)\": \"\($0.value)\"" }.joined(separator: ", ")
            json += "}\(i < data.records.count - 1 ? "," : "")\n"
        }
        json += "  ]\n}"
        return json
    }
    
    private func exportToCSV(_ data: ExportData) -> String {
        guard let first = data.records.first else { return "" }
        var csv = first.keys.joined(separator: ",") + "\n"
        for record in data.records {
            csv += first.keys.map { record[$0] ?? "" }.joined(separator: ",") + "\n"
        }
        return csv
    }
    
    private func exportToMarkdown(_ data: ExportData) -> String {
        var md = "# \(data.title)\n\n"
        if let first = data.records.first {
            md += "| " + first.keys.joined(separator: " | ") + " |\n"
            md += "| " + first.keys.map { _ in "---" }.joined(separator: " | ") + " |\n"
            for record in data.records {
                md += "| " + first.keys.map { record[$0] ?? "" }.joined(separator: " | ") + " |\n"
            }
        }
        return md
    }
    
    private func exportToHTML(_ data: ExportData) -> String {
        var html = "<html><head><title>\(data.title)</title></head><body>\n"
        html += "<h1>\(data.title)</h1>\n<table border='1'>\n"
        if let first = data.records.first {
            html += "<tr>" + first.keys.map { "<th>\($0)</th>" }.joined() + "</tr>\n"
            for record in data.records {
                html += "<tr>" + first.keys.map { "<td>\(record[$0] ?? "")</td>" }.joined() + "</tr>\n"
            }
        }
        html += "</table></body></html>"
        return html
    }
    
    private func exportToXML(_ data: ExportData) -> String {
        var xml = "<?xml version=\"1.0\"?>\n<data title=\"\(data.title)\">\n"
        for record in data.records {
            xml += "  <record>\n"
            for (key, value) in record {
                xml += "    <\(key)>\(value)</\(key)>\n"
            }
            xml += "  </record>\n"
        }
        xml += "</data>"
        return xml
    }
    
    private func exportToYAML(_ data: ExportData) -> String {
        var yaml = "title: \(data.title)\nrecords:\n"
        for record in data.records {
            yaml += "  -\n"
            for (key, value) in record {
                yaml += "    \(key): \(value)\n"
            }
        }
        return yaml
    }
    
    public func getJob(_ id: UUID) -> ExportJob? { exports[id] }
    public func getTemplate(_ id: String) -> ExportTemplate? { templates[id] }
    public func getAllTemplates() -> [ExportTemplate] { Array(templates.values) }
}

// MARK: - Models

public struct ExportData: Sendable {
    public let title: String
    public let records: [[String: String]]
    public let metadata: [String: String]
    
    public init(title: String, records: [[String: String]], metadata: [String: String] = [:]) {
        self.title = title
        self.records = records
        self.metadata = metadata
    }
}

public enum ExportFormat: String, Sendable, CaseIterable {
    case json, csv, markdown, html, xml, yaml
}

public struct ExportJob: Identifiable, Sendable {
    public let id: UUID
    public let data: ExportData
    public let format: ExportFormat
    public let createdAt: Date
    
    public init(id: UUID = UUID(), data: ExportData, format: ExportFormat, createdAt: Date = Date()) {
        self.id = id
        self.data = data
        self.format = format
        self.createdAt = createdAt
    }
}

public struct ExportResult: Sendable {
    public let jobId: UUID
    public let format: ExportFormat
    public let content: String
    public let size: Int
    public let exportedAt: Date
    
    public init(jobId: UUID, format: ExportFormat, content: String, size: Int, exportedAt: Date = Date()) {
        self.jobId = jobId
        self.format = format
        self.content = content
        self.size = size
        self.exportedAt = exportedAt
    }
}

public struct ExportTemplate: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let format: ExportFormat
    
    public init(id: String, name: String, format: ExportFormat) {
        self.id = id
        self.name = name
        self.format = format
    }
}
