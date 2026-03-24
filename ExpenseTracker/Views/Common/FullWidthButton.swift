//
//  FullWidthButton.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 25/06/25.
//

import SwiftUI

/// A reusable SwiftUI view that displays a button spanning the full available width.
/// 
/// `FullWidthButton` presents a button styled to occupy the maximum horizontal space within its parent. 
/// The button displays a customizable title and executes a specified action when tapped.
///
/// - Parameters:
///   - title: The text displayed within the button.
///   - action: The closure executed when the button is tapped.
///
/// ## Example
/// ```swift
/// FullWidthButton(title: "Confirm", action: {
///     // Handle button tap
/// })
/// ```
///
/// Use this view to create prominent, easy-to-tap buttons, particularly in forms or modal dialogs.
struct FullWidthButton: View {
    /// The text to display on the button.
    let title: String
    
    /// The action to perform when the button is tapped.
    let action: () -> Void

    var body: some View {
        
        Button(action: action) {
            HStack(alignment: .center) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    FullWidthButton(title: "Button", action: { })
}
