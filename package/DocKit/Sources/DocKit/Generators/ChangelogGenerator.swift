//
//  ChangelogGenerator.swift
//  DocKit
//
//  Changelog generation from commit history
//

import Foundation

public struct ChangelogGenerator {
    
    public static func generate(from commits: [CommitInfo]) -> String {
        var sections: [String] = []
        
        sections.append("# Changelog")
        sections.append("")
        sections.append("All notable changes to this project will be documented in this file.")
        sections.append("")
        
        // Group by date (version)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let grouped = Dictionary(grouping: commits) { commit in
            dateFormatter.string(from: commit.date)
        }
        
        let sortedDates = grouped.keys.sorted().reversed()
        
        for date in sortedDates {
            guard let dateCommits = grouped[date] else { continue }
            
            sections.append("## [\(date)]")
            sections.append("")
            
            // Group by type
            let byType = Dictionary(grouping: dateCommits) { $0.type }
            
            // Breaking changes first
            if let breaking = byType[.breaking], !breaking.isEmpty {
                sections.append("### ⚠️ Breaking Changes")
                sections.append("")
                for commit in breaking {
                    sections.append("- \(commit.message)")
                }
                sections.append("")
            }
            
            // Features
            if let features = byType[.feature], !features.isEmpty {
                sections.append("### ✨ Features")
                sections.append("")
                for commit in features {
                    sections.append("- \(commit.message)")
                }
                sections.append("")
            }
            
            // Fixes
            if let fixes = byType[.fix], !fixes.isEmpty {
                sections.append("### 🐛 Bug Fixes")
                sections.append("")
                for commit in fixes {
                    sections.append("- \(commit.message)")
                }
                sections.append("")
            }
            
            // Docs
            if let docs = byType[.docs], !docs.isEmpty {
                sections.append("### 📚 Documentation")
                sections.append("")
                for commit in docs {
                    sections.append("- \(commit.message)")
                }
                sections.append("")
            }
            
            // Other
            let otherTypes: [CommitInfo.CommitType] = [.refactor, .style, .test, .chore, .other]
            let others = otherTypes.compactMap { byType[$0] }.flatMap { $0 }
            if !others.isEmpty {
                sections.append("### 🔧 Other Changes")
                sections.append("")
                for commit in others {
                    sections.append("- \(commit.message)")
                }
                sections.append("")
            }
        }
        
        return sections.joined(separator: "\n")
    }
    
    /// Generate changelog from git log
    public static func generateFromGit(at path: String, since: String? = nil) async throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.currentDirectoryURL = URL(fileURLWithPath: path)
        
        var args = ["log", "--pretty=format:%H|%s|%an|%aI"]
        if let since = since {
            args.append("--since=\(since)")
        }
        process.arguments = args
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        let dateFormatter = ISO8601DateFormatter()
        var commits: [CommitInfo] = []
        
        for line in output.components(separatedBy: .newlines) where !line.isEmpty {
            let parts = line.components(separatedBy: "|")
            guard parts.count >= 4 else { continue }
            
            let hash = parts[0]
            let message = parts[1]
            let author = parts[2]
            let dateStr = parts[3]
            
            let date = dateFormatter.date(from: dateStr) ?? Date()
            let type = CommitInfo.CommitType.from(message)
            
            commits.append(CommitInfo(hash: hash, message: message, author: author, date: date, type: type))
        }
        
        return generate(from: commits)
    }
}
