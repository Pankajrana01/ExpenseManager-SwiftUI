//
//  MockUserNotificationCenter.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 11/05/25.
//

import Foundation
import UserNotifications
@testable import ExpenseTracker

class MockUserNotificationCenter: UserNotificationCenter {
    var didRequestAuthorization = false
    var delegate: UNUserNotificationCenterDelegate?
    var notificationTitle: String = ""
    var notificationBody: String = ""
    var notificationCategoryIdentifier: String = ""
    var notificationIdentifier: String = ""
    var notificationHour: Int?
    var notificationMinute: Int?
    var removePendingNotificationRequestsIdentifiers: [String]?
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        didRequestAuthorization
    }
    
    func add(_ request: UNNotificationRequest) async throws {
        notificationTitle = request.content.title
        notificationBody = request.content.body
        notificationCategoryIdentifier = request.content.categoryIdentifier
        notificationIdentifier = request.identifier
        let trigger = request.trigger as? UNCalendarNotificationTrigger
        notificationHour = trigger?.dateComponents.hour
        notificationMinute = trigger?.dateComponents.minute
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        removePendingNotificationRequestsIdentifiers = identifiers
    }
}
