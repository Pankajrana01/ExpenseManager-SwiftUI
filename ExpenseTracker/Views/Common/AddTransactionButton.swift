//
//  AddTransactionButton.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 05/04/25.
//

import SwiftUI

/// A reusable button view that prompts the user to add a new transaction (income or expense).
/// It is typically shown when there is no data available to display.
struct AddTransactionButton: View {
    
    /// A closure that is called when the user taps the button.
    var onAdd: () -> Void
    
    var body: some View {
        Button {
            onAdd()
        } label: {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: "plus.bubble")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.secondary)
                
                Text("No data available yet.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    AddTransactionButton() { }
}
