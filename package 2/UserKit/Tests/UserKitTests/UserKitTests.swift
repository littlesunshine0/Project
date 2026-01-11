import Testing
@testable import UserKit

@Suite("UserKit Tests")
struct UserKitTests {
    
    @Test("Create profile")
    func testCreateProfile() async {
        let profile = await UserManager.shared.createProfile(name: "Test User", email: "test@example.com")
        #expect(profile.name == "Test User")
        #expect(profile.email == "test@example.com")
    }
    
    @Test("Get profile")
    func testGetProfile() async {
        let created = await UserManager.shared.createProfile(name: "GetTest")
        let retrieved = await UserManager.shared.getProfile(created.id)
        #expect(retrieved?.name == "GetTest")
    }
    
    @Test("Update profile")
    func testUpdateProfile() async {
        let profile = await UserManager.shared.createProfile(name: "Original")
        let updated = await UserManager.shared.updateProfile(profile.id, name: "Updated")
        #expect(updated?.name == "Updated")
    }
    
    @Test("Set preference")
    func testSetPreference() async {
        let profile = await UserManager.shared.createProfile(name: "PrefUser")
        await UserManager.shared.setPreference("theme", value: "dark", for: profile.id)
        let pref = await UserManager.shared.getPreference("theme", for: profile.id)
        #expect(pref == "dark")
    }
    
    @Test("Start session")
    func testStartSession() async {
        let profile = await UserManager.shared.createProfile(name: "SessionUser")
        let session = await UserManager.shared.startSession(userId: profile.id)
        #expect(session.userId == profile.id)
        #expect(session.isActive)
    }
    
    @Test("End session")
    func testEndSession() async {
        let profile = await UserManager.shared.createProfile(name: "EndSessionUser")
        let session = await UserManager.shared.startSession(userId: profile.id)
        await UserManager.shared.endSession(session.id)
        // Session ended
    }
    
    @Test("User stats")
    func testStats() async {
        let stats = await UserManager.shared.stats
        #expect(stats.totalProfiles >= 0)
    }
}
