//
//  SignInOrSignUpView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 19/04/25.
//

import SwiftUI

/// A view that toggles between the Sign In and Sign Up screens.
///
/// This view uses an internal state to switch between sign-in and sign-up modes,
/// and provides animated transitions between them.
struct SignInOrSignUpView: View {
    @Environment(DatabaseManager.self) private var databaseManager
    
    @Environment(\.dismiss) private var dismiss
    /// The shared `Authenticator` from the environment for authentication operations.
    @Environment(\.authenticator) private var authenticator

    /// A flag indicating whether the view is currently showing the sign-in screen.
    @State private var isSignInMode: Bool = false
    
    @State private var isLoading = false

    var userAuthenticated: (() -> Void)

    var body: some View {
        if isSignInMode {
            /// Displays the SignInView when in sign-in mode.
            SignInView(authenticator: authenticator, onSignUp: {
                // Toggle back to sign-up mode with animation.
                withAnimation {
                    isSignInMode.toggle()
                }
            }, userAuthenticated: {
                Task {
                    await syncData()
                    userAuthenticated()
                    dismiss()
                }
            })
            .transition(.slide.combined(with: .opacity)) // Adds animation during view switch.
            .progressHUD(isShowing: $isLoading, title: .constant("Syncing..."))
        } else {
            /// Displays the SignUpView when in sign-up mode.
            SignUpView(authenticator: authenticator, onSignIn: {
                // Toggle to sign-in mode with animation.
                withAnimation {
                    isSignInMode.toggle()
                }
            }, userAuthenticated: {
                Task {
                    await syncData()
                    userAuthenticated()
                    dismiss()
                }
            })
            .transition(.slide.combined(with: .opacity)) // Adds animation during view switch.
            .progressHUD(isShowing: $isLoading, title: .constant("Syncing..."))
        }
    }
    
    private func syncData() async {
        if let user = authenticator.user {
            isLoading = true
            UserDefaults.standard.databaseType = .firebase(user.id)
            UserDefaults.standard.isSignedIn = true
            databaseManager.initializeRemoteRepositoryHandler(firestoreRepositoryHandler(userId: user.id))
            await databaseManager.syncLocalWithRemote()
            await databaseManager.syncRemoteWithLocal()
            await databaseManager.syncUserDetails(user)
            isLoading = false
        }
    }
}

#Preview {
    SignInOrSignUpView() { }
        .environment(FirebaseAuthenticator())
        .environment(DatabaseManager.initWithInMemory)
}
