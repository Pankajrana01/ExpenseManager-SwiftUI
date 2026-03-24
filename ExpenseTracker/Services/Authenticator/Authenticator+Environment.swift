//
//  Authenticator+Environment.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 22/04/25.
//

import SwiftUI

struct AuthenticatorKey: EnvironmentKey {
    
    /// The default value for the `Authenticator` environment key.
    ///
    /// This fallback instance is used if no explicit `Authenticator` is injected into the environment.
    static let defaultValue: Authenticator = FirebaseAuthenticator()
}

extension EnvironmentValues {
    
    /// The `Authenticator` from the SwiftUI environment.
    ///
    /// Use `@Environment(\.authenticator)` in a view to access the shared user provider.
    var authenticator: Authenticator {
        get { self[AuthenticatorKey.self] }
        set { self[AuthenticatorKey.self] = newValue }
    }
}
