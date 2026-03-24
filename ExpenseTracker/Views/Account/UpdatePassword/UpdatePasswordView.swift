//
//  UpdatePasswordView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 08/05/25.
//

import SwiftUI

struct UpdatePasswordView: View {
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
        _viewModel = .init(wrappedValue: .init(authenticator: authenticator))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Text field for email input
                VStack {
                    SecureField("New password", text: $viewModel.newPassword)
                        .textInputAutocapitalization(.never)
                        .padding([.top, .horizontal])
                        .padding(.bottom, 5)
                    
                    Divider()
                    
                    SecureField("Confirm password", text: $viewModel.confirmPassword)
                        .textInputAutocapitalization(.never)
                        .padding([.bottom, .horizontal])
                        .padding(.top, 5)
                }
                .background(.secondary.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .cornerRadius(10)
                
                // Button to trigger email update
                PrimaryButton("Update", isEnabled: viewModel.isPasswordValid) {
                    Task {
                        await viewModel.updatePassword()
                        dismiss()
                    }
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Password")
            .navigationBarTitleDisplayMode(.inline)
            
            // Sheet shown if reauthentication is required
            .sheet(isPresented: $viewModel.showReauthentication) {
                ReauthenticationView(authenticator: authenticator, databaseManager: databaseManager) {
                    Task {
                        await viewModel.updatePassword()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    UpdatePasswordView(authenticator: FirebaseAuthenticator(), databaseManager: .initWithInMemory)
}
