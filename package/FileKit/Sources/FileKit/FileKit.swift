//
//  FileKit.swift
//  FileKit - File System Operations
//

import Foundation

// MARK: - File Info

public struct FileInfo: Identifiable, Sendable {
    public let id: String
    public let name: String
    public let path: String
    public let isDirectory: Bool
    public let size: Int64
    public let createdAt: Date?
    public let modifiedAt: Date?
    public let `extension`: String?
    
    public init(name: String, path: String, isDirectory: Bool = false, size: Int64 = 0) {
        self.id = path
        self.name = name
        self.path = path
        self.isDirectory = isDirectory
        self.size = size
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.extension = name.contains(".") ? String(name.split(separator: ".").last ?? "") : nil
    }
}

// MARK: - File Operation Result

public struct FileOperationResult: Sendable {
    public let success: Bool
    public let path: String
    public let error: String?
    
    public static func success(_ path: String) -> FileOperationResult {
        FileOperationResult(success: true, path: path, error: nil)
    }
    
    public static func failure(_ path: String, error: String) -> FileOperationResult {
        FileOperationResult(success: false, path: path, error: error)
    }
}

// MARK: - File System Service

public actor FileSystemService {
    public static let shared = FileSystemService()
    
    private var watchedPaths: Set<String> = []
    private var recentFiles: [FileInfo] = []
    
    private init() {}
    
    public func listDirectory(_ path: String) -> [FileInfo] {
        let fm = FileManager.default
        guard let contents = try? fm.contentsOfDirectory(atPath: path) else { return [] }
        
        return contents.compactMap { name in
            let fullPath = (path as NSString).appendingPathComponent(name)
            var isDir: ObjCBool = false
            guard fm.fileExists(atPath: fullPath, isDirectory: &isDir) else { return nil }
            
            let attrs = try? fm.attributesOfItem(atPath: fullPath)
            let size = (attrs?[.size] as? Int64) ?? 0
            
            return FileInfo(name: name, path: fullPath, isDirectory: isDir.boolValue, size: size)
        }
    }
    
    public func readFile(_ path: String) -> String? {
        try? String(contentsOfFile: path, encoding: .utf8)
    }
    
    public func writeFile(_ path: String, content: String) -> FileOperationResult {
        do {
            try content.write(toFile: path, atomically: true, encoding: .utf8)
            return .success(path)
        } catch {
            return .failure(path, error: error.localizedDescription)
        }
    }
    
    public func createDirectory(_ path: String) -> FileOperationResult {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
            return .success(path)
        } catch {
            return .failure(path, error: error.localizedDescription)
        }
    }
    
    public func delete(_ path: String) -> FileOperationResult {
        do {
            try FileManager.default.removeItem(atPath: path)
            return .success(path)
        } catch {
            return .failure(path, error: error.localizedDescription)
        }
    }
    
    public func exists(_ path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    public func copy(from: String, to: String) -> FileOperationResult {
        do {
            try FileManager.default.copyItem(atPath: from, toPath: to)
            return .success(to)
        } catch {
            return .failure(to, error: error.localizedDescription)
        }
    }
    
    public func move(from: String, to: String) -> FileOperationResult {
        do {
            try FileManager.default.moveItem(atPath: from, toPath: to)
            return .success(to)
        } catch {
            return .failure(to, error: error.localizedDescription)
        }
    }
    
    public func watch(_ path: String) {
        watchedPaths.insert(path)
    }
    
    public func unwatch(_ path: String) {
        watchedPaths.remove(path)
    }
    
    public func addRecentFile(_ info: FileInfo) {
        recentFiles.insert(info, at: 0)
        if recentFiles.count > 50 {
            recentFiles.removeLast()
        }
    }
    
    public func getRecentFiles(limit: Int = 10) -> [FileInfo] {
        Array(recentFiles.prefix(limit))
    }
    
    public var stats: FileStats {
        FileStats(
            watchedPaths: watchedPaths.count,
            recentFilesCount: recentFiles.count
        )
    }
}

public struct FileStats: Sendable {
    public let watchedPaths: Int
    public let recentFilesCount: Int
}
