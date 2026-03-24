//
//  EditExpenseViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/03/25.
//

import Foundation
import Observation

/// `ViewModel` is a class responsible for handling the business logic and interacting with the database manager to update or delete an expense.
/// It provides methods to update and delete expenses from the database and returns results via completion handlers.
extension EditExpenseView {
    @Observable
    class ViewModel {
        // MARK: - Public Properties
                
        /// State properties for storing the edited expense values.
        var amount: Double
        var category: Category
        var date: Date
        var name: String
        var note: String
                
        /// A variable to control the visibility of the delete confirmation alert for
        /// an expense as well as error message and displaying description of expense category.
        var alertType: AlertType? = nil

        /// The expense to be edited.
        let expense: Expense

        // MARK: - Private Properties
        
        /// The database manager responsible for performing data operations.
        private let databaseManager: DatabaseManager
        
        /// Initializes the `ViewModel` with a database manager.
        /// - Parameters:
        ///   - expense: The `Expense` to be edited.
        ///   - databaseManager: The `DatabaseManager` that provides database operations (e.g., update, delete).
        init(expense: Expense, databaseManager: DatabaseManager) {
            self.databaseManager = databaseManager
            self.expense = expense
            self.amount = expense.amount
            self.category = expense.category
            self.date = expense.formattedDate
            self.name = expense.name
            self.note = expense.note
        }
        
        // MARK: - Public Methods
        
        /// Updates an existing expense in the database.
        /// - Returns: A `Bool` indicating success (`true`) or failure (`false`).
        func updateExpense() async -> Bool {
            do {
                return try await databaseManager.updateExpense(
                    .init(
                        id: expense.id,
                        name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        amount: amount,
                        date: date,
                        category: category,
                        note: note.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                )
            } catch {
                alertType = .error(message: error.localizedDescription)
                return false
            }
        }
        
        /// Deletes an expense from the database.
        /// - Returns: A `Bool` indicating success (`true`) or failure (`false`).
        func deleteExpense() async -> Bool {
            do {
                return try await databaseManager.deleteExpense(expense)
            } catch {
                alertType = .error(message: error.localizedDescription)
                return false
            }
        }
    }
}
