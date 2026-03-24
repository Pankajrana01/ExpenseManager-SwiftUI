//
//  EditExpenseView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/03/25.
//

import SwiftUI

/// `EditExpenseView` is a SwiftUI view that allows users to edit an existing expense.
/// It provides a form with input fields for the expense's name, note, amount, category, and date.
/// The view allows users to update or delete the expense and shows alerts for errors or delete confirmation.
struct EditExpenseView: View {
    
    /// Environment variable to dismiss the current view.
    @Environment(\.dismiss) var dismiss
    
    /// The view model for handling data-related operations.
    @State private var viewModel: ViewModel
    
    /// Closure that is executed when the expense is successfully updated.
    var onUpdate: () -> Void
    
    /// Initializes the `EditExpenseView` with the expense to edit and a closure to call after updating.
    /// - Parameters:
    ///   - expense: The `Expense` to be edited.
    ///   - databaseManager: The database manager responsible for performing data operations.
    ///   - onUpdate: A closure to call when the expense is successfully updated.
    init(expense: Expense, databaseManager: DatabaseManager, onUpdate: @escaping () -> Void) {
        self.viewModel = .init(expense: expense, databaseManager: databaseManager)
        self.onUpdate = onUpdate
    }
    
    /// The body of the view, containing a form with input fields for the expense details and action buttons.
    var body: some View {
        NavigationStack {
            Form {
                ExpenseFormView(
                    name: $viewModel.name,
                    note: $viewModel.note,
                    amount: $viewModel.amount,
                    category: $viewModel.category,
                    date: $viewModel.date,
                    showInfo: {
                        viewModel.alertType = .category(name: viewModel.category.displayName, description: viewModel.category.description)
                    }
                )
                
                // Delete button
                Section {
                    FullWidthButton(title: "Delete") {
                        viewModel.alertType = .deleteExpense(viewModel.expense)
                    }
                    .tint(.red)
                }
            }
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Update button
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Update", action: updateExpense)
                        .disabled(viewModel.name.isEmpty || viewModel.amount == 0)
                }
                
                // Cancel button
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alertPresenter(
                alertType: $viewModel.alertType,
                onDeleteExpense: { expense in
                    deleteExpense()
                }
            )
        }
    }
    
    /// Updates the expense with the new values from the form.
    /// This method calls the view model to perform the update in the database and triggers the `onUpdate` closure on success.
    func updateExpense() {
        Task {
            let success = await viewModel.updateExpense()
            if success {
                onUpdate()
                dismiss()
            }
        }
    }
    
    /// Deletes the expense.
    /// This method calls the view model to perform the delete operation and dismisses the view on success.
    func deleteExpense() {
        Task {
            let success = await viewModel.deleteExpense()
            if success {
                onUpdate()
                dismiss()
            }
        }
    }
}

#Preview {
    EditExpenseView(expense: .sample, databaseManager: .initWithInMemory) { }
}
