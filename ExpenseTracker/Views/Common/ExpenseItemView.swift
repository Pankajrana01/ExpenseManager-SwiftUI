//
//  ExpenseItemView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 06/04/25.
//

import SwiftUI

/// `ExpenseItemView` is a SwiftUI `View` that represents a single expense item.
/// It displays the details of the expense, including its name, note, date, and amount.
/// The amount is color-coded based on its value for better visual indication.
struct ExpenseItemView: View {
    
    /// An instance of the `Expense` model containing details of the expense.
    let expense: Expense
    
    /// The body property defines the layout and visual components of the `ExpenseItemView`.
    var body: some View {
        HStack {
            Image(systemName: expense.category.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                // Displays the name of the expense in a headline font.
                Text(expense.name)
                    .font(AppFont.poppins(.medium, size: 16))
                
                // If the expense has a note, display it in a smaller font with a secondary foreground style.
                if !expense.note.isEmpty {
                    Text("(\(expense.note))")
                        .font(AppFont.poppins(.regular, size: 10))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                }
                
                // Displays the date of the expense in a shortened format (abbreviated date, no time).
                Text(expense.formattedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(AppFont.poppins(.regular, size: 12))
            }
            
            Spacer()
            
            // Displays the amount of the expense in a currency format.
            // The currency symbol is based on the user's locale.
            Text("\(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                .font(AppFont.poppins(.medium, size: 16))
            
            Image(systemName: "arrow.up.right")
                .foregroundStyle(.red1)
                .padding(.leading, 10)
        }
    }
}

#Preview {
    ExpenseItemView(expense: .sample)
}
