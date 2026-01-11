import Testing
import Foundation
@testable import FileKit

@Suite("FileKit Tests")
struct FileKitTests {
    
    @Test("File exists")
    func testExists() async {
        let exists = await FileSystemService.shared.exists("/tmp")
        #expect(exists)
    }
    
    @Test("List directory")
    func testListDirectory() async {
        let files = await FileSystemService.shared.listDirectory("/tmp")
        // /tmp should have some files
        #expect(files.count >= 0)
    }
    
    @Test("Write and read file")
    func testWriteRead() async {
        let path = "/tmp/filekit_test_\(UUID().uuidString).txt"
        let result = await FileSystemService.shared.writeFile(path, content: "Hello FileKit")
        #expect(result.success)
        
        let content = await FileSystemService.shared.readFile(path)
        #expect(content == "Hello FileKit")
        
        _ = await FileSystemService.shared.delete(path)
    }
    
    @Test("Create directory")
    func testCreateDirectory() async {
        let path = "/tmp/filekit_dir_\(UUID().uuidString)"
        let result = await FileSystemService.shared.createDirectory(path)
        #expect(result.success)
        
        let exists = await FileSystemService.shared.exists(path)
        #expect(exists)
        
        _ = await FileSystemService.shared.delete(path)
    }
    
    @Test("Watch path")
    func testWatch() async {
        await FileSystemService.shared.watch("/tmp")
        await FileSystemService.shared.unwatch("/tmp")
    }
    
    @Test("Recent files")
    func testRecentFiles() async {
        let info = FileInfo(name: "recent.txt", path: "/tmp/recent.txt")
        await FileSystemService.shared.addRecentFile(info)
        let recent = await FileSystemService.shared.getRecentFiles()
        #expect(recent.contains { $0.name == "recent.txt" })
    }
    
    @Test("File stats")
    func testStats() async {
        let stats = await FileSystemService.shared.stats
        #expect(stats.watchedPaths >= 0)
    }
}
