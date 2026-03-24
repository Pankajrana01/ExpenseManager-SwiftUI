//
//  NotificationManager.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 12/05/25.
//

import Foundation

/// Manages scheduling, handling, and updating notification-related data for the app.
@Observable
final class NotificationManager {
    
    /// A published property used to trigger the Add Expense view when a notification is tapped.
    var showAddExpense = false
    
    /// Handles low-level notification interactions with UNUserNotificationCenter.
    private let center: NotificationCenterHandler
    
    /// Manages saving and loading user preferences for notifications.
    private let settings: NotificationSettings
    
    /// Initializes the manager with a notification settings handler.
    /// - Parameter settings: The handler responsible for persisting notification settings.
    init(center: NotificationCenterHandler, settings: NotificationSettings) {
        self.center = center
        self.settings = settings
        self.center.delegate = self
    }
    
    /// The current setting for daily expense notifications, if any.
    var dailyExpenseNotificationSetting: NotificationSetting? {
        settings.dailyExpenseNotification
    }
    
    /// Requests user permission to show notifications.
    /// - Returns: `true` if permission was granted, `false` otherwise.
    func requestPermission() async -> Bool {
        await center.requestPermission()
    }
    
    /// Schedules a daily expense reminder notification at the specified time.
    /// - Parameters:
    ///   - hour: The hour of the day (default is 21 / 9 PM).
    ///   - minute: The minute of the hour (default is 0).
    func scheduleDailyExpenseNotification(hour: Int = 21, minute: Int = 0) async {
        await center.scheduleDailyExpenseNotification(hour: hour, minute: minute)
        settings.setDailyExpenseNotification(hour: hour, minute: minute)
    }
    
    /// Removes all pending daily expense reminder notifications and clears saved settings.
    func removeAllPendingDailyExpenseNotifications() {
        center.removeAllPendingDailyExpenseNotifications()
        settings.removeDailyExpenseNotification()
    }
}

extension NotificationManager: NotificationHandlerDelegate {
    
    /// Responds to received notification taps.
    /// - Parameter identifier: The identifier of the received notification.
    func didReceiveNotification(with identifier: String) async {
        switch identifier {
        case "dailyExpenseReminder":
            showAddExpense = true
        default:
            break
        }
    }
}
