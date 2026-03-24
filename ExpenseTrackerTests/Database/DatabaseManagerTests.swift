//
//  DatabaseManagerTests.swift
//  ExpenseTrackerTests
//
//  Created by Pankaj Rana on 17/04/25.
//

import Foundation
import Testing

@testable import ExpenseTracker

@Suite("DatabaseManager Tests")
struct DatabaseManagerTests {
    var localExpenseDataSource: MockExpenseDataSource
    var localIncomeDataSource: MockIncomeDataSource
    var localUserDataSource: MockUserDataSource
    
    var remoteExpenseDataSource: MockExpenseDataSource
    var remoteIncomeDataSource: MockIncomeDataSource
    var remoteUserDataSource: MockUserDataSource
    
    var databaseManager: DatabaseManager
    
    init () async throws {
        localExpenseDataSource = .init()
        localIncomeDataSource = .init()
        localUserDataSource = .init()
        
        remoteExpenseDataSource = .init()
        remoteIncomeDataSource = .init()
        remoteUserDataSource = .init()
        
        databaseManager = DatabaseManager(
            localRepositoryHandler: RepositoryHandlerImpl(
                expenseRepository: ExpenseDataRepository(
                    dataSource: localExpenseDataSource
                ),
                incomeRepository: IncomeDataRepository(
                    dataSource: localIncomeDataSource
                ),
                userRepository: UserDataRepository(
                    dataSource: localUserDataSource
                )
            )
        )
    }
    
    func remoteRepositoryHandler() -> RepositoryHandler {
        RepositoryHandlerImpl(
            expenseRepository: ExpenseDataRepository(
                dataSource: remoteExpenseDataSource
            ),
            incomeRepository: IncomeDataRepository(
                dataSource: remoteIncomeDataSource
            ),
            userRepository: UserDataRepository(
                dataSource: remoteUserDataSource
            )
        )
    }
    
    @Test("Fetch empty expenses", .tags(.expense.fetch))
    func fetchExpenses() async throws {
        let expenses = try await databaseManager.fetchExpenses()
        #expect(expenses.isEmpty)
    }
    
    @Test("Fetch saved expenses", .tags(.expense.add, .expense.fetch))
    func fetchSavedExpenses() async throws {
        _ = try await databaseManager.saveExpense(newTestExpense())
        let expenses = try await databaseManager.fetchExpenses()
        
        #expect(expenses.count == 1)
        
        let expense = try #require(expenses.first)
        
        #expect(expense.name == "Test Expense")
        #expect(expense.amount == 100.0)
        #expect(expense.date == Date().formattedString())
        #expect(expense.category == .other)
        #expect(expense.note == "Test Note")
    }
    
    @Test("Update expense", .tags(.expense.add, .expense.fetch, .expense.update))
    func updateExpense() async throws {
        _ = try await databaseManager.saveExpense(newTestExpense())
        let expenses = try await databaseManager.fetchExpenses()
        
        #expect(expenses.count == 1)
        
        let expense = try #require(expenses.first)
        try await databaseManager.updateExpense(updatedTestExpense(id: expense.id, amount: 200.0, date: Date().byAdding(.day, value: -1), category: ExpenseTracker.Category.food))
        
        let updatedExpenses = try await databaseManager.fetchExpenses()
        
        #expect(updatedExpenses.count == 1)
        
        let updatedExpense = try #require(updatedExpenses.first)
        
        #expect(updatedExpense.date == Date().byAdding(.day, value: -1).formattedString())
        #expect(updatedExpense.name == "Updated Test Expense")
        #expect(updatedExpense.amount == 200.0)
        #expect(updatedExpense.category == .food)
        #expect(updatedExpense.note == "Updated Test Note")
    }
    
    @Test("Delete expense", .tags(.expense.add, .expense.fetch, .expense.delete))
    func deleteExpense() async throws {
        _ = try await databaseManager.saveExpense(newTestExpense())
        let expenses = try await databaseManager.fetchExpenses()
        
        #expect(expenses.count == 1)
        
        let expense = try #require(expenses.first)
        try await databaseManager.deleteExpense(expense)
        
        let deletedExpenses = try await databaseManager.fetchExpenses()
        
        #expect(deletedExpenses.isEmpty)
    }
    
    @Test("Clear all expenses", .tags(.expense.add, .expense.fetch, .expense.delete))
    func clearAllExpenses() async throws {
        _ = try await databaseManager.saveExpense(newTestExpense())
        let expenses = try await databaseManager.fetchExpenses()
        
        #expect(expenses.count == 1)
        try await databaseManager.deleteAllExpenses()
        
        let deletedExpenses = try await databaseManager.fetchExpenses()
        #expect(deletedExpenses.isEmpty)
    }
    
    @Test("Fetch empty incomes", .tags(.expense.fetch))
    func fetchIncomes() async throws {
        let incomes = try await databaseManager.fetchIncomes()
        #expect(incomes.isEmpty)
    }
    
    @Test("Fetch saved incomes", .tags(.income.add, .income.fetch))
    func fetchSavedIncomes() async throws {
        _ = try await databaseManager.saveIncome(newTestIncome())
        let incomes = try await databaseManager.fetchIncomes()
        
        #expect(incomes.count == 1)
        
        let income = try #require(incomes.first)
        #expect(income.amount == 10000.0)
        #expect(income.date == Date().formattedString())
        #expect(income.source == .salary)
    }
    
    @Test("Update income", .tags(.income.add, .income.fetch, .income.update))
    func updateIncome() async throws {
        _ = try await databaseManager.saveIncome(newTestIncome())
        let incomes = try await databaseManager.fetchIncomes()
        
        #expect(incomes.count == 1)
        
        let income = try #require(incomes.first)
        try await databaseManager.updateIncome(updatedTestIncome(id: income.id, amount: 20000.0, date: Date().byAdding(.day, value: -1), source: income.source))
        
        let updatedIncomes = try await databaseManager.fetchIncomes()
        
        #expect(updatedIncomes.count == 1)
        
        let updatedIncome = try #require(updatedIncomes.first)
        #expect(updatedIncome.amount == 20000.0)
        #expect(updatedIncome.date == Date().byAdding(.day, value: -1).formattedString())
    }
    
    @Test("Delete income", .tags(.income.add, .income.fetch, .income.delete))
    func deleteIncome() async throws {
        _ = try await databaseManager.saveIncome(newTestIncome())
        let incomes = try await databaseManager.fetchIncomes()
        
        #expect(incomes.count == 1)
        
        let income = try #require(incomes.first)
        try await databaseManager.deleteIncome(income)
        
        let deletedIncomes = try await databaseManager.fetchIncomes()
        #expect(deletedIncomes.isEmpty)
    }
    
    @Test("Clear all incomes", .tags(.income.add, .income.fetch, .income.delete))
    func clearAllIncomes() async throws {
        _ = try await databaseManager.saveIncome(newTestIncome())
        let incomes = try await databaseManager.fetchIncomes()
        
        #expect(incomes.count == 1)
        try await databaseManager.deleteAllIncomes()
        
        let deletedIncomes = try await databaseManager.fetchIncomes()
        #expect(deletedIncomes.isEmpty)
    }
    
    @Test("Fetch empty user details")
    func fetchEmptyUserDetails() async throws {
        let userDetails = try await databaseManager.fetchUserDetails()
        
        #expect(userDetails == nil)
    }
    
    @Test("Fetch saved user details")
    func fetchSavedUserDetails() async throws {
        try await databaseManager.saveUserDetails(newTestUser())
        
        let savedUserDetails = try #require(try await databaseManager.fetchUserDetails())
        
        #expect(savedUserDetails.email == "test@example.com")
        #expect(savedUserDetails.firstName == "Test")
        #expect(savedUserDetails.lastName == "User")
    }
    
    @Test("Update user details")
    func updateUserDetails() async throws {
        try await databaseManager.saveUserDetails(newTestUser())
        let userDetails = try #require(try await databaseManager.fetchUserDetails())
        
        try await databaseManager.updateUserDetails(updatedTestUser(id: userDetails.id))
        
        let updatedUserDetails = try #require(try await databaseManager.fetchUserDetails())
        
        #expect(updatedUserDetails.email == "updated@example.com")
        #expect(updatedUserDetails.firstName == "Updated")
        #expect(updatedUserDetails.lastName == "Test User")
    }
    
    @Test("Delete user details")
    func deleteUserDetails() async throws {
        try await databaseManager.saveUserDetails(newTestUser())
        let userDetails = try #require(try await databaseManager.fetchUserDetails())
        
        try await databaseManager.clearLocalUserDetails(userDetails)
        
        let updatedUserDetails = try await databaseManager.fetchUserDetails()
        
        #expect(updatedUserDetails == nil)
    }
    
    @Test("Should fetch expenses from remote if locally is not available")
    func fetchExpensesFromRemoteIfLocallyNotAvailable() async throws {
        let expenses = try await databaseManager.fetchExpenses()
        
        #expect(expenses.isEmpty)
        
        try await remoteExpenseDataSource.create(newTestDatabaseExpense())
        databaseManager.initializeRemoteRepositoryHandler(remoteRepositoryHandler())
        let newExpenses = try await databaseManager.fetchExpenses()
        
        #expect(newExpenses.count == 1)
    }
    
    @Test("Should fetch incomes from remote if locally is not available")
    func fetchIncomesFromRemoteIfLocallyNotAvailable() async throws {
        let incomes = try await databaseManager.fetchIncomes()
        
        #expect(incomes.isEmpty)
        
        try await remoteIncomeDataSource.create(newTestDatabaseIncome())
        databaseManager.initializeRemoteRepositoryHandler(remoteRepositoryHandler())
        let newIncomes = try await databaseManager.fetchIncomes()
        
        #expect(newIncomes.count == 1)
    }
    
    @Test("Should fetch user details from remote if localy is not available")
    func fetchUserDetailsFromRemoteIfLocallyNotAvailable() async throws {
        let userDetails = try await databaseManager.fetchUserDetails()
        
        #expect(userDetails == nil)
        
        try await remoteUserDataSource.create(newTestDatabaseUser())
        databaseManager.initializeRemoteRepositoryHandler(remoteRepositoryHandler())
        let newUserDetails = try await databaseManager.fetchUserDetails()
        
        #expect(newUserDetails != nil)
    }
}
