//
//  SignUpViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 19/04/25.
//

import Foundation

extension SignUpView {
    /// ViewModel that handles the sign-up logic and state management for `SignUpView`.
    @Observable
    class ViewModel {
        // MARK: - User Input
                
        /// User's email input from the sign-up form.
        var email: String = ""
        
        /// User's password from sign-up form.
        var password: String = ""
        
        // MARK: - State Properties
        
        /// A flag indicating whether the user is in the OTP verification phase.
        var isVerifying: Bool = false
        
        /// Stores an error message to display in the UI if sign-up fails.
        var errorMessage: String = ""
        
        /// A flag that triggers the display of an alert if an error occurs.
        var showError: Bool = false
        
        /// The user provider responsible for sign-up and authentication requests.
        var authenticator: Authenticator
        
        // MARK: - Initialization
        
        /// Initializes the view model with the given user provider.
        /// - Parameter authenticator: The shared instance responsible for performing auth operations.
        init(authenticator: Authenticator) {
            self.authenticator = authenticator
            
#if DEBUG
            email = "mynamepallabmaiti@gmail.com"
            password = "123456"
#endif
        }
        
        // MARK: - Sign Up Actions
        
        /// Initiates sign-up with Google account.
        /// Displays an error alert if the process fails.
        func signUpWithGoogle() async {
            do {
                try await authenticator.signInWithGoogle()
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
        
        /// Performs form-based sign-up using email, first name, and last name.
        /// Transitions to OTP verification on success.
        func signUp() async {
            do {
                try await authenticator.signUp(
                    email: email,
                    password: password
                )
                isVerifying = true
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

