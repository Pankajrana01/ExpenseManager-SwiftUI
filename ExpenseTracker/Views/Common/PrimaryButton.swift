//
//  PrimaryButton.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 18/04/25.
//

import SwiftUI

/// A reusable primary button component with customizable title, enable state, and action.
///
/// This button adapts to the system's color scheme and applies dynamic styles for both enabled and disabled states.
struct PrimaryButton: View {
    /// The button title displayed to the user.
    let title: String
    
    /// Determines if the button is enabled. If false, the button is disabled and grayed out.
    let isEnabled: Bool
    
    /// The action to execute when the button is tapped.
    let action: () -> Void
    
    /// Initializes a new `PrimaryButton`.
    /// - Parameters:
    ///   - title: The button label.
    ///   - isEnabled: A Boolean value that indicates whether the button is enabled. Defaults to `true`.
    ///   - action: A closure that runs when the button is tapped.
    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        // Button UI and interaction logic
        Button {
            // Trigger the provided action when the button is tapped
            action()
        } label: {
            // Style the button label
            Text(title)
                .font(.headline) // Use a bold, readable font for primary actions
                .foregroundStyle(Color(.systemBackground))
                .frame(maxWidth: .infinity) // Make the button fill the available width
                .padding() // Provide internal padding for touch target and aesthetics
        }
        .disabled(!isEnabled) // Disable the button when `isEnabled` is false
        .background(
            // Set the background color conditionally
            isEnabled ? .green1 : .gray
        )
        .clipShape(
            // Apply rounded corners for modern UI look
            RoundedRectangle(cornerRadius: 10)
        )
    }
}


#Preview {
    PrimaryButton("Test", action: {})
}
