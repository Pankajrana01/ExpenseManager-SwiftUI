//
//  IncomeDataRepository.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//


/// A repository class that implements `IncomeRepository` by interacting with a generic `IncomeDataSource`.
/// It acts as a bridge between the domain model (`Income`) and the data source model (`DatabaseIncome`).
/// This class handles conversion between domain and database models and delegates CRUD operations to the data source.
final class IncomeDataRepository<DataSource: IncomeDataSource>: IncomeRepository {
    
    /// The underlying data source that conforms to `IncomeDataSource` protocol.
    private let dataSource: DataSource
    
    /// Initializes the repository with a specific data source.
    /// - Parameter dataSource: The concrete data source instance to use for persistence.
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    /// Reads all incomes from the data source and converts them from database models to domain models.
    /// - Returns: An array of `Income` domain objects.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func readAll() async throws -> [Income] {
        try await dataSource.readAll().map({ $0.toIncome() })
    }
    
    /// Creates a new income by converting the domain model to the database model and delegating to the data source.
    /// - Parameter item: The `Income` domain model to be saved.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func create(_ item: Income) async throws {
        try await dataSource.create(item.toDatabaseIncome())
    }
    
    /// Updates an existing income by converting the domain model to the database model and delegating to the data source.
    /// - Parameter item: The `Income` domain model with updated values.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func update(_ item: Income) async throws {
        try await dataSource.update(item.toDatabaseIncome())
    }
    
    /// Deletes an existing income by converting the domain model to the database model and delegating to the data source.
    /// - Parameter item: The `Income` domain model to be deleted.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func delete(_ item: Income) async throws {
        try await dataSource.delete(item.toDatabaseIncome())
    }
    
    /// Deletes all incomes from the data source.
    /// - Throws: Propagates any error thrown by the underlying data source.
    func deleteAll() async throws {
        try await dataSource.deleteAll()
    }
}

extension Income {
    /// Converts a domain model `Income` into its corresponding database model `DatabaseIncome`.
    /// - Returns: A `DatabaseIncome` instance representing the domain income.
    func toDatabaseIncome() -> DatabaseIncome {
        return DatabaseIncome(
            id: id,
            amount: amount,
            date: date,
            source: source.rawValue,
            note: note
        )
    }
}

extension DatabaseIncome {
    /// Converts a database model `DatabaseIncome` into its corresponding domain model `Income`.
    /// - Returns: An `Income` instance representing the database income.
    func toIncome() -> Income {
        return Income(
            id: id,
            amount: amount,
            source: Source(rawValue: source) ?? .other,
            date: date.toDate(),
            note: note
        )
    }
}
