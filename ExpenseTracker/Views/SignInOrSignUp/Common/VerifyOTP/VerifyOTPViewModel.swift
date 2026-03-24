//
//  VerifyOTPViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 21/04/25.
//

import Foundation

/// Extension of `VerifyOTPView` containing the view-specific ViewModel.
///
/// This ViewModel handles OTP input, verification, and resend logic.
/// It observes state changes (like error messages and OTP code) for driving UI updates.
extension VerifyOTPView {
    
    /// A view model that manages OTP verification logic and user feedback.
    @Observable
    class ViewModel {
        
        /// The OTP entered by the user, bound to the OTP input field.
        var otpCode: String = ""
        
        /// A human-readable error message displayed in the alert.
        var errorMessage: String = ""
        
        /// A flag that triggers showing the error alert when `true`.
        var showError: Bool = false
        
        /// Indicates whether an operation is currently in progress.
        var isLoading: Bool = false
        
        /// Indicates whether the verification is success or not.
        var isVerified: Bool = false
        
        /// A progress message displayed with the `ProgressView`.
        var progressTitle: String = ""

        /// Reference to the `UserProvider`, injected from the parent view.
        var userProvider: UserProvider
        
        /// Reference to the `DatabaseManager`, injected from the parent view.
        var databaseManager: DatabaseManager
        
        /// Initializes the ViewModel with a given `UserProvider`.
        ///
        /// - Parameter userProvider: The shared user provider instance used to verify or resend OTP.
        init(userProvider: UserProvider, databaseManager: DatabaseManager) {
            self.userProvider = userProvider
            self.databaseManager = databaseManager
        }
        
        /// Attempts to verify the OTP entered by the user using the `UserProvider`.
        ///
        /// - On success: User verification is complete (e.g., user is signed in).
        /// - On failure: Sets the error message and triggers the alert.
        func verifyOTP() async {
            do {
                isLoading = true
                progressTitle = "Verifying OTP..."
                try await userProvider.verifyOTP(otpCode)
                isLoading = false
                isVerified = true
            } catch {
                showError = true
                errorMessage = error.localizedErrorMessage
            }
        }
        
        /// Attempts to resend the OTP to the user's email.
        ///
        /// - On success: No user-facing message needed (could optionally show a toast).
        /// - On failure: Shows an alert with the appropriate error message.
        func resendOTP() async {
            do {
                isLoading = true
                progressTitle = "Resending OTP..."
                try await userProvider.resendOTP()
                isLoading = false
            } catch {
                showError = true
                errorMessage = error.localizedErrorMessage
            }
        }
    }
}
