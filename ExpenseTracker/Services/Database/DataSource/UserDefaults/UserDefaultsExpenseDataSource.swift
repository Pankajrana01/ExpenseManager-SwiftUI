//
//  UserDefaultsExpenseDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// A concrete implementation of `ExpenseDataSource` that persists `DatabaseExpense` items using `UserDefaults`.
///
/// This data source is ideal for lightweight persistence needs such as prototyping, previewing, or apps that don't require
/// full database capabilities. Data is encoded to and decoded from JSON using `Codable`.
final class UserDefaultsExpenseDataSource: ExpenseDataSource {
    
    /// The internal in-memory cache of all saved expenses.
    ///
    /// Whenever this array is modified (e.g., via create, update, or delete),
    /// the entire array is automatically re-encoded and saved to `UserDefaults`.
    private var _expenses: [DatabaseExpense] = [] {
        didSet {
            // Persist the updated expenses array to UserDefaults.
            // It is encoded as JSON and stored using a static key.
            if let data = try? JSONEncoder().encode(_expenses) {
                UserDefaults.standard.set(data, forKey: UserDefaultsDataSourceKey.expenses)
            }
        }
    }
    
    /// Initializes the data source and loads any previously saved expenses from `UserDefaults`.
    ///
    /// If the stored data exists and is valid, it is decoded and set to `_expenses`.
    /// Otherwise, `_expenses` remains an empty array.
    init() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsDataSourceKey.expenses) {
            if let decode = try? JSONDecoder().decode([DatabaseExpense].self, from: data) {
                _expenses = decode
            }
        }
    }
    
    /// Persists a new expense by appending it to the internal list.
    ///
    /// The change is automatically saved to `UserDefaults` due to the `didSet` observer.
    /// - Parameter item: The `DatabaseExpense` to add.
    func create(_ item: DatabaseExpense) async throws {
        _expenses.append(item)
    }
    
    /// Returns all stored expenses.
    /// - Returns: An array of all `DatabaseExpense` items saved in memory (and by extension, in `UserDefaults`).
    func readAll() async throws -> [DatabaseExpense] {
        _expenses
    }
    
    /// Updates an existing expense item that matches the given item's ID.
    ///
    /// If no matching ID is found, an error is thrown.
    /// - Parameter item: The updated `DatabaseExpense`.
    func update(_ item: DatabaseExpense) async throws {
        guard let index = _expenses.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _expenses[index] = item
    }
    
    /// Deletes a specific expense item by matching its ID.
    ///
    /// If no match is found, an error is thrown.
    /// - Parameter item: The `DatabaseExpense` to delete.
    func delete(_ item: DatabaseExpense) async throws {
        guard let index = _expenses.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _expenses.remove(at: index)
    }
    
    /// Clears all stored expenses from memory and `UserDefaults`.
    ///
    /// This operation effectively resets the expense data to an empty list.
    func deleteAll() async throws {
        _expenses.removeAll()
    }
}
