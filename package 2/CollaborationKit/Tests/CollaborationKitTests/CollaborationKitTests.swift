import Testing
@testable import CollaborationKit

@Suite("CollaborationKit Tests")
struct CollaborationKitTests {
    
    @Test("Create session")
    func testCreateSession() async {
        let session = await CollaborationManager.shared.createSession(name: "Test Session", ownerId: "user1")
        #expect(session.name == "Test Session")
        #expect(session.ownerId == "user1")
    }
    
    @Test("Join session")
    func testJoinSession() async {
        let session = await CollaborationManager.shared.createSession(name: "Join Test", ownerId: "owner")
        let joined = await CollaborationManager.shared.joinSession(session.id, userId: "user2", name: "User Two")
        #expect(joined)
    }
    
    @Test("Resource locking")
    func testResourceLocking() async {
        let locked = await CollaborationManager.shared.lock(resource: "file.txt", by: "user1")
        #expect(locked)
        let isLocked = await CollaborationManager.shared.isLocked("file.txt")
        #expect(isLocked)
        
        let unlocked = await CollaborationManager.shared.unlock(resource: "file.txt", by: "user1")
        #expect(unlocked)
        let isUnlocked = await CollaborationManager.shared.isLocked("file.txt")
        #expect(!isUnlocked)
    }
    
    @Test("Lock prevents others")
    func testLockPreventsOthers() async {
        _ = await CollaborationManager.shared.lock(resource: "exclusive.txt", by: "user1")
        let secondLock = await CollaborationManager.shared.lock(resource: "exclusive.txt", by: "user2")
        #expect(!secondLock)
        _ = await CollaborationManager.shared.unlock(resource: "exclusive.txt", by: "user1")
    }
    
    @Test("Detect conflict")
    func testDetectConflict() async {
        let conflict = await ConflictResolver.shared.detectConflict(
            resource: "doc.md",
            version1: "Content A",
            version2: "Content B",
            user1: "alice",
            user2: "bob"
        )
        #expect(conflict.resourceId == "doc.md")
    }
    
    @Test("Resolve conflict")
    func testResolveConflict() async {
        let conflict = await ConflictResolver.shared.detectConflict(
            resource: "resolve.md",
            version1: "V1",
            version2: "V2",
            user1: "u1",
            user2: "u2"
        )
        let resolution = await ConflictResolver.shared.resolve(conflict.id, strategy: .merge, resolvedContent: "Merged", resolvedBy: "admin")
        #expect(resolution.strategy == .merge)
    }
    
    @Test("Version commit")
    func testVersionCommit() async {
        let version = await VersionControl.shared.commit(resource: "file.swift", content: "let x = 1", message: "Initial", author: "dev")
        #expect(version.number == 1)
        #expect(version.author == "dev")
    }
    
    @Test("Get versions")
    func testGetVersions() async {
        _ = await VersionControl.shared.commit(resource: "multi.swift", content: "v1", message: "First", author: "dev")
        _ = await VersionControl.shared.commit(resource: "multi.swift", content: "v2", message: "Second", author: "dev")
        let versions = await VersionControl.shared.getVersions(for: "multi.swift")
        #expect(versions.count >= 2)
    }
    
    @Test("Create branch")
    func testCreateBranch() async {
        _ = await VersionControl.shared.commit(resource: "branch.swift", content: "main", message: "Main", author: "dev")
        let branch = await VersionControl.shared.createBranch(name: "feature", from: "branch.swift")
        #expect(branch.name == "feature")
    }
    
    @Test("Collaboration stats")
    func testCollaborationStats() async {
        let stats = await CollaborationManager.shared.stats
        #expect(stats.sessionCount >= 0)
    }
}
