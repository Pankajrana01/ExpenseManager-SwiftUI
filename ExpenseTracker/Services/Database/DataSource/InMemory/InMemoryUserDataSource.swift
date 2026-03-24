//
//  InMemoryUserDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// An in-memory implementation of `UserDataSource` that simulates user-related persistence operations.
///
/// This class is useful for testing, previews, or scenarios where you don't want to persist user data permanently.
/// It holds a single `DatabaseUser` instance in memory, mimicking basic CRUD operations.
final class InMemoryUserDataSource: UserDataSource {
    
    /// A stored in-memory user used to simulate a currently authenticated or registered user.
    /// Initialized with default sample data to represent a pre-existing user session.
    private var _user: DatabaseUser? = .init(
        id: UUID().uuidString,
        email: "johndoe@example.com",
        firstName: "John",
        lastName: "Doe"
    )
    
    /// Reads the current user from memory.
    /// - Returns: The stored `DatabaseUser` instance, or `nil` if no user exists.
    func read() async throws -> DatabaseUser? {
        _user
    }
    
    /// Creates (or overwrites) the current user in memory.
    /// - Parameter item: The `DatabaseUser` to store.
    func create(_ item: DatabaseUser) async throws {
        _user = item
    }
    
    /// Updates the current user in memory with a new value.
    /// - Parameter item: The updated `DatabaseUser`. Replaces any existing user.
    func update(_ item: DatabaseUser) async throws {
        _user = item
    }
    
    /// Deletes the current user from memory by setting `_user` to `nil`.
    /// - Parameter item: The `DatabaseUser` to delete. The parameter is not used for matching,
    ///   as only one user is stored in this in-memory implementation.
    func delete(_ item: DatabaseUser) async throws {
        _user = nil
    }
    
    /// Conforms to `BaseDataSource`'s associated type requirement.
    typealias Item = DatabaseUser
}
