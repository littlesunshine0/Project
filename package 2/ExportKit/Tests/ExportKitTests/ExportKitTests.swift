import Testing
@testable import ExportKit

@Suite("ExportKit Tests")
struct ExportKitTests {
    
    let testData = ExportData(
        title: "Test Export",
        records: [
            ["name": "Alice", "age": "30"],
            ["name": "Bob", "age": "25"]
        ]
    )
    
    @Test("Export to JSON")
    func testExportJSON() async {
        let result = await ExportService.shared.export(data: testData, format: .json)
        #expect(result.content.contains("Alice"))
        #expect(result.content.contains("\"name\""))
    }
    
    @Test("Export to CSV")
    func testExportCSV() async {
        let result = await ExportService.shared.export(data: testData, format: .csv)
        #expect(result.content.contains("name"))
        #expect(result.content.contains("Alice"))
    }
    
    @Test("Export to Markdown")
    func testExportMarkdown() async {
        let result = await ExportService.shared.export(data: testData, format: .markdown)
        #expect(result.content.contains("# Test Export"))
        #expect(result.content.contains("|"))
    }
    
    @Test("Export to HTML")
    func testExportHTML() async {
        let result = await ExportService.shared.export(data: testData, format: .html)
        #expect(result.content.contains("<html>"))
        #expect(result.content.contains("<table"))
    }
    
    @Test("Export to XML")
    func testExportXML() async {
        let result = await ExportService.shared.export(data: testData, format: .xml)
        #expect(result.content.contains("<?xml"))
        #expect(result.content.contains("<record>"))
    }
    
    @Test("Export to YAML")
    func testExportYAML() async {
        let result = await ExportService.shared.export(data: testData, format: .yaml)
        #expect(result.content.contains("title:"))
        #expect(result.content.contains("records:"))
    }
    
    @Test("Get templates")
    func testGetTemplates() async {
        let templates = await ExportService.shared.getAllTemplates()
        #expect(templates.count >= 4)
    }
    
    @Test("Export result has size")
    func testExportResultSize() async {
        let result = await ExportService.shared.export(data: testData, format: .json)
        #expect(result.size > 0)
    }
}
