//
//  CollaborationVersionHistoryPropertyTests.swift
//  ProjectTests
//
//  Property 50: Version history maintenance
//  Validates: Requirements 12.2
//

import XCTest
import SwiftCheck
@testable import Project

final class CollaborationVersionHistoryPropertyTests: XCTestCase {
    
    // Property 50: Version history must maintain complete chronological record
    func testVersionHistoryMaintenance() {
        property("Version history maintains complete chronological record") <- forAll { (workflowId: String, edits: [WorkflowEdit]) in
            let versionControl = WorkflowVersionControl()
            var versions: [WorkflowVersion] = []
            
            // Apply edits and track versions
            for edit in edits {
                let version = versionControl.applyEdit(workflowId: workflowId, edit: edit)
                versions.append(version)
            }
            
            let history = versionControl.getHistory(for: workflowId)
            
            // Property: History contains all versions
            guard history.count == versions.count else { return false }
            
            // Property: Versions are chronologically ordered
            for i in 0..<(history.count - 1) {
                guard history[i].timestamp <= history[i + 1].timestamp else { return false }
            }
            
            // Property: Each version is retrievable
            for version in versions {
                guard versionControl.getVersion(version.id) != nil else { return false }
            }
            
            // Property: Can restore to any version
            if let randomVersion = versions.randomElement() {
                let restored = versionControl.restore(to: randomVersion.id)
                guard restored != nil else { return false }
            }
            
            return true
        }
    }
    
    // Property: Version diffs are accurate
    func testVersionDiffAccuracy() {
        property("Version diffs accurately represent changes") <- forAll { (v1: WorkflowVersion, v2: WorkflowVersion) in
            let versionControl = WorkflowVersionControl()
            
            let diff = versionControl.diff(from: v1, to: v2)
            
            // Property: Applying diff to v1 produces v2
            let result = versionControl.applyDiff(diff, to: v1)
            
            return result.content == v2.content
        }
    }
    
    // Property: Version history is immutable
    func testVersionHistoryImmutability() {
        property("Version history entries are immutable") <- forAll { (workflowId: String, edit: WorkflowEdit) in
            let versionControl = WorkflowVersionControl()
            
            let version1 = versionControl.applyEdit(workflowId: workflowId, edit: edit)
            let retrieved1 = versionControl.getVersion(version1.id)
            
            // Attempt to modify (should not affect stored version)
            var modified = version1
            modified.content = "modified"
            
            let retrieved2 = versionControl.getVersion(version1.id)
            
            return retrieved1?.content == retrieved2?.content &&
                   retrieved1?.content == version1.content
        }
    }
}

// MARK: - Test Models

struct WorkflowEdit: Arbitrary {
    let author: String
    let changes: [String]
    let timestamp: Date
    
    static var arbitrary: Gen<WorkflowEdit> {
        Gen.compose { c in
            WorkflowEdit(
                author: c.generate(using: String.arbitrary),
                changes: c.generate(using: Gen.fromElements(of: ["add step", "remove step", "modify step", "reorder"])),
                timestamp: Date()
            )
        }
    }
}

struct WorkflowVersion: Arbitrary {
    let id: String
    var content: String
    let timestamp: Date
    let author: String
    
    static var arbitrary: Gen<WorkflowVersion> {
        Gen.compose { c in
            WorkflowVersion(
                id: UUID().uuidString,
                content: c.generate(using: String.arbitrary),
                timestamp: Date(),
                author: c.generate(using: String.arbitrary)
            )
        }
    }
}
