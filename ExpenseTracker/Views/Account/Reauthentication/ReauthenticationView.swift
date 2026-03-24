//
//  ReAuthenticationView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 08/05/25.
//

import SwiftUI

/// A view presented when the user's session has expired,
/// prompting them to reauthenticate using their email and password.
struct ReauthenticationView: View {
    
    // ViewModel handling update logic and state
    @State private var viewModel: ViewModel
    
    /// A closure called when reauthentication is successful.
    var authenticated: () -> Void
    
    /// Initializes the reauthentication view with dependencies and a success callback.
    /// - Parameters:
    ///   - authenticator: The object handling authentication logic.
    ///   - databaseManager: The object handling user data access.
    ///   - authenticated: Callback triggered on successful reauthentication.
    init(authenticator: Authenticator, databaseManager: DatabaseManager, authenticated: @escaping () -> Void) {
        _viewModel = .init(wrappedValue: .init(authenticator: authenticator, databaseManager: databaseManager))
        self.authenticated = authenticated
    }
    
    var body: some View {
        VStack {
            // Header
            Text("Session Expired")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .lineLimit(1)
            
            // Subheading
            Text("Please sign in again to continue")
                .font(.title3)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            
            VStack {
                // Form for reauthentication
                EmailPasswordForm(
                    email: $viewModel.email,
                    password: $viewModel.password,
                    buttonLabel: "Continue"
                ) {
                    Task {
                        await viewModel.reauthenticate()
                        authenticated()
                    }
                }
                .padding()
            }
            Spacer()
        }
        .transition(.slide.combined(with: .opacity))
        .alert("Error", isPresented: $viewModel.showError) {
            Button("Ok") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}


#Preview {
    ReauthenticationView(authenticator: FirebaseAuthenticator(), databaseManager: .initWithInMemory) { }
}
