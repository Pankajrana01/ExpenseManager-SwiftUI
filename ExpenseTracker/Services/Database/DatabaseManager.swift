//
//  DatabaseManager.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/03/25.
//

import Foundation

/// A central manager responsible for coordinating data operations between local and remote repositories.
/// Supports syncing, CRUD operations, and user data handling for expenses and incomes.
@Observable
class DatabaseManager {
    
    /// Local repository handler (e.g., UserDefaults or in-memory) for managing persistent or temporary data on device.
    private let localRepositoryHandler: RepositoryHandler
    
    /// Optional remote repository handler (e.g., Firestore) for syncing with cloud storage.
    private var remoteRepositoryHandler: RepositoryHandler?
    
    /// Initializes the database manager with a local data source.
    init(localRepositoryHandler: RepositoryHandler) {
        self.localRepositoryHandler = localRepositoryHandler
    }
    
    /// Sets up the remote repository handler to enable cloud syncing.
    func initializeRemoteRepositoryHandler(_ repositoryHandler: RepositoryHandler) {
        self.remoteRepositoryHandler = repositoryHandler
    }
    
    /// Clears the remote repository handler. Useful on logout or offline scenarios.
    func deinitializeRemoteRepositoryHandler() {
        self.remoteRepositoryHandler = nil
    }
    
    /// Fetches expenses from local storage first.
    /// If local storage is empty and remote is available, fetches from remote and syncs locally.
    func fetchExpenses() async throws -> [Expense] {
        let localExpenses = try await localRepositoryHandler.fetchExpenses()
        if localExpenses.isNotEmpty {
            return localExpenses
        } else {
            guard let remoteRepositoryHandler else {
                return []
            }
            let remoteExpenses = try await remoteRepositoryHandler.fetchExpenses()
            await syncLocalWithRemoteExpenses(remoteExpenses)
            return remoteExpenses
        }
    }
    
    /// Saves the given expense to both local and remote (if available) repositories.
    @discardableResult
    func saveExpense(_ expense: Expense) async throws -> Bool {
        try await localRepositoryHandler.saveExpense(expense)
        try await remoteRepositoryHandler?.saveExpense(expense)
        return true
    }
    
    /// Deletes the given expense from both local and remote (if available) repositories.
    @discardableResult
    func deleteExpense(_ expense: Expense) async throws -> Bool {
        try await localRepositoryHandler.deleteExpense(expense)
        try await remoteRepositoryHandler?.deleteExpense(expense)
        return true
    }
    
    /// Updates the given expense in both local and remote (if available) repositories.
    @discardableResult
    func updateExpense(_ expense: Expense) async throws -> Bool {
        try await localRepositoryHandler.updateExpense(expense)
        try await remoteRepositoryHandler?.updateExpense(expense)
        return true
    }
    
    /// Deletes all expenses from both local and remote (if available) repositories.
    @discardableResult
    func deleteAllExpenses() async throws -> Bool {
        try await localRepositoryHandler.deleteAllExpenses()
        try await remoteRepositoryHandler?.deleteAllExpenses()
        return true
    }
    
    /// Fetches incomes from local storage first.
    /// If local is empty and remote is available, fetches from remote and syncs locally.
    func fetchIncomes() async throws -> [Income] {
        let localIncomes = try await localRepositoryHandler.fetchIncomes()
        if localIncomes.isNotEmpty {
            return localIncomes
        } else {
            guard let remoteRepositoryHandler else {
                return []
            }
            let remoteIncomes = try await remoteRepositoryHandler.fetchIncomes()
            await syncLocalWithRemoteIncomes(remoteIncomes)
            return remoteIncomes
        }
    }
    
    /// Saves the given income to both local and remote (if available) repositories.
    @discardableResult
    func saveIncome(_ income: Income) async throws -> Bool {
        try await localRepositoryHandler.saveIncome(income)
        try await remoteRepositoryHandler?.saveIncome(income)
        return true
    }
    
    /// Updates the given income in both local and remote (if available) repositories.
    @discardableResult
    func updateIncome(_ income: Income) async throws -> Bool {
        try await localRepositoryHandler.updateIncome(income)
        try await remoteRepositoryHandler?.updateIncome(income)
        return true
    }
    
    /// Deletes the given income from both local and remote (if available) repositories.
    @discardableResult
    func deleteIncome(_ income: Income) async throws -> Bool {
        try await localRepositoryHandler.deleteIncome(income)
        try await remoteRepositoryHandler?.deleteIncome(income)
        return true
    }
    
    /// Deletes all incomes from both local and remote (if available) repositories.
    @discardableResult
    func deleteAllIncomes() async throws -> Bool {
        try await localRepositoryHandler.deleteAllIncomes()
        try await remoteRepositoryHandler?.deleteAllIncomes()
        return true
    }
    
    /// Syncs all data (incomes and expenses) from remote to local.
    func syncLocalWithRemote() async {
        await syncLocalIncomesWithRemote()
        await syncLocalExpensesWithRemote()
    }
    
    /// Synchronizes missing remote expenses into the local repository.
    private func syncLocalExpensesWithRemote() async {
        do {
            guard let remoteRepositoryHandler else { return }
            let remoteExpenses = try await remoteRepositoryHandler.fetchExpenses()
            let localExpenses = try await localRepositoryHandler.fetchExpenses()
            
            let localExpenseSet = Set(localExpenses.map { $0.id })
            for expense in remoteExpenses where !localExpenseSet.contains(expense.id) {
                try await localRepositoryHandler.saveExpense(expense)
            }
        } catch {
            print("Error synchronizing local expenses with remote: \(error.localizedDescription)")
        }
    }
    
    /// Synchronizes missing remote incomes into the local repository.
    private func syncLocalIncomesWithRemote() async {
        do {
            guard let remoteRepositoryHandler else { return }
            let remoteIncomes = try await remoteRepositoryHandler.fetchIncomes()
            let localIncomes = try await localRepositoryHandler.fetchIncomes()
            
            let localIncomeSet = Set(localIncomes.map { $0.id })
            for income in remoteIncomes where !localIncomeSet.contains(income.id) {
                try await localRepositoryHandler.saveIncome(income)
            }
        } catch {
            print("Error synchronizing local incomes with remote: \(error.localizedDescription)")
        }
    }
    
    /// Syncs all data (incomes and expenses) from local to remote.
    func syncRemoteWithLocal() async {
        await syncRemoteExpensesWithLocal()
        await syncRemoteIncomesWithLocal()
    }
    
    /// Synchronizes missing local expenses into the remote repository.
    private func syncRemoteExpensesWithLocal() async {
        do {
            guard let remoteRepositoryHandler else { return }
            let remoteExpenses = try await remoteRepositoryHandler.fetchExpenses()
            let localExpenses = try await localRepositoryHandler.fetchExpenses()
            
            let remoteExpenseSet = Set(remoteExpenses.map { $0.id })
            for expense in localExpenses where !remoteExpenseSet.contains(expense.id) {
                try await remoteRepositoryHandler.saveExpense(expense)
            }
        } catch {
            print("Error synchronizing remote with local expenses: \(error.localizedDescription)")
        }
    }
    
    /// Synchronizes missing local incomes into the remote repository.
    private func syncRemoteIncomesWithLocal() async {
        do {
            guard let remoteRepositoryHandler else { return }
            let remoteIncomes = try await remoteRepositoryHandler.fetchIncomes()
            let localIncomes = try await localRepositoryHandler.fetchIncomes()
            
            let remoteIncomeSet = Set(remoteIncomes.map { $0.id })
            for income in localIncomes where !remoteIncomeSet.contains(income.id) {
                try await remoteRepositoryHandler.saveIncome(income)
            }
        } catch {
            print("Error synchronizing remote with local incomes: \(error.localizedDescription)")
        }
    }
    
    /// Saves remote expenses to the local repository.
    ///
    /// - Parameter remoteExpenses: List of expenses fetched from the remote store.
    private func syncLocalWithRemoteExpenses(_ remoteExpenses: [Expense]) async {
        for expense in remoteExpenses {
            do {
                try await localRepositoryHandler.saveExpense(expense)
            } catch {
                print("Error synchronizing local with remote expenses: \(error.localizedDescription)")
            }
        }
    }
    
    /// Saves remote incomes to the local repository.
    ///
    /// - Parameter remoteIncomes: List of incomes fetched from the remote store.
    private func syncLocalWithRemoteIncomes(_ remoteIncomes: [Income]) async {
        for income in remoteIncomes {
            do {
                try await localRepositoryHandler.saveIncome(income)
            } catch {
                print("Error synchronizing local with remote incomes: \(error.localizedDescription)")
            }
        }
    }
    
    /// Syncs user details. If remote user exists, it updates or saves locally.
    /// If remote does not exist, uses provided user to initialize local data.
    func syncUserDetails(_ user: User) async {
        do {
            let (localUser, remoteUser) = try await (
                localRepositoryHandler.fetchUser(),
                remoteRepositoryHandler?.fetchUser()
            )
            
            if let remoteUser {
                if localUser == nil {
                    try await localRepositoryHandler.saveUser(remoteUser)
                } else {
                    try await localRepositoryHandler.updateUser(remoteUser)
                }
            } else {
                if localUser == nil {
                    try await localRepositoryHandler.saveUser(user)
                } else {
                    try await localRepositoryHandler.updateUser(user)
                }
            }
        } catch {
            print("Error syncing user details: \(error.localizedDescription)")
        }
    }
    
    /// Fetches user details from local store, or from remote if local is empty.
    func fetchUserDetails() async throws -> User? {
        let localUser = try await localRepositoryHandler.fetchUser()
        if localUser == nil {
            if let remoteRepositoryHandler {
                return try await remoteRepositoryHandler.fetchUser()
            } else {
                return nil
            }
        } else {
            return localUser
        }
    }
    
    /// Updates user details in both local and remote (if available) repositories.
    @discardableResult
    func updateUserDetails(_ user: User) async throws -> Bool {
        try await localRepositoryHandler.updateUser(user)
        try await remoteRepositoryHandler?.updateUser(user)
        return true
    }
    
    /// Saves user details to both local and remote (if available) repositories.
    @discardableResult
    func saveUserDetails(_ user: User) async throws -> Bool {
        try await localRepositoryHandler.saveUser(user)
        try await remoteRepositoryHandler?.saveUser(user)
        return true
    }
    
    /// Clears user details from local storage.
    @discardableResult
    func clearLocalUserDetails(_ user: User) async throws -> Bool {
        try await localRepositoryHandler.deleteUser(user)
        return true
    }
}
