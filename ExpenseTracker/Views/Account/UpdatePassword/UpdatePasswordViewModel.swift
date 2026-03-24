//
//  UpdatePasswordViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 08/05/25.
//

import Foundation

extension UpdatePasswordView {
    /// ViewModel for handling password update logic and state management.
    @Observable
    class ViewModel {
        /// New password entered by the user.
        var newPassword: String = ""
        
        /// Confirmation of the new password.
        var confirmPassword: String = ""
        
        /// Indicates whether an error alert should be shown.
        var showError: Bool = false
        
        /// The error message to be displayed in the alert.
        var errorMessage: String = ""
        
        /// Indicates whether the user should be reauthenticated due to expired session.
        var showReauthentication: Bool = false
        
        /// A computed property to validate password input fields.
        /// Ensures:
        /// - Both password fields are non-empty
        /// - Both passwords match
        /// - Passwords meet minimum length requirement (8 characters)
        var isPasswordValid: Bool {
            newPassword.isNotEmpty &&
            confirmPassword.isNotEmpty &&
            newPassword == confirmPassword &&
            newPassword.count >= 8 &&
            confirmPassword.count >= 8
        }
        
        /// Authentication handler to perform update operations.
        private var authenticator: Authenticator
        
        /// Initializes the view model with dependencies.
        /// - Parameter authenticator: The auth handler used for updating the password.
        init(authenticator: Authenticator) {
            self.authenticator = authenticator
        }
        
        /// Attempts to update the user's password.
        /// If session is expired, prompts reauthentication.
        func updatePassword() async {
            do {
                try await authenticator.updatePassword(newPassword)
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
