//
//  RepositoryHandler.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import Foundation

/// A protocol that defines the contract for a unified repository interface,
/// abstracting access to data sources for expenses, incomes, and user profiles.
///
/// This is intended to be used as a single point of interaction for higher-level services,
/// such as view models or use cases, hiding the implementation details of underlying storage (local or remote).
protocol RepositoryHandler {
    
    // MARK: - Expense Operations
    
    /// Fetches all expense records from the underlying data source.
    ///
    /// - Returns: An array of `Expense` objects.
    func fetchExpenses() async throws -> [Expense]
    
    /// Saves a new expense to the underlying data source.
    ///
    /// - Parameter expense: The `Expense` object to be persisted.
    func saveExpense(_ expense: Expense) async throws
    
    /// Updates an existing expense in the underlying data source.
    ///
    /// - Parameter expense: The `Expense` object containing updated fields.
    func updateExpense(_ expense: Expense) async throws
    
    /// Deletes a specific expense from the underlying data source.
    ///
    /// - Parameter expense: The `Expense` object to be removed.
    func deleteExpense(_ expense: Expense) async throws
    
    /// Deletes all stored expense records.
    func deleteAllExpenses() async throws

    // MARK: - Income Operations
    
    /// Fetches all income records from the underlying data source.
    ///
    /// - Returns: An array of `Income` objects.
    func fetchIncomes() async throws -> [Income]
    
    /// Saves a new income entry to the underlying data source.
    ///
    /// - Parameter income: The `Income` object to be saved.
    func saveIncome(_ income: Income) async throws
    
    /// Updates an existing income entry.
    ///
    /// - Parameter income: The `Income` object with updated values.
    func updateIncome(_ income: Income) async throws
    
    /// Deletes a specific income record.
    ///
    /// - Parameter income: The `Income` object to be removed.
    func deleteIncome(_ income: Income) async throws
    
    /// Removes all income records from the data source.
    func deleteAllIncomes() async throws

    // MARK: - User Operations
    
    /// Retrieves the current user record, if one exists.
    ///
    /// - Returns: An optional `User` object. Returns `nil` if no user is stored.
    func fetchUser() async throws -> User?
    
    /// Saves a new user object.
    ///
    /// - Parameter user: The `User` object to be stored.
    func saveUser(_ user: User) async throws
    
    /// Updates the stored user with new information.
    ///
    /// - Parameter user: The modified `User` object to be saved.
    func updateUser(_ user: User) async throws
    
    /// Deletes the current user record from the data source.
    ///
    /// - Parameter user: The user to be deleted (usually the logged-in user).
    func deleteUser(_ user: User) async throws
}


/// A concrete implementation of `RepositoryHandler` that composes three distinct repositories:
/// one for handling expenses, one for incomes, and one for user profile data.
///
/// This class adheres to dependency injection principles by accepting repository implementations
/// for each model type, making it flexible and testable (e.g., for mocking in unit tests).
///
/// Generic constraints:
/// - `E`: A type conforming to `ExpenseRepository`, responsible for expense CRUD operations.
/// - `I`: A type conforming to `IncomeRepository`, responsible for income CRUD operations.
/// - `U`: A type conforming to `UserRepository`, responsible for user data operations.
final class RepositoryHandlerImpl<E: ExpenseRepository, I: IncomeRepository, U: UserRepository>: RepositoryHandler {
    
    // MARK: - Private Properties
    
    /// The repository responsible for managing expenses.
    private let expenseRepository: E
    
    /// The repository responsible for managing incomes.
    private let incomeRepository: I
    
    /// The repository responsible for managing user profiles.
    private let userRepository: U
    
    // MARK: - Initialization
    
    /// Initializes the repository handler with specific implementations of repositories.
    ///
    /// - Parameters:
    ///   - expenseRepository: A concrete instance of an `ExpenseRepository`.
    ///   - incomeRepository: A concrete instance of an `IncomeRepository`.
    ///   - userRepository: A concrete instance of a `UserRepository`.
    init(expenseRepository: E, incomeRepository: I, userRepository: U) {
        self.expenseRepository = expenseRepository
        self.incomeRepository = incomeRepository
        self.userRepository = userRepository
    }
    
    // MARK: - Expense Methods
    
    func fetchExpenses() async throws -> [Expense] {
        try await expenseRepository.readAll()
    }
    
    func saveExpense(_ expense: Expense) async throws {
        try await expenseRepository.create(expense)
    }
    
    func updateExpense(_ expense: Expense) async throws {
        try await expenseRepository.update(expense)
    }
    
    func deleteExpense(_ expense: Expense) async throws {
        try await expenseRepository.delete(expense)
    }
    
    func deleteAllExpenses() async throws {
        try await expenseRepository.deleteAll()
    }
    
    // MARK: - Income Methods
    
    func fetchIncomes() async throws -> [Income] {
        try await incomeRepository.readAll()
    }
    
    func saveIncome(_ income: Income) async throws {
        try await incomeRepository.create(income)
    }
    
    func updateIncome(_ income: Income) async throws {
        try await incomeRepository.update(income)
    }
    
    func deleteIncome(_ income: Income) async throws {
        try await incomeRepository.delete(income)
    }
    
    func deleteAllIncomes() async throws {
        try await incomeRepository.deleteAll()
    }
    
    // MARK: - User Methods
    
    func fetchUser() async throws -> User? {
        try await userRepository.read()
    }
    
    func saveUser(_ user: User) async throws {
        try await userRepository.create(user)
    }
    
    func updateUser(_ user: User) async throws {
        try await userRepository.update(user)
    }
    
    func deleteUser(_ user: User) async throws {
        try await userRepository.delete(user)
    }
}
