//
//  SignInViewModelTests.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 22/04/25.
//

import Testing
@testable import ExpenseTracker

@Suite("SignInViewModel Tests")
struct SignInViewModelTests {
    var viewModel: SignInView.ViewModel
    var authenticator: MockAuthenticator
    
    init() async throws {
        authenticator = MockAuthenticator()
        viewModel = .init(authenticator: authenticator)
    }

    @Test("Sign in - Success", .tags(.signIn))
    func signInSuccess() async throws {
        viewModel.email = "test@example.com"
        viewModel.password = "12345678"
        await viewModel.signIn()
        
        #expect(viewModel.showError == false)
        #expect(viewModel.errorMessage == "")
    }
    
    @Test("Sign in - Failure(Email is not registered)", .tags(.signIn))
    func signInFailureEmailUnregistered() async throws {
        viewModel.email = "test123@example.com"
        viewModel.password = "12345678"
        await viewModel.signIn()
        
        #expect(viewModel.showError == true)
        #expect(viewModel.errorMessage == "Email is not registered")
    }
    
    @Test("Sign in - Failure(Password is incorrect)", .tags(.signIn))
    func signInFailurePasswordIncorrect() async throws {
        viewModel.email = "test@example.com"
        viewModel.password = "123456"
        await viewModel.signIn()
        
        #expect(viewModel.showError == true)
        #expect(viewModel.errorMessage == "Password is incorrect")
    }
    
    @Test("Sign in with Google - Success", .tags(.signIn))
    func signInWithGoogleSuccess() async throws {
        await viewModel.signInWithGoogle()
        
        #expect(viewModel.showError == false)
        #expect(viewModel.errorMessage == "")
    }
    
    @Test("Sign in with Google - Failure", .tags(.signIn))
    func signInWithGoogleFailure() async throws {
        authenticator.shouldFailGoogleSignIn = true
        await viewModel.signInWithGoogle()
        
        #expect(viewModel.showError == true)
        #expect(viewModel.errorMessage == "Google sign in failed")
    }
}
