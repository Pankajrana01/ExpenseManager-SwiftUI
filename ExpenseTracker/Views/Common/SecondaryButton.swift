//
//  SecondaryButton.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 19/04/25.
//

import SwiftUI

/// A reusable secondary button with an outlined green border.
///
/// This button is designed for less prominent actions compared to a primary button,
/// maintaining a consistent layout and interaction style across the app.
struct SecondaryButton: View {
    
    /// The text to display on the button.
    let title: String
    
    /// The action to perform when the button is tapped.
    let action: () -> Void
    
    /// Initializes a new instance of `SecondaryButton`.
    /// - Parameters:
    ///   - title: The button's label.
    ///   - action: A closure executed when the button is tapped.
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        // Button view with a custom label and tap action
        Button {
            // Execute the provided action when tapped
            action()
        } label: {
            // Style the label text
            Text(title)
                .frame(maxWidth: .infinity) // Make the button expand to fill the width
                .padding() // Add internal padding for better tap target and spacing
        }
        .overlay {
            // Add an outlined border around the button using a rounded rectangle
            RoundedRectangle(cornerRadius: 10)
                .stroke(.green1, lineWidth: 1) // Custom green border with 1pt thickness
        }
    }
}


#Preview {
    SecondaryButton("Save", action: { })
}
