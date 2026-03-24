//
//  IncomeItemView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/05/25.
//

import SwiftUI

/// `IncomeItemView` is a SwiftUI `View` that represents a single income item.
/// It displays the details of the income, including its name, note, date, and amount.
/// The amount is color-coded based on its value for better visual indication.
struct IncomeItemView: View {
    
    /// An instance of the `Income` model containing details of the income.
    let income: Income
    
    /// The body property defines the layout and visual components of the `IncomeItemView`.
    var body: some View {
        HStack {
            Image(systemName: income.source.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.trailing, 10)
                        
            VStack(alignment: .leading) {
                // Displays the name of the income in a headline font.
                Text(income.source.rawValue)
                    .font(AppFont.poppins(.medium, size: 16))
                
                // If the income is Other source type and has a note, display it in a smaller font with a secondary foreground style.
                if income.source == .other && income.note.isNotEmpty {
                    Text("(\(income.note))")
                        .font(AppFont.poppins(.regular, size: 10))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                }
                
                // Displays the date of the income in a shortened format (abbreviated date, no time).
                Text(income.formattedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(AppFont.poppins(.regular, size: 12))
            }
            
            Spacer()
            
            // Displays the amount of the income in a currency format.
            // The currency symbol is based on the user's locale.
            Text("\(income.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                .font(AppFont.poppins(.medium, size: 16))
            
            Image(systemName: "arrow.down.left")
                .foregroundStyle(.green1)
                .padding(.leading, 10)
        }
    }
}

#Preview {
    IncomeItemView(income: .sample)
}
