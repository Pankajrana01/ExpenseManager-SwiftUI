//  ExpenseFormView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/03/25.
//

import SwiftUI

/// A SwiftUI view that displays a form for entering or editing an expense's details.
///
/// `ExpenseFormView` provides input fields and pickers for the name, note, amount,
/// category, and date of an expense. It also shows an informational panel when
/// the info button for the category is tapped.
///
/// - Parameters:
///   - name: The name or title of the expense. Bound to a `String`.
///   - note: Additional notes about the expense. Bound to a `String`.
///   - amount: The monetary value of the expense. Bound to a `Double`.
///   - category: The selected expense category. Bound to a `Category`.
///   - date: The date the expense occurred. Bound to a `Date`.
///   - showInfo: Controls the visibility of category info. Bound to a `Bool`.
///
/// The form includes labeled fields for each attribute and can be embedded in
/// other views for creating or editing expenses.
struct ExpenseFormView: View {
    @Binding var name: String
    @Binding var note: String
    @Binding var amount: Double
    @Binding var category: Category
    @Binding var date: Date
    let showInfo: (() -> Void)?

    var body: some View {
        Group {
            // Name field
            LabeledTextField(label: "Name", placeholder: "Lunch, Dinner, etc.", text: $name)
            // Note field
            LabeledTextField(label: "Note", placeholder: "Note", text: $note)
            // Amount field
            LabeledCurrencyField(label: "Amount", placeholder: "Amount", value: $amount)
            // Expense Type picker
            LabeledPickerWithInfo(label: "Category", selection: $category, showInfo: showInfo)
            // Date picker
            LabeledDatePicker(label: "Date", date: $date)
        }
    }
}

#if DEBUG
#Preview {
    struct PreviewWrapper: View {
        @State var name = "Lunch"
        @State var note = "With friends"
        @State var amount = 20.0
        @State var category: Category = .food
        @State var date: Date = .now
        
        var body: some View {
            ExpenseFormView(
                name: $name,
                note: $note,
                amount: $amount,
                category: $category,
                date: $date,
                showInfo: { }
            )
        }
    }
    return PreviewWrapper()
}
#endif
