//
//  EditIncomeViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 03/04/25.
//

import Foundation
import Observation

/// `ViewModel` is a class responsible for handling the business logic and interacting with the database manager to update or delete an income.
/// It provides methods to update and delete incomes from the database and returns results via completion handlers.
extension EditIncomeView {
    @Observable
    class ViewModel {
        // MARK: - Public Properties
        
        /// State properties for storing the edited income values.
        var amount: Double
        var source: Source
        var date: Date
        var note: String
                
        /// A variable to control the visibility of the delete confirmation alert for
        /// an expense as well as error message and displaying description of expense category.
        var alertType: AlertType? = nil

        /// The income to be edited.
        let income: Income

        // MARK: - Private Properties

        /// The database manager responsible for performing data operations.
        private let databaseManager: DatabaseManager
        
        /// Initializes the `ViewModel` with a database manager.
        /// - Parameters:
        ///   - income: The `Income` to be edited.
        ///   - databaseManager: The `DatabaseManager` that provides database operations (e.g., update, delete).
        init(income: Income, databaseManager: DatabaseManager) {
            self.income = income
            self.databaseManager = databaseManager
            self.amount = income.amount
            self.source = income.source
            self.date = income.formattedDate
            self.note = income.note
        }
        
        // MARK: - Public Methods

        /// Updates an existing income in the database.
        /// - Returns: A `Bool` indicating success (`true`) or failure (`false`).
        func updateIncome() async -> Bool {
            do {
                let updatedNote = source == .other ? note : ""
                return try await databaseManager.updateIncome(.init(id: income.id, amount: amount, source: source, date: date, note: updatedNote))
            } catch {
                alertType = .error(message: error.localizedDescription)
                return false
            }
        }
        
        /// Deletes an income from the database.
        /// - Returns: A `Bool` indicating success (`true`) or failure (`false`).
        func deleteIncome() async -> Bool {
            do {
                return try await databaseManager.deleteIncome(income)
            } catch {
                alertType = .error(message: error.localizedDescription)
                return false
            }
        }
    }
}
