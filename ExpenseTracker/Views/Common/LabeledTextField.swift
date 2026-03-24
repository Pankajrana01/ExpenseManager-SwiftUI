//
//  LabeledTextField.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 23/06/25.
//

import SwiftUI

/// A reusable SwiftUI view that displays a horizontally arranged label and a text field.
/// 
/// `LabeledTextField` is useful for forms or settings screens where you want to show a descriptive label
/// next to an editable text field. The label appears on the leading side, while the text field is right-aligned.
/// 
/// - Parameters:
///   - label: The text to display as the label on the left.
///   - placeholder: The placeholder text shown in the text field when it is empty.
///   - text: A binding to the string value being edited.
///   - keyboardType: The type of keyboard to display. Defaults to `.default`.
/// 
/// Example usage:
/// ```swift
/// LabeledTextField(label: "Amount", placeholder: "Enter amount", text: $amount, keyboardType: .decimalPad)
/// ```
struct LabeledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    LabeledTextField(label: "Name", placeholder: "Enter your name", text: .constant("Test"))
}
