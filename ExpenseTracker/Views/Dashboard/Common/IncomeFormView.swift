//
//  IncomeFormView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 26/06/25.
//

import SwiftUI

/// A SwiftUI view that provides a form for user input related to income entries.
/// 
/// `IncomeFormView` is a reusable form component for collecting and editing income information. 
/// It includes fields for the amount, income source, note (conditionally if the source is `.other`), and date.
/// 
/// - Parameters:
///   - amount: A binding to the income amount as a `Double`.
///   - source: A binding to the selected `Source` of income.
///   - note: A binding to an optional note describing the income (shown only if `source` is `.other`).
///   - date: A binding to the `Date` the income was received.
/// 
/// The form uses custom labeled field views to improve usability and consistency.
///
struct IncomeFormView: View {
    @Binding var amount: Double
    @Binding var source: Source
    @Binding var note: String
    @Binding var date: Date

    var body: some View {
        Group {
            // Amount field
            LabeledCurrencyField(label: "Amount", placeholder: "Amount", value: $amount)
            // Source Type picker
            LabeledPicker(label: "Source", selection: $source)

            if source == .other {
                // Note field
                LabeledTextField(label: "Note", placeholder: "Note", text: $note)
            }
            // Date picker
            LabeledDatePicker(label: "Date", date: $date)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var amount = 2000.0
        @State var source: Source = .salary
        @State var note = "With friends"
        @State var date: Date = .now
        
        var body: some View {
            IncomeFormView(
                amount: $amount,
                source: $source,
                note: $note,
                date: $date
            )
        }
    }
    return PreviewWrapper()
}
