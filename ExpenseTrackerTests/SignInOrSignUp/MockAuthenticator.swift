//
//  MockAuthenticator.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 22/04/25.
//

import Foundation
@testable import ExpenseTracker

class MockAuthenticator: Authenticator {
    
    private(set) var isLoading: Bool = false
    
    private var signInEmail = "test@example.com"
    private var signInPassword = "12345678"
    
    private var existingEmails: Set<String> = ["test@example.com", "another@example.com", "yetanother@example.com"]
    
    private var existingUser: User = .init(id: "123", email: "test@example.com")
    
    var shouldFailGoogleSignIn = false
    
    var user: User?
    
    func signIn(email: String, password: String) async throws {
        if email != self.signInEmail {
            throw AuthenticationError.error("Email is not registered")
        }
        if password != self.signInPassword {
            throw AuthenticationError.error("Password is incorrect")
        }
        user = existingUser
    }
    
    func signUp(email: String, password: String) async throws {
        if existingEmails.contains(email) {
            throw AuthenticationError.error("Email already exists")
        }
        if password.count < 8 {
            throw AuthenticationError.error("Password should be at least 8 characters long")
        }
        user = existingUser
    }
    
    func signOut() throws {
        if user == nil {
            throw AuthenticationError.error("User is not signed in")
        }
        user = nil
    }
    
    func signInWithGoogle() async throws {
        if shouldFailGoogleSignIn {
            throw AuthenticationError.error("Google sign in failed")
        }
        user = existingUser
    }
    
    func updateEmail(_ email: String) async throws {
        if existingEmails.contains(email) {
            throw AuthenticationError.error("Email already exists")
        }
    }
    
    func reauthenticate(email: String, password: String) async throws {
        try await signIn(email: email, password: password)
    }
    
    func updatePassword(_ newPassword: String) async throws {
        if newPassword.count < 8 {
            throw AuthenticationError.error("Password should be at least 8 characters long")
        }
        user = existingUser
    }
}
