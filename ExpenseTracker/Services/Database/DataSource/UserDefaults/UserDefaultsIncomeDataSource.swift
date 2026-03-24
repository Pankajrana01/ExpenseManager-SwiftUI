//
//  UserDefaultsIncomeDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// A concrete implementation of `IncomeDataSource` that uses `UserDefaults`
/// to persist and manage income data locally on the device.
/// This class serializes the array of `DatabaseIncome` to JSON and stores it
/// under a specific key in `UserDefaults`. It's suitable for lightweight local storage.
final class UserDefaultsIncomeDataSource: IncomeDataSource {
    
    /// The internal array that holds all the incomes in memory.
    ///
    /// This property observes changes using `didSet`, and whenever the array is modified
    /// (e.g., an income is added, updated, or removed), it automatically encodes the updated array
    /// to JSON and saves it to `UserDefaults` under the key `UserDefaultsDataSourceKey.incomes`.
    private var _incomes: [DatabaseIncome] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(_incomes) {
                UserDefaults.standard.set(data, forKey: UserDefaultsDataSourceKey.incomes)
            }
        }
    }
    
    /// Initializes a new instance of `UserDefaultsIncomeDataSource`.
    ///
    /// When instantiated, it attempts to read any previously saved income data
    /// from `UserDefaults` and decode it into the `_incomes` array.
    /// If no data exists or decoding fails, the array remains empty.
    init() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsDataSourceKey.incomes) {
            if let decode = try? JSONDecoder().decode([DatabaseIncome].self, from: data) {
                _incomes = decode
            }
        }
    }
    
    /// Adds a new income item to the data source.
    ///
    /// - Parameter item: The `DatabaseIncome` to add.
    /// - Throws: Never throws directly, but conforms to the async throws signature.
    func create(_ item: DatabaseIncome) async throws {
        _incomes.append(item)
    }
    
    /// Returns all income records stored in the data source.
    ///
    /// - Returns: An array of `DatabaseIncome` objects.
    /// - Throws: Never throws directly, but conforms to the async throws signature.
    func readAll() async throws -> [DatabaseIncome] {
        _incomes
    }
    
    /// Updates an existing income entry.
    ///
    /// - Parameter item: The updated `DatabaseIncome` instance.
    /// - Throws: `ExpenseTrackerError.dataNotFound` if the income item with the given ID is not found.
    func update(_ item: DatabaseIncome) async throws {
        guard let index = _incomes.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _incomes[index] = item
    }
    
    /// Deletes a specific income entry.
    ///
    /// - Parameter item: The `DatabaseIncome` instance to delete.
    /// - Throws: `ExpenseTrackerError.dataNotFound` if the income item with the given ID is not found.
    func delete(_ item: DatabaseIncome) async throws {
        guard let index = _incomes.firstIndex(where: { $0.id == item.id }) else {
            throw ExpenseTrackerError.dataNotFound
        }
        _incomes.remove(at: index)
    }
    
    /// Deletes all income entries from the data source.
    ///
    /// This will also trigger the `didSet` observer to update `UserDefaults`.
    /// - Throws: Never throws directly, but conforms to the async throws signature.
    func deleteAll() async throws {
        _incomes.removeAll()
    }
}
