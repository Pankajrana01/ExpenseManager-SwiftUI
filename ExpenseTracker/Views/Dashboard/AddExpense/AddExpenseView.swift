//
//  AddExpenseView.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 27/03/25.
//

import SwiftUI

/// `AddExpenseView` is a SwiftUI view that allows users to add a new expense.
/// It provides fields for the name, amount, category, date, and notes associated with the expense.
/// The user can save the expense, and the view will notify the parent view by calling the `onSave` closure.
/// If an error occurs during the process, an error alert is shown to the user.
///
/// - Parameters:
///   - databaseManager: The `DatabaseManager` used to interact with the backend database for saving the expense.
///   - onSave: A closure called when the expense is successfully saved, allowing the parent view to refresh or update its data.

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    
    // ViewModel for managing the expense data and handling business logic.
    @State private var viewModel: ViewModel
        
    // Closure called when the expense is successfully saved.
    var onSave: (() -> Void)
    
    // Initializer for the view, taking the databaseManager and onSave closure as parameters.
    init(databaseManager: DatabaseManager, onSave: @escaping () -> Void) {
        _viewModel = State(initialValue: .init(databaseManager: databaseManager))
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            // MARK: Header
            VStack(alignment: .leading, spacing: 6) {
                Text("Fill in the details below")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
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
                
                // Add another button
                Section {
                    FullWidthButton(title: "Add Another", action: addAnotherExpense)
                        .disabled(viewModel.shouldDisabled)
                        .tint(.green1)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Save button: Initiates the process of adding the expense.
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: addExpense)
                        .disabled(viewModel.shouldDisabled)
                }
                
                // Cancel button: Dismisses the view without saving the expense.
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            // Error alert: Displays an error message if something goes wrong while saving the expense.
            .alertPresenter(
                alertType: $viewModel.alertType
            )
        }
    }
    
    /// Adds the expense by calling the `addExpense` method from the `ViewModel`.
    /// If the expense is successfully added, it calls the `onSave` closure and dismisses the view.
    /// If an error occurs, it shows an error alert with the appropriate message.
    func addExpense() {
        Task {
            let success = await viewModel.addExpense()
            if success {
                dismiss()
                onSave()
            }
        }
    }
    
    func addAnotherExpense() {
        Task {
            _ = await viewModel.addExpense()
            viewModel.addAnotherExpense()
        }
    }
}

#Preview {
    AddExpenseView(databaseManager: .initWithInMemory) { }
}


