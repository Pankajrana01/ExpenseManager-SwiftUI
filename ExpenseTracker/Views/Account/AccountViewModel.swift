//
//  AccountViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 06/05/25.
//

import Foundation

extension AccountView {
    
    /// ViewModel that manages account data and handles business logic for `AccountView`.
    @Observable
    class ViewModel {
        
        /// The user's first name (editable).
        var firstName: String = ""
        
        /// The user's last name (editable).
        var lastName: String = ""
        
        /// Error message to show in alerts.
        var errorMessage: String = ""
        
        /// Flag to control the display of an error alert.
        var showError: Bool = false
        
        var enableDailyExpenseNotifications: Bool = false
        
        /// The current setting for daily expense notifications, if any.
        var dailyExpenseNotificationSettings: NotificationSetting?
        
        /// Handles authentication (e.g., sign out).
        private var authenticator: Authenticator
        
        /// Used for fetching and updating user details in the database.
        private var databaseManager: DatabaseManager
        
        /// Manages scheduling, handling, and updating notification-related data for the app.
        private let notificationManager: NotificationManager
        
        /// Holds the current user object fetched from the database.
        private var user: User?
        
        /// Initializes the view model with authenticator and database manager.
        /// Automatically fetches user details on creation.
        init(authenticator: Authenticator, databaseManager: DatabaseManager, notificationManager: NotificationManager) {
            self.authenticator = authenticator
            self.databaseManager = databaseManager
            self.notificationManager = notificationManager
            self.enableDailyExpenseNotifications = notificationManager.dailyExpenseNotificationSetting != nil
            self.dailyExpenseNotificationSettings = notificationManager.dailyExpenseNotificationSetting
            Task {
                await fetchUserDetails()
            }
        }
        
        /// Returns the user's email (read-only).
        var email: String {
            user?.email ?? ""
        }
        
        /// Returns the user's full name, composed from first and last name.
        var name: String {
            "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        }
        
        /// Fetches user details from the database and updates the state.
        func fetchUserDetails() async {
            do {
                if let userDetails = try await databaseManager.fetchUserDetails() {
                    self.user = userDetails
                    self.firstName = userDetails.firstName ?? ""
                    self.lastName = userDetails.lastName ?? ""
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        /// Saves the updated first and last name to the database.
        func saveName() async {
            guard let user else { return }
            do {
                _ = try await databaseManager.updateUserDetails(
                    .init(
                        id: user.id,
                        email: user.email,
                        firstName: firstName,
                        lastName: lastName
                    )
                )
                await fetchUserDetails() // Refresh local state
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        
        /// Signs the user out and resets session-related data.
        func signOut() async {
            do {
                try authenticator.signOut()
                UserDefaults.standard.databaseType = .local
                UserDefaults.standard.isSignedIn = false
                databaseManager.deinitializeRemoteRepositoryHandler()
                if let user {
                    try await databaseManager.clearLocalUserDetails(user)
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        
        /// Removes all pending daily expense reminder notifications and clears saved settings.
        func removeAllPendingDailyExpenseNotifications() {
            notificationManager.removeAllPendingDailyExpenseNotifications()
            dailyExpenseNotificationSettings = nil
        }
        
        /// Schedules a daily expense reminder notification at the specified time.
        func scheduleDailyExpenseNotification() async {
            await notificationManager.scheduleDailyExpenseNotification()
            dailyExpenseNotificationSettings = notificationManager.dailyExpenseNotificationSetting
        }
    }
}
