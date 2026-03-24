//
//  LabeledDatePicker.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 23/06/25.
//

import SwiftUI

/// A view that displays a labeled date picker UI component.
///
/// `LabeledDatePicker` provides a convenient way to present a `DatePicker`
/// with a specified label and two-way binding to a `Date` value.
///
/// - Parameters:
///   - label: The descriptive text displayed alongside the date picker.
///   - date: A binding to the selected `Date`. Updates to the picker update the bound value.
///
/// The picker will display only the date component, hiding the time selection.
///
struct LabeledDatePicker: View {
    let label: String
    @Binding var date: Date
    
    var body: some View {
        DatePicker(label, selection: $date, displayedComponents: .date)
    }
}

#Preview {
    LabeledDatePicker(label: "Date", date: .constant(Date()))
}
