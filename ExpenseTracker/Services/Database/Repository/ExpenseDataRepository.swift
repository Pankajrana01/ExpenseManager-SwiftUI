//
//  ExpenseDataRepository.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//


/// A repository class that implements `ExpenseRepository` by interacting with a generic `ExpenseDataSource`.
/// It acts as a bridge between the domain model (`Expense`) and the data source model (`DatabaseExpense`).
/// This class handles conversion between domain and database models and delegates CRUD operations to the data source.
final class ExpenseDataRepository<DataSource: ExpenseDataSource>: ExpenseRepository {
    
    /// The underlying data source that conforms to `ExpenseDataSource` protocol.
    private let dataSource: DataSource
    
    /// Initializes the repository with a specific data source.
    /// - Parameter dataSource: The concrete data source instance to use for persistence.
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    /// Reads all expenses from the data source and converts them from database models to domain models.
    /// - Returns: An array of `Expense` domain objects.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func readAll() async throws -> [Expense] {
        try await dataSource.readAll().map({ $0.toExpense() })
    }
    
    /// Creates a new expense by converting the domain model to the database model and delegating to the data source.
    /// - Parameter item: The `Expense` domain model to be saved.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func create(_ item: Expense) async throws {
        try await dataSource.create(item.toDatabaseExpense())
    }
    
    /// Deletes an existing expense by converting the domain model to the database model and delegating to the data source.
    /// - Parameter item: The `Expense` domain model to be deleted.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func delete(_ item: Expense) async throws {
        try await dataSource.delete(item.toDatabaseExpense())
    }
    
    /// Updates an existing expense by converting the domain model to the database model and delegating to the data source.
    /// - Parameter item: The `Expense` domain model with updated values.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func update(_ item: Expense) async throws {
        try await dataSource.update(item.toDatabaseExpense())
    }
    
    /// Deletes all expenses from the data source.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func deleteAll() async throws {
        try await dataSource.deleteAll()
    }
}

extension Expense {
    /// Converts a domain model `Expense` into its corresponding database model `DatabaseExpense`.
    /// - Returns: A `DatabaseExpense` instance representing the domain expense.
    func toDatabaseExpense() -> DatabaseExpense {
        return DatabaseExpense(
            id: id,
            name: name,
            amount: amount,
            date: date,
            category: category.rawValue,
            note: note
        )
    }
}

extension DatabaseExpense {
    /// Converts a database model `DatabaseExpense` into its corresponding domain model `Expense`.
    /// - Returns: An `Expense` instance representing the database expense.
    func toExpense() -> Expense {
        return Expense(
            id: id,
            name: name,
            amount: amount,
            date: date.toDate(),
            category: Category(rawValue: category) ?? .other,
            note: note
        )
    }
}
