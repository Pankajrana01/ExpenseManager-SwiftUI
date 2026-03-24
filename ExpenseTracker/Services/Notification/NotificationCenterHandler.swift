//
//  NotificationCenterHandler.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 10/05/25.
//

import Foundation
import UserNotifications

/// A protocol to abstract `UNUserNotificationCenter` for easier testing and dependency injection.
protocol UserNotificationCenter {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func add(_ request: UNNotificationRequest) async throws
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
    var delegate: UNUserNotificationCenterDelegate? { get set }
}

/// Conforms `UNUserNotificationCenter` to the `UserNotificationCenter` protocol.
extension UNUserNotificationCenter: UserNotificationCenter {}

protocol NotificationHandlerDelegate {
    func didReceiveNotification(with identifier: String) async
}

/// A notification handler to manage user notification permissions, scheduling, and response handling.
final class NotificationCenterHandler: NSObject {
    /// The notification center instance used for scheduling and handling notifications.
    private var notificationCenter: UserNotificationCenter
    
    var delegate: NotificationHandlerDelegate?
    
    /// Initializes the notification handler and assigns itself as the delegate.
    init(notificationCenter: UserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
        super.init()
        self.notificationCenter.delegate = self
    }
    
    /// Requests notification permissions for alerts and sounds.
    /// - Returns: A Boolean indicating whether permission was granted.
    func requestPermission() async -> Bool {
        do {
            return try await notificationCenter.requestAuthorization(options: [.alert, .sound])
        } catch {
            print("Error requesting notification permission: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Schedules a daily notification reminding the user to track their expenses.
    /// - Parameters:
    ///   - hour: The hour to trigger the notification. Defaults to 21 (9 PM).
    ///   - minute: The minute to trigger the notification. Defaults to 0.
    func scheduleDailyExpenseNotification(hour: Int = 21, minute: Int = 0) async {
        let content = UNMutableNotificationContent()
        content.title = "Hi!"
        content.body = "Keep control of your spending—log today’s expenses and stay on top of your budget."
        content.sound = .default
        content.categoryIdentifier = "ADD_EXPENSE"
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyExpenseReminder", content: content, trigger: trigger)
        
        do {
            try await notificationCenter.add(request)
        } catch {
            print("Error scheduling notification: \(error.localizedDescription)")
        }
    }
    
    
    /// Removes all pending daily expense notifications.
    func removeAllPendingDailyExpenseNotifications() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyExpenseReminder"])
    }
}

/// Handles notification tap actions.
extension NotificationCenterHandler: UNUserNotificationCenterDelegate {
    /// Called when the user interacts with a notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let identifier = response.notification.request.identifier
        await delegate?.didReceiveNotification(with: identifier)
    }
}
