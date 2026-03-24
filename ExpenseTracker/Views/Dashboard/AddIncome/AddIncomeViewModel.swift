//
//  AddIncomeViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 03/04/25.
//

import Foundation
import Observation

/// `ViewModel` is an observable class responsible for handling business logic related to adding an income.
/// It interacts with the `DatabaseManager` (e.g., a database manager) to save the income data and provides feedback via a completion handler.
/// This class is used within the `AddIncomeView` to manage the state and functionality related to adding an income.
extension AddIncomeView {
    @Observable
    class ViewModel {
        // MARK: - Public Properties

        /// Boolean flags for displaying error and delete confirmation alerts.
        var showError: Bool = false

        /// Error message to display in case of an error.
        var errorMessage: String = ""

        // State properties for handling user input.
        var amount: Double = 0
        var date: Date = Date()
        var source: Source = .salary
        var note: String = ""

        // MARK: - Private Properties

        /// The database manager responsible for handling database operations.
        private let databaseManager: DatabaseManager
        
        /// Initializes the ViewModel with a given `DatabaseManager` (database manager).
        ///
        /// - Parameter databaseManager: An instance of `DatabaseManager` used to interact with the backend or local database.
        init(databaseManager: DatabaseManager) {
            self.databaseManager = databaseManager
        }

        // MARK: - Public Methods

        /// Adds an income by calling the `saveIncome` method of the `databaseManager`.
        ///
        /// This method accepts the necessary income details (amount, date, and source) and passes them to the database manager to be saved.
        ///
        /// - Returns: A `Bool` indicating success or failure. If successful, it returns `true`; otherwise, `false`.
        func addIncome() async -> Bool {
            do {
                return try await databaseManager.saveIncome(.init(id: UUID().uuidString, amount: amount, source: source, date: date, note: note))
            } catch {
                self.showError = true
                self.errorMessage = error.localizedDescription
                return false
            }
        }
    }
}
