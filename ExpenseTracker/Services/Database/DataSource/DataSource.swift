//
//  DataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// A generic base data source protocol for performing basic CRUD operations on a data type.
///
/// Conforming types define what `Item` represents (e.g., `DatabaseExpense`, `DatabaseUser`, etc.)
protocol BaseDataSource {
    associatedtype Item

    /// Creates a new item in the data source.
    /// - Parameter item: The item to be created.
    func create(_ item: Item) async throws

    /// Updates an existing item in the data source.
    /// - Parameter item: The updated item to persist.
    func update(_ item: Item) async throws

    /// Deletes a specific item from the data source.
    /// - Parameter item: The item to delete.
    func delete(_ item: Item) async throws
}

/// A specialized data source protocol for transaction-like entities (e.g., expenses, incomes)
/// that can be created, updated, deleted, and fetched in bulk.
protocol TransactionDataSource: BaseDataSource {
    
    /// Fetches all items from the data source.
    /// - Returns: An array of items of the associated type.
    func readAll() async throws -> [Item]

    /// Deletes all items from the data source.
    func deleteAll() async throws
}

/// A data source protocol specialized for handling user-related data.
///
/// `Item` is explicitly constrained to `DatabaseUser`.
protocol UserDataSource: BaseDataSource where Item == DatabaseUser {
    
    /// Reads and returns the user item from the data source.
    /// - Returns: The user item, or `nil` if not found.
    func read() async throws -> Item?
}

/// A data source protocol for managing expense-related data.
///
/// Inherits bulk read and delete operations from `TransactionDataSource`.
protocol ExpenseDataSource: TransactionDataSource where Item == DatabaseExpense { }

/// A data source protocol for managing income-related data.
///
/// Inherits bulk read and delete operations from `TransactionDataSource`.
protocol IncomeDataSource: TransactionDataSource where Item == DatabaseIncome { }
