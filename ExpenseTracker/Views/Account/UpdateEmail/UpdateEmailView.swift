//
//  UpdateEmailView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 08/05/25.
//

import SwiftUI

/// A view that allows the user to update their email address.
/// Displays a text field for entering the new email and handles update logic via ViewModel.
struct UpdateEmailView: View {
    // Used to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    // ViewModel handling update logic and state
    @State private var viewModel: ViewModel
    
    // Authenticator for managing user auth
    private var authenticator: Authenticator
    
    // Database manager for persistence
    private var databaseManager: DatabaseManager
    
    /// Initializes the view with required dependencies.
    /// - Parameters:
    ///   - authenticator: The authentication manager.
    ///   - databaseManager: The database interaction layer.
    init(authenticator: Authenticator, databaseManager: DatabaseManager) {
        self.authenticator = authenticator
        self.databaseManager = databaseManager
        _viewModel = .init(wrappedValue: .init(authenticator: authenticator, databaseManager: databaseManager))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Text field for email input
                VStack {
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                }
                .background(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .cornerRadius(10)
                
                // Button to trigger email update
                PrimaryButton("Update", isEnabled: !viewModel.email.isEmpty) {
                    Task {
                        await viewModel.updateEmail()
                        dismiss()
                    }
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Email")
            .navigationBarTitleDisplayMode(.inline)
            
            // Sheet shown if reauthentication is required
            .sheet(isPresented: $viewModel.showReauthentication) {
                ReauthenticationView(authenticator: authenticator, databaseManager: databaseManager) {
                    Task {
                        await viewModel.updateEmail()
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    UpdateEmailView(authenticator: FirebaseAuthenticator(), databaseManager: .initWithInMemory)
}
