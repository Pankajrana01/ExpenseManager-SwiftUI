//
//  LabeledCurrencyField.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 23/06/25.
//

import SwiftUI

/// A labeled currency input field for SwiftUI forms.
///
/// `LabeledCurrencyField` displays a horizontal stack with a label on the leading side
/// and a currency-formatted text field on the trailing side. It uses the device's current
/// locale for currency formatting by default, falling back to "USD" if unavailable.
///
/// - Parameters:
///   - label: The text label describing the value being entered (e.g., "Amount").
///   - placeholder: The placeholder text shown when the text field is empty.
///   - value: A binding to a `Double` value representing the currency amount entered by the user.
///
/// The field uses a decimal keypad and right-aligns the input text for typical currency entry.
///
/// Example usage:
/// ```swift
/// LabeledCurrencyField(label: "Amount", placeholder: "Enter amount", value: $amount)
/// ```
struct LabeledCurrencyField: View {
    let label: String
    let placeholder: String
    @Binding var value: Double

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField(placeholder, value: $value, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    LabeledCurrencyField(label: "Amount", placeholder: "Enter amount", value: .constant(100.0))
}
