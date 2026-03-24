//
//  Repository.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// A generic base repository protocol defining basic CRUD operations.
///
/// This protocol provides the foundation for repositories handling
/// data persistence for any type conforming to `Item`.
protocol BaseRepository {
    
    /// The type of item this repository manages.
    associatedtype Item
    
    /// Creates a new item in the data store.
    ///
    /// - Parameter item: The item to create.
    /// - Throws: An error if the creation fails.
    func create(_ item: Item) async throws
    
    /// Updates an existing item in the data store.
    ///
    /// - Parameter item: The item to update.
    /// - Throws: An error if the update fails.
    func update(_ item: Item) async throws
    
    /// Deletes an existing item from the data store.
    ///
    /// - Parameter item: The item to delete.
    /// - Throws: An error if the deletion fails.
    func delete(_ item: Item) async throws
}

/// A repository protocol for managing collections of items supporting read and bulk delete operations.
///
/// Extends `BaseRepository` to include reading all items and deleting all items at once.
protocol TransactionRepository: BaseRepository {
    
    /// Reads all items from the data store.
    ///
    /// - Returns: An array of all items.
    /// - Throws: An error if the read operation fails.
    func readAll() async throws -> [Item]
    
    /// Deletes all items from the data store.
    ///
    /// - Throws: An error if the deletion fails.
    func deleteAll() async throws
}

/// Repository protocol specialized for handling expense transactions.
///
/// Conforms to `TransactionRepository` with the item type fixed as `Expense`.
protocol ExpenseRepository: TransactionRepository where Item == Expense {}

/// Repository protocol specialized for handling income transactions.
///
/// Conforms to `TransactionRepository` with the item type fixed as `Income`.
protocol IncomeRepository: TransactionRepository where Item == Income {}

/// Repository protocol for managing user data.
///
/// Extends `BaseRepository` and adds a method to read a single user.
protocol UserRepository: BaseRepository where Item == User {
    
    /// Reads the current user from the data store.
    ///
    /// - Returns: The user if available, otherwise `nil`.
    /// - Throws: An error if the read operation fails.
    func read() async throws -> Item?
}
