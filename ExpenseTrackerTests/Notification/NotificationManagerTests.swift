//
//  NotificationManagerTests.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 17/05/25.
//

import Testing
@testable import ExpenseTracker

@Suite("NotificationManager Tests")
struct NotificationManagerTests {
    
    var settings: NotificationSettings
    var noticationCenter: MockUserNotificationCenter
    var notificationManager: NotificationManager
    
    init() async throws {
        settings = InMemoryNotificationSettingsHandler()
        noticationCenter = MockUserNotificationCenter()
        let center = NotificationCenterHandler(notificationCenter: noticationCenter)
        notificationManager = NotificationManager(center: center, settings: settings)
    }
    
    @Test("Request permission")
    func requestPermission() async throws {
        noticationCenter.didRequestAuthorization = true
        
        let isAuthorized = await notificationManager.requestPermission()
        #expect(isAuthorized)
    }
    
    @Test("Schedule daily expense notification")
    func scheduleDailyExpenseNotification() async throws {
        await notificationManager.scheduleDailyExpenseNotification()
        
        #expect(notificationManager.dailyExpenseNotificationSetting?.formattedTime == "9:00 PM")
    }
    
    @Test("Remove pending daily expense notification")
    func removeAllPendingDailyExpenseNotifications() async throws {
        notificationManager.removeAllPendingDailyExpenseNotifications()
        
        #expect(notificationManager.dailyExpenseNotificationSetting == nil)
    }
}
