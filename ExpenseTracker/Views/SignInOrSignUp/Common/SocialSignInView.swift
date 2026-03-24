//
//  SocialSignInView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 19/04/25.
//

import SwiftUI

/// A view that presents a Google sign-in button and a divider with an "or" separator.
/// Intended to be used in sign-in or sign-up flows to offer social authentication options.
struct SocialSignInView: View {
    
    /// Closure to be executed when the user taps the "Sign in with Google" button.
    var onGoogleSignIn: () -> Void
    
    var body: some View {
        VStack {
            /// Custom-styled button for Google Sign-In.
            
            Button(action: onGoogleSignIn) {
                Text("Sign in with Google")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(alignment: .leading) {
                        Image("Google")
                            .frame(width: 30, alignment: .center)
                    }
            }
            .buttonStyle(.bordered)
            
            /// Visual divider with "or" text to separate social and manual sign-in options.
            HStack(spacing: 20) {
                Rectangle()
                    .foregroundStyle(.secondary.opacity(0.5))
                    .frame(height: 1)
                
                Text("or")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Rectangle()
                    .foregroundStyle(.secondary.opacity(0.5))
                    .frame(height: 1)
            }
            .padding(.top)
        }
    }
}

#Preview {
    SocialSignInView() { }
}
