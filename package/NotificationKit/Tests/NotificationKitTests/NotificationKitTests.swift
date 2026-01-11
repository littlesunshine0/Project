import Testing
@testable import NotificationKit

@Suite("NotificationKit Tests")
struct NotificationKitTests {
    
    @Test("Send notification")
    func testSendNotification() async {
        let id = await NotificationManager.shared.send(title: "Test", message: "Test message")
        let notification = await NotificationManager.shared.get(id)
        #expect(notification != nil)
        #expect(notification?.title == "Test")
    }
    
    @Test("Get by channel")
    func testGetByChannel() async {
        _ = await NotificationManager.shared.send(title: "System Alert", message: "Alert", channel: "system")
        let systemNotifications = await NotificationManager.shared.getByChannel("system")
        #expect(!systemNotifications.isEmpty)
    }
    
    @Test("Mark as read")
    func testMarkAsRead() async {
        let id = await NotificationManager.shared.send(title: "Unread", message: "Message")
        await NotificationManager.shared.markAsRead(id)
        let notification = await NotificationManager.shared.get(id)
        #expect(notification?.isRead == true)
    }
    
    @Test("Unread count")
    func testUnreadCount() async {
        _ = await NotificationManager.shared.send(title: "New", message: "Unread notification")
        let count = await NotificationManager.shared.getUnreadCount()
        #expect(count >= 1)
    }
    
    @Test("Channel preferences")
    func testChannelPreferences() async {
        await NotificationManager.shared.setChannelEnabled("promo", enabled: false)
        let enabled = await NotificationManager.shared.isChannelEnabled("promo")
        #expect(!enabled)
    }
    
    @Test("Workflow subscription")
    func testWorkflowSubscription() async {
        await WorkflowNotificationService.shared.subscribe(userId: "user1", to: "build")
        let subscribers = await WorkflowNotificationService.shared.getSubscribers(for: "build")
        #expect(subscribers.contains("user1"))
    }
    
    @Test("Notification stats")
    func testNotificationStats() async {
        let stats = await NotificationManager.shared.stats
        #expect(stats.total >= 0)
    }
}
