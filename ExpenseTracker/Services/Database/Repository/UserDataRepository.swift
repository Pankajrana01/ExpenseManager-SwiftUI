//
//  UserDataRepository.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// A repository class that acts as a bridge between domain `User` models
/// and the underlying data source which implements `UserDataSource`.
/// This class handles CRUD operations by converting between `User` and `DatabaseUser`
/// and delegates actual data access to the provided data source.
final class UserDataRepository<DataSource: UserDataSource>: UserRepository {
    
    /// The underlying data source responsible for storing `DatabaseUser` entities.
    private let dataSource: DataSource
    
    /// Initializes the repository with a specific data source.
    /// - Parameter dataSource: A data source conforming to `UserDataSource`.
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    /// Fetches the current user asynchronously from the data source.
    /// - Returns: An optional `User` domain model if found.
    /// - Throws: Propagates any error thrown by the data source.
    func read() async throws -> User? {
        // Read the database user and map it to domain user.
        try await dataSource.read()?.toUser()
    }
    
    /// Creates a new user entry in the data source.
    /// - Parameter item: The `User` domain model to create.
    /// - Throws: Propagates any error thrown by the data source.
    func create(_ item: User) async throws {
        try await dataSource.create(item.toDatabaseUser())
    }
    
    /// Updates an existing user entry in the data source.
    /// - Parameter item: The updated `User` domain model.
    /// - Throws: Propagates any error thrown by the data source.
    func update(_ item: User) async throws {
        try await dataSource.update(item.toDatabaseUser())
    }
    
    /// Deletes a user entry from the data source.
    /// - Parameter item: The `User` domain model to delete.
    /// - Throws: Propagates any error thrown by the data source.
    func delete(_ item: User) async throws {
        try await dataSource.delete(item.toDatabaseUser())
    }
}

/// Extension to convert a domain `User` to a database representation `DatabaseUser`.
extension User {
    /// Maps the domain model to a database model.
    /// - Returns: A `DatabaseUser` instance.
    func toDatabaseUser() -> DatabaseUser {
        return .init(id: id, email: email, firstName: firstName, lastName: lastName)
    }
}

/// Extension to convert a database `DatabaseUser` back to a domain `User`.
extension DatabaseUser {
    /// Maps the database model to a domain model.
    /// - Returns: A `User` instance.
    func toUser() -> User {
        return .init(id: id, email: email, firstName: firstName, lastName: lastName)
    }
}
