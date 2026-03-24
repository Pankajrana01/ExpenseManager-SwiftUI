//
//  LabeledPicker.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 26/06/25.
//

import SwiftUI

/// A reusable, generic SwiftUI view that presents a labeled picker control for selecting a value from an enumeration.
/// 
/// - Parameters:
///   - label: The text label displayed to the left of the picker.
///   - selection: A binding to the currently selected item of type `T`.
///
/// - Type Constraints:
///   - `T` must conform to `Hashable`, `CaseIterable`, and `Displayable`.
///   - `T.AllCases` must be a `RandomAccessCollection`.
///
/// The picker displays all cases of the generic type `T` (typically an enum) using the `displayName` property
/// from the `Displayable` protocol. It hides the default picker label for a cleaner layout.
///
/// Example usage:
/// ```swift
/// LabeledPicker(label: "Category", selection: $selectedCategory)
/// ```
struct LabeledPicker<T: Hashable & CaseIterable & Displayable>: View where T.AllCases: RandomAccessCollection {
    let label: String
    @Binding var selection: T
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Picker(label, selection: $selection) {
                ForEach(T.allCases, id: \.self) { item in
                    Text(item.displayName)
                }
            }
            .labelsHidden()
        }
    }
}

#Preview {
    LabeledPicker(label: "Category", selection: .constant(Category.education))
}
