//
//  EmailPasswordForm.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 05/05/25.
//

import SwiftUI

/// A reusable form view for capturing user sign-up details.
struct EmailPasswordForm: View {
    /// The user's email address (bound to a parent view's state).
    @Binding var email: String
    
    /// The user's password (bound to a parent view's state).
    @Binding var password: String
    
    var buttonLabel: String
    
    /// A closure executed when the user taps the "Continue" button.
    var action: () -> Void
    
    var body: some View {
        VStack {
            VStack {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .padding(.top, 10)
                Divider()
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .autocapitalization(.none)
                    .padding()
                    .padding(.bottom, 10)
            }
            .background(.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .cornerRadius(10)
            
            PrimaryButton(buttonLabel, isEnabled: !email.isEmpty || !password.isEmpty, action: action)
                .padding(.top, 30)
        }
    }
}

#Preview {
    EmailPasswordForm(email: .constant(""), password: .constant(""), buttonLabel: "Sign Up", action: {})
}
