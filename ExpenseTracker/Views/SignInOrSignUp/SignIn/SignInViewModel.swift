//
//  SignInViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 19/04/25.
//

import Foundation

extension SignInView {
    /// ViewModel for handling sign-in logic and state for `SignInView`.
    ///
    /// Supports both email-based sign-in and Google OAuth sign-in using `Authenticator`.
    @Observable
    class ViewModel {
        
        /// Email address input from the user.
        var email: String = ""
        
        /// Password from the user.
        var password: String = ""
        
        /// Error message to display in case of failure.
        var errorMessage: String = ""
        
        /// Flag to show verification screen (e.g., OTP entry) after email sign-in initiation.
        var isVerifying = false
        
        /// Flag to toggle display of an error alert.
        var showError: Bool = false
        
        /// User provider instance for authentication actions.
        var authenticator: Authenticator
        
        /// Initializes the view model with a `Authenticator`.
        init(authenticator: Authenticator) {
            self.authenticator = authenticator
#if DEBUG
            email = "mynamepallabmaiti@gmail.com"
            password = "12345678"
#endif
        }
        
        /// Initiates Google OAuth sign-in flow.
        ///
        /// If the sign-in fails, sets appropriate error state.
        func signInWithGoogle() async {
            do {
                try await authenticator.signInWithGoogle()
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
        
        /// Initiates email-based sign-in and sets `isVerifying` to `true` if successful.
        ///
        /// If the sign-in fails, sets appropriate error state.
        func signIn() async {
            do {
                try await authenticator.signIn(email: email, password: password)
                isVerifying = true
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
}
