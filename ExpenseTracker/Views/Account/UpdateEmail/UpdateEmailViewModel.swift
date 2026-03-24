//
//  UpdateEmailViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 08/05/25.
//

import Foundation

extension UpdateEmailView {
    /// A view model that manages the logic for updating the user's email.
    /// Handles communication with the authenticator and error states.
    @Observable
    class ViewModel {
        /// The new email entered by the user.
        var email: String = ""
        
        /// Flag to show an error alert.
        var showError: Bool = false
        
        /// Error message to display when an error occurs.
        var errorMessage: String = ""
        
        /// Flag to trigger reauthentication if required.
        var showReauthentication: Bool = false
        
        /// Authenticator instance for handling auth-related tasks.
        private var authenticator: Authenticator
        
        /// Database manager for data persistence (unused here but available if needed).
        private var databaseManager: DatabaseManager
        
        /// Initializes the view model with dependencies.
        /// - Parameters:
        ///   - authenticator: The auth handler used for updating the email.
        ///   - databaseManager: Manages database operations (optional for this context).
        init(authenticator: Authenticator, databaseManager: DatabaseManager) {
            self.authenticator = authenticator
            self.databaseManager = databaseManager
        }
        
        /// Attempts to update the email via the authenticator.
        /// If the session has expired, triggers reauthentication flow.
        func updateEmail() async {
            do {
                try await authenticator.updateEmail(email)
            } catch {
                if let error = error as? AuthenticationError, error == .sessionExpired {
                    showReauthentication = true
                } else {
                    showError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
