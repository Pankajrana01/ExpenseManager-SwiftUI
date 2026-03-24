//
//  SignInView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 18/04/25.
//

import SwiftUI

/// A view that presents the sign-in screen with options for email and Google sign-in.
struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    
    /// The environment-injected instance of `DatabaseManager`.
    @Environment(DatabaseManager.self) var databaseManager

    /// The view model managing the sign-in logic and state.
    @State private var viewModel: ViewModel

    /// The user provider handling authentication logic.
    var authenticator: Authenticator

    /// A closure executed when the user taps "Sign up".
    var onSignUp: () -> Void

    var userAuthenticated: (() -> Void)
    
    /// Initializes the `SignInView` with a user provider and sign-up callback.
    /// - Parameters:
    ///   - authenticator: The provider handling sign-in operations.
    ///   - onSignUp: A closure triggered when the user selects sign-up.
    init(authenticator: Authenticator, onSignUp: @escaping () -> Void, userAuthenticated: @escaping () -> Void) {
        self.authenticator = authenticator
        self._viewModel = .init(wrappedValue: .init(authenticator: authenticator))
        self.onSignUp = onSignUp
        self.userAuthenticated = userAuthenticated
    }
    
    var body: some View {
        VStack {
            Text("Welcome back!")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .lineLimit(1)
            Text("Please sign in to continue")
                .font(.title3)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            
            VStack {
                SocialSignInView() {
                    Task {
                        await viewModel.signInWithGoogle()
                        userAuthenticated()
                    }
                }
                .padding([.top, .horizontal])
                
                EmailPasswordForm(
                    email: $viewModel.email,
                    password: $viewModel.password,
                    buttonLabel: "Sign In"
                ) {
                    Task {
                        await viewModel.signIn()
                        userAuthenticated()
                    }
                }
                .padding()
                                
                HStack {
                    Text("Don't have an account?")
                    
                    Button("Sign up", action: onSignUp)
                    
                    Spacer()
                }
                .padding(.horizontal)
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
    SignInView(authenticator: FirebaseAuthenticator()) { } userAuthenticated: { }
        .environment(
            DatabaseManager.initWithInMemory
        )
}
