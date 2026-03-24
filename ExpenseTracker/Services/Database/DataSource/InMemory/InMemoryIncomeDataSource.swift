//
//  InMemoryIncomeDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// An in-memory implementation of `IncomeDataSource` for use in development, testing, or previews.
///
/// This data source stores `DatabaseIncome` items in a local array and supports basic CRUD operations.
/// Since it's in-memory, all data is lost when the instance is deallocated or the app restarts.
final class InMemoryIncomeDataSource: IncomeDataSource {
    
    /// Internal storage for all in-memory income records.
    /// Initialized with sample data to simulate pre-existing income entries.
    private var _incomes: [DatabaseIncome] = [.sample1_1, .sample2_1, .sample3_1, .sample1, .sample2, .sample3]
        
    /// Adds a new income entry to the in-memory list.
    /// - Parameter item: The `DatabaseIncome` object to be stored.
    func create(_ item: DatabaseIncome) async throws {
        _incomes.append(item)
    }
    
    /// Retrieves all income entries currently stored in memory.
    /// - Returns: An array of `DatabaseIncome` objects.
    func readAll() async throws -> [DatabaseIncome] {
        _incomes
    }
    
    /// Updates an existing income entry by replacing it with a new one that has the same `id`.
    /// - Parameter item: The updated `DatabaseIncome` object.
    /// - Throws: `ExpenseTrackerError.dataNotFound` if no entry with the given ID exists.
    func update(_ item: DatabaseIncome) async throws {
        guard let index = _incomes.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _incomes[index] = item
    }
    
    /// Deletes an income entry from memory if it matches the given item's `id`.
    /// - Parameter item: The `DatabaseIncome` object to be deleted.
    /// - Throws: `ExpenseTrackerError.dataNotFound` if no entry with the given ID is found.
    func delete(_ item: DatabaseIncome) async throws {
        guard let index = _incomes.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _incomes.remove(at: index)
    }
    
    /// Deletes all income records from the in-memory store.
    func deleteAll() async throws {
        _incomes.removeAll()
    }
}
