//
//  SyncButtonToolbarModifier.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 18/04/25.
//

import SwiftUI

/// A `ViewModifier` that adds a toolbar button to the top leading corner,
/// enabling user sign-in/sign-out and syncing data with a selected database source.
struct ToolbarSyncButtonModifier: ViewModifier {
    @Environment(\.authenticator) private var authenticator
    @Environment(DatabaseManager.self) private var databaseManager
    @Environment(NotificationManager.self) private var notificationManager
    
    @State private var isPresented = false
        
    var userAuthenticated: (() -> Void)

    /// The body of the modified view, injecting a toolbar with a sign-in/out button
    /// and handling database switching logic based on user session state.
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    // Toggle the account sheet when tapped
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
            // Present sheet to either show account info or SignIn/SignUp view
            .sheet(isPresented: $isPresented, content: {
                if UserDefaults.standard.isSignedIn {
                    AccountView(authenticator: authenticator, databaseManager: databaseManager, notificationManager: notificationManager)
                } else {
                    SignInOrSignUpView(userAuthenticated: userAuthenticated)
                }
            })
    }
}

extension View {
    /// Applies the toolbar sync button modifier to the view.
    ///
    /// This adds a person icon to the top leading corner, allowing user authentication
    /// and syncing between local and Firebase databases.
    func toolbarSyncButton(userAuthenticated: @escaping () -> Void) -> some View {
        self.modifier(ToolbarSyncButtonModifier(userAuthenticated: userAuthenticated))
    }
}
