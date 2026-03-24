//
//  SignUpView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 18/04/25.
//

import SwiftUI



/// A view that handles the sign-up process, including form-based and social sign-in,
/// and OTP verification once the sign-up is initiated.
struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    /// The environment-injected instance of `DatabaseManager`.
    @Environment(DatabaseManager.self) var databaseManager
    
    /// The view model that manages sign-up state and logic.
    @State private var viewModel: ViewModel
    
    /// The user provider used to perform sign-up and authentication tasks.
    var userProvider: Authenticator
    
    /// Callback executed when the user taps "Sign in" (for users who already have an account).
    var onSignIn: () -> Void
    
    var userAuthenticated: (() -> Void)
    
    /// Initializes the sign-up view with dependencies.
    /// - Parameters:
    ///   - authenticator: A shared user provider instance to handle auth logic.
    ///   - onSignIn: A closure that switches to the sign-in view.
    init(authenticator: Authenticator, onSignIn: @escaping () -> Void, userAuthenticated: @escaping () -> Void) {
        self.userProvider = authenticator
        _viewModel = .init(wrappedValue: .init(authenticator: authenticator))
        self.onSignIn = onSignIn
        self.userAuthenticated = userAuthenticated
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create your account")
                .font(.title)
                .fontWeight(.bold)
                .padding([.top, .horizontal], 20)
            Text("to sync your data in cloud")
                .font(.title3)
                .padding(.horizontal, 20)
            
            VStack {
                SocialSignInView {
                    Task {
                        await viewModel.signUpWithGoogle()
                        userAuthenticated()
                    }
                }
                .padding([.top, .horizontal])
                
                EmailPasswordForm(
                    email: $viewModel.email,
                    password: $viewModel.password,
                    buttonLabel: "Sign Up"
                ) {
                    Task {
                        await viewModel.signUp()
                        userAuthenticated()
                    }
                }
                .padding()
                
                HStack {
                    Text("Already have an account?")
                    
                    Button("Sign in", action: onSignIn)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("Ok") {
                
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .transition(.slide.combined(with: .opacity))
    }
}

#Preview {
    SignUpView(authenticator: FirebaseAuthenticator()) { } userAuthenticated: { }
        .environment(
            DatabaseManager.initWithInMemory
        )
}
