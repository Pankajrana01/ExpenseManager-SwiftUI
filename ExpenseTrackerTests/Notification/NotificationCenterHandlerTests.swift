//
//  NotificationHandlerTests.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 11/05/25.
//

import Testing
@testable import ExpenseTracker

@Suite("NotificationCenterHandler Tests")
struct NotificationCenterHandlerTests {

    var notificationHandler: NotificationCenterHandler
    var notificationCenter: MockUserNotificationCenter
    
    init() async throws {
        notificationCenter = MockUserNotificationCenter()
        notificationHandler = NotificationCenterHandler(notificationCenter: notificationCenter)
    }
    
    @Test("Request Permission - Failure")
    func didRequestAuthorizationFailure() async throws {
        notificationCenter.didRequestAuthorization = false
        
        let isAuthorized = await notificationHandler.requestPermission()
        
        #expect(isAuthorized == false)
    }

    @Test("Request Permission - Success")
    func didRequestAuthorizationSuccess() async throws {
        notificationCenter.didRequestAuthorization = true
        
        let isAuthorized = await notificationHandler.requestPermission()
        
        #expect(isAuthorized)
    }
    
    @Test("Schedule daily expense notification")
    func scheduleDailyExpenseNotification() async throws {
        await notificationHandler.scheduleDailyExpenseNotification()
        
        #expect(notificationCenter.notificationTitle == "Hi!")
        #expect(notificationCenter.notificationBody == "It's time to track your expenses!")
        #expect(notificationCenter.notificationCategoryIdentifier == "ADD_EXPENSE")
        #expect(notificationCenter.notificationHour == 21)
        #expect(notificationCenter.notificationMinute == 0)
        #expect(notificationCenter.notificationIdentifier == "dailyExpenseReminder")
    }
    
    @Test("Remove pending daily expense notification")
    func removeAllPendingDailyExpenseNotifications() async throws {
        notificationHandler.removeAllPendingDailyExpenseNotifications()
        
        #expect(notificationCenter.removePendingNotificationRequestsIdentifiers == ["dailyExpenseReminder"])
    }
}
