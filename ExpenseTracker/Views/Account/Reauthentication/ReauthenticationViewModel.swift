//
//  ReauthenticationViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 08/05/25.
//

import Foundation

extension ReauthenticationView {
    /// ViewModel for managing reauthentication logic and form state.
    @Observable
    class ViewModel {
        /// User-entered email address.
        var email: String = ""
        
        /// User-entered password.
        var password: String = ""
        
        /// Flag to control display of error alert.
        var showError: Bool = false
        
        /// Error message to display in the alert.
        var errorMessage: String = ""
        
        /// Authenticator instance used for reauthentication.
        private var authenticator: Authenticator
        
        /// Database manager, included for potential future needs.
        private var databaseManager: DatabaseManager
        
        /// Initializes the ViewModel with dependencies.
        /// - Parameters:
        ///   - authenticator: Object handling authentication.
        ///   - databaseManager: Object handling user data access.
        init(authenticator: Authenticator, databaseManager: DatabaseManager) {
            self.authenticator = authenticator
            self.databaseManager = databaseManager
        }
        
        /// Triggers reauthentication using the provided email and password.
        /// Displays error message if reauthentication fails.
        func reauthenticate() async {
            do {
                try await authenticator.reauthenticate(email: email, password: password)
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
}
