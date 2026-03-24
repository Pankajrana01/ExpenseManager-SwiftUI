//
//  SignUpViewModelTests.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 22/04/25.
//

import Testing
@testable import ExpenseTracker

@Suite("SignUpViewModel Tests")
struct SignUpViewModelTests {
    var viewModel: SignUpView.ViewModel
    var authenticator: MockAuthenticator
    
    init() async throws {
        authenticator = MockAuthenticator()
        viewModel = .init(authenticator: authenticator)
    }

    @Test("Sign up - Success", .tags(.signUp))
    func signUpSuccess() async throws {
        viewModel.email = "test123@example.com"
        viewModel.password = "12345678"
        await viewModel.signUp()
        
        #expect(viewModel.showError == false)
        #expect(viewModel.errorMessage == "")
    }
    
    @Test("Sign up - Failure(Email already exists)", .tags(.signUp))
    func signUpFailureEmailExists() async throws {
        viewModel.email = "test@example.com"
        viewModel.password = "12345678"
        
        await viewModel.signUp()
        
        #expect(viewModel.showError == true)
        #expect(viewModel.errorMessage == "Email already exists")
    }
    
    @Test("Sign up - Failure(Password too short)", .tags(.signUp))
    func signUpFailurePasswordShort() async throws {
        viewModel.email = "test123@example.com"
        viewModel.password = "123456"
        
        await viewModel.signUp()
        
        #expect(viewModel.showError == true)
        #expect(viewModel.errorMessage == "Password should be at least 8 characters long")
    }
    
    @Test("Sign up with Google - Success", .tags(.signUp))
    func signUpWithGoogleSuccess() async throws {
        await viewModel.signUpWithGoogle()
        
        #expect(viewModel.showError == false)
        #expect(viewModel.errorMessage == "")
    }
    
    @Test("Sign up with Google - Failure", .tags(.signUp))
    func signUpWithGoogleFailure() async throws {
        authenticator.shouldFailGoogleSignIn = true
        await viewModel.signUpWithGoogle()
        
        #expect(viewModel.showError == true)
        #expect(viewModel.errorMessage == "Google sign in failed")
    }
}
