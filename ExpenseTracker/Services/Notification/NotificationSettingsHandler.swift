//
//  NotificationSettings.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 12/05/25.
//

import Foundation

/// Represents different types of user notifications.
enum NotificationType: Codable {
    case dailyExpense
    case monthlySalary
}

/// Defines the structure for a notification setting, including its time and type.
struct NotificationSetting: Codable {
    let type: NotificationType
    let hour: Int
    let minute: Int
    
    /// Returns a formatted string for display, like "9:00 PM".
    var formattedTime: String {
        let dateComponents = DateComponents(hour: hour, minute: minute)
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents) {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return ""
    }
}

/// Abstraction for notification settings operations.
protocol NotificationSettings {
    /// The currently saved daily expense notification setting, if available.
    var dailyExpenseNotification: NotificationSetting? { get }
    
    /// Saves a new daily expense notification setting with a given time.
    func setDailyExpenseNotification(hour: Int, minute: Int)
    
    /// Removes the saved daily expense notification setting.
    func removeDailyExpenseNotification()
}

/// Concrete implementation of `NotificationSettings` using `UserDefaults` for persistence.
final class NotificationSettingsHandler: NotificationSettings {
    
    /// Internal storage of the daily notification setting. Automatically persisted when changed.
    private var _dailyExpenseNotification: NotificationSetting? {
        didSet {
            if let data = try? JSONEncoder().encode(_dailyExpenseNotification) {
                UserDefaults.standard.set(data, forKey: "DailyExpenseNotification")
            } else {
                UserDefaults.standard.removeObject(forKey: "DailyExpenseNotification")
            }
        }
    }
    
    /// Public read-only access to the stored notification setting.
    var dailyExpenseNotification: NotificationSetting? {
        return _dailyExpenseNotification
    }
    
    /// Initializes and loads previously saved settings from `UserDefaults`.
    init() {
        if let data = UserDefaults.standard.data(forKey: "DailyExpenseNotification") {
            if let decode = try? JSONDecoder().decode(NotificationSetting.self, from: data) {
                _dailyExpenseNotification = decode
            }
        }
    }
    
    /// Saves a new notification setting with the specified time.
    func setDailyExpenseNotification(hour: Int, minute: Int) {
        _dailyExpenseNotification = NotificationSetting(type: .dailyExpense, hour: hour, minute: minute)
    }
    
    /// Clears the saved notification setting.
    func removeDailyExpenseNotification() {
        _dailyExpenseNotification = nil
    }
}

/// In-memory version of `NotificationSettings`, useful for testing or preview environments.
final class InMemoryNotificationSettingsHandler: NotificationSettings {
    
    /// Internal storage of the notification setting. Default value is provided.
    private var _dailyExpenseNotification: NotificationSetting? = .init(type: .dailyExpense, hour: 21, minute: 0)
    
    /// Public read-only access to the stored notification setting.
    var dailyExpenseNotification: NotificationSetting? {
        _dailyExpenseNotification
    }
    
    /// Sets the in-memory notification setting to the given time.
    func setDailyExpenseNotification(hour: Int, minute: Int) {
        _dailyExpenseNotification = NotificationSetting(type: .dailyExpense, hour: hour, minute: minute)
    }
    
    /// Clears the in-memory notification setting.
    func removeDailyExpenseNotification() {
        _dailyExpenseNotification = nil
    }
}
