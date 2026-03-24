//
//  InMemoryExpenseDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// An in-memory implementation of `ExpenseDataSource` used primarily for testing, previews, or temporary data storage.
///
/// This class mimics persistent data behavior by storing expenses in a local array.
/// It conforms to `ExpenseDataSource`, which includes standard CRUD operations and bulk operations.
final class InMemoryExpenseDataSource: ExpenseDataSource {
    
    /// An internal array that stores expense items in memory.
    /// Preloaded with some sample data for testing or preview purposes.
    private var _expenses: [DatabaseExpense] = [.sample1_1, .sample2_1, .sample3_1, .sample4_1, .sample1, .sample2, .sample3, .sample4]
    
    /// Adds a new `DatabaseExpense` to the in-memory list.
    /// - Parameter item: The expense to be added.
    func create(_ item: DatabaseExpense) async throws {
        _expenses.append(item)
    }
    
    /// Retrieves all stored expenses.
    /// - Returns: An array of `DatabaseExpense` items.
    func readAll() async throws -> [DatabaseExpense] {
        _expenses
    }
    
    /// Updates an existing expense if its `id` matches an existing one in memory.
    /// - Parameter item: The updated expense item.
    /// - Throws: `ExpenseTrackerError.dataNotFound` if the item does not exist.
    func update(_ item: DatabaseExpense) async throws {
        guard let index = _expenses.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _expenses[index] = item
    }
    
    /// Deletes a specific expense from memory if it exists.
    /// - Parameter item: The expense to be deleted.
    /// - Throws: `ExpenseTrackerError.dataNotFound` if the item does not exist.
    func delete(_ item: DatabaseExpense) async throws {
        guard let index = _expenses.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _expenses.remove(at: index)
    }
    
    /// Clears all stored expenses from memory.
    func deleteAll() async throws {
        _expenses.removeAll()
    }
}
