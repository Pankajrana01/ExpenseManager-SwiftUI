//
//  LabeledPickerWithInfo.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 23/06/25.
//

import SwiftUI

/// A customizable labeled picker view with an optional info button.
///
/// `LabeledPickerWithInfo` displays a label alongside a SwiftUI `Picker` for a generic type `T`
/// that conforms to `Hashable`, `CaseIterable`, and `Displayable`. An optional info button may also be shown.
///
/// - Parameters:
///   - label: The text label displayed to the left of the picker.
///   - selection: A binding to the selected item of type `T`.
///   - showInfo: An optional closure executed when the info button is tapped. If `nil`, the button is not displayed.
///
/// `T` must conform to:
///   - `Hashable`: To uniquely identify each case in the picker.
///   - `CaseIterable`: To enumerate all possible selections.
///   - `Displayable`: To provide a user-facing display name for each case.
///
/// The view arranges its content in a horizontal stack:
///   - The label is shown on the leading edge.
///   - The picker displays all cases of `T`, using `displayName` for each item.
///   - If `showInfo` is provided, an info button appears on the trailing edge, styled with the `.green1` foreground color.
///
/// Example usage:
/// ```swift
/// LabeledPickerWithInfo(label: "Category", selection: $selectedCategory) {
///     // Show info modal or perform an action
/// }
/// ```
struct LabeledPickerWithInfo<T: Hashable & CaseIterable & Displayable>: View where T.AllCases: RandomAccessCollection {
    let label: String
    @Binding var selection: T
    let showInfo: (() -> Void)?
    
    var body: some View {
        HStack {
            LabeledPicker(label: label, selection: $selection)
            
            if let showInfo = showInfo {
                Button(action: showInfo) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.green1)
                }
                .buttonStyle(.plain)
            }
        }
    }
}


#Preview {
    LabeledPickerWithInfo(label: "Category", selection: .constant(Category.education)) { }
}
