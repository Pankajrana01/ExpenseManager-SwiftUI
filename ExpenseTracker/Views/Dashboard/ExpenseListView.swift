//
//  ExpenseListView 2.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/05/25.
//

import SwiftUI

/// A reusable component for displaying a list of recent expenses with sorting, deletion, and editing capabilities.
struct ExpenseListView: View {
    
    /// Indicates whether the sorting order is descending (true) or ascending (false).
    @State private var isDescending = true
    
    @Binding var selectedSortingOption: SortingOption
    
    /// The complete list of expenses provided to this view.
    let expenseList: [Expense]
    
    /// Callback triggered when "See All" is tapped.
    var onSeeAll: () -> Void
    
    /// Callback triggered when the sorting order changes (ascending/descending).
    var onSortingOrderChanged: (Bool) -> Void
    
    /// Callback triggered when the sorting option (date, amount, name) is changed.
    var onSortingOptionChanged: (SortingOption) -> Void
    
    /// Callback triggered when the "Add Expense" button is tapped.
    var onAddExpense: () -> Void
    
    /// Callback triggered when the user deletes an expense.
    var onDeleteExpense: (Expense) -> Void
    
    /// Callback triggered when the user wants to edit/update an expense.
    var onUpdateExpense: (Expense) -> Void
    
    /// A computed property that returns the last 10 expenses (or fewer if less than 10 exist).
    var last10Expenses: [Expense] {
        if expenseList.count >= 10 {
            return Array(expenseList.prefix(10))
        } else {
            return expenseList
        }
    }

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#E5E5FE"), Color(hex: "#E5E5FE"), Color(hex: "#E5E5FE")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Main content
            VStack(alignment: .leading, spacing: 10) {
                // Header: Title, See All, Sorting Buttons
                HStack(spacing: 10) {
                    Text("Recent Expenses")
                        .font(AppFont.poppins(.medium, size: 20))
                        .foregroundStyle(.black1) // Optional for visibility
                    
                    Spacer()
                    
                    if expenseList.count > 10 {
                        Text("See All")
                            .foregroundStyle(.green1)
                            .onTapGesture {
                                onSeeAll()
                            }
                    }
                    
                    Image(systemName: isDescending ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                        .foregroundStyle(.green1)
                        .onTapGesture {
                            isDescending.toggle()
                            onSortingOrderChanged(isDescending)
                        }
                    
                    Menu {
                        ForEach(SortingOption.allCases, id: \.self) { sortingOption in
                            Button {
                                onSortingOptionChanged(sortingOption)
                            } label: {
                                Text(sortingOption.rawValue)
                                    .font(AppFont.poppins(.regular, size: 16))
                                
                                Image(systemName: selectedSortingOption == sortingOption ? "checkmark" : sortingOption.systemImageName)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundStyle(.black)
                    }
                }
                .padding(.vertical, 5)
                
                // Content section
                if last10Expenses.isEmpty {
                    AddTransactionButton {
                        onAddExpense()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(Array(last10Expenses.enumerated()), id: \.element.id) { index, expense in
                        VStack(spacing: 10) {
                            ExpenseItemView(expense: expense)
                                .swipeActions {
                                    Button("Delete", systemImage: "trash") {
                                        onDeleteExpense(expense)
                                    }
                                    .tint(.red1)
                                    
                                    Button("Edit", systemImage: "pencil") {
                                        onUpdateExpense(expense)
                                    }
                                    .tint(.green1)
                                }
                            
                            // Add Divider unless it's the last item
                            if index < last10Expenses.count - 1 {
                                Divider()
                                    .frame(height: 1)
                                    .background(Color.gray.opacity(0.1))
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }

}

#Preview {
    ExpenseListView(selectedSortingOption: .constant(.date), expenseList: [.sample], onSeeAll: { }, onSortingOrderChanged: { _ in }, onSortingOptionChanged: { _ in }, onAddExpense: { }, onDeleteExpense: { _ in }, onUpdateExpense: { _ in })
}
