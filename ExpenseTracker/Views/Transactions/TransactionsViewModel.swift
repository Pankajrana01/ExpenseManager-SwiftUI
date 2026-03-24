//
//  TransactionsViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 03/04/25.
//

import Foundation

extension TransactionsView {
    /// ViewModel for the `TransactionsView` screen.
    /// Responsible for managing transaction data, filtering logic, user interactions, and error states.
    @Observable
    class ViewModel {
        
        // MARK: - Filter State
        
        /// Stores the active filter options selected by the user (e.g., date, category, source, amount).
        var selectedFilterOptions: Set<FilterOption> = []
        
        /// The end date selected for filtering transactions.
        var endDate: Date = Date()
        
        /// The start date selected for filtering transactions.
        var startDate: Date = Date()
        
        /// Categories selected for filtering expense transactions.
        var selectedCategories: [Category] = []
        
        /// Sources selected for filtering income transactions.
        var selectedSources: [Source] = []
        
        var selectedTransactions = Set<String>()
        
        /// Boolean to toggle the display of expense category filter UI.
        var showExpenseCategoryFilter: Bool = false
        
        /// Boolean to toggle the display of income source filter UI.
        var showIncomeSourceFilter: Bool = false
        
        /// Boolean to toggle the display of date range filter UI.
        var showDateFilter: Bool = false
        
        /// Boolean to toggle the display of amount range filter UI.
        var showAmountFilter: Bool = false
        
        /// Amount ranges selected for filtering transactions.
        var selectedAmountRanges: [AmountRange] = []
        
        // MARK: - Transaction State
        
        /// All transactions (both incomes and expenses) fetched from the database.
        var transactionList: [any Transaction] = []
        
        /// Grouped and filtered transactions based on user-selected filters.
        var groupedTransactionList: [String: [any Transaction]] {
            filterTransactions()
        }
        /// Computed property for section header
        var sectionKeys: [String] {
            groupedTransactionList.keys.sorted { (key1, key2) -> Bool in
                let date1 = key1.toDate(dateFormat: "MMMM yyyy")
                let date2 = key2.toDate(dateFormat: "MMMM yyyy")
                return date1 > date2
            }
        }
        
        var selection = Set<String>()
        
        var isEditing: Bool = false
                
        // MARK: - Search
        
        /// Search text entered by the user to filter transactions.
        var searchText: String = ""
        
        // MARK: - Delete, Edit & Error Handling

        /// A variable to control the visibility of the Add/Edit Expense and Income sheet.
        var presentedSheet: PresentedSheet? = nil

        /// A variable to control the visibility of the delete confirmation alert for
        /// an expense or income as well as error message.
        var alertType: AlertType? = nil
        
        // MARK: - Database
        
        /// Interface to interact with the database for querying and persisting transactions.
        let databaseManager: DatabaseManager
        
        /// Initializes the ViewModel with a given database manager.
        /// - Parameter databaseManager: The database interface for transactions.
        init(databaseManager: DatabaseManager) {
            self.databaseManager = databaseManager
        }
        
        // MARK: - Fetching Data
        
        /// Fetches all incomes from the database and appends them to the transaction list.
        func fetchIncomes() async {
            do {
                let incomes = try await databaseManager.fetchIncomes()
                transactionList.append(contentsOf: incomes)
                transactionList = transactionList.sorted { $0.formattedDate > $1.formattedDate }
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
            
        }
        
        /// Fetches all expenses from the database and appends them to the transaction list.
        func fetchExpenses() async {
            do {
                let expenses = try await databaseManager.fetchExpenses()
                transactionList.append(contentsOf: expenses)
                transactionList = transactionList.sorted { $0.formattedDate > $1.formattedDate }
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
        }
        
        /// Clears all transactions currently held in memory.
        func clearAllTransactions() {
            transactionList.removeAll()
        }
        
        // MARK: - Deletion
        
        /// Deletes an expense from the database.
        /// - Parameter id: The unique ID of the expense to be deleted.
        func deleteExpense(_ expense: Expense) async {
            do {
                _ = try await databaseManager.deleteExpense(expense)
                clearAllTransactions()
                await fetchExpenses()
                await fetchIncomes()
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
            
        }
        
        /// Deletes an income from the database.
        /// - Parameter id: The unique ID of the income to be deleted.
        func deleteIncome(_ income: Income) async {
            do {
                _ = try await databaseManager.deleteIncome(income)
                clearAllTransactions()
                await fetchExpenses()
                await fetchIncomes()
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
        }
        
        // MARK: - Filtering
        
        /// Filters the list of transactions based on selected options (date, category, source, amount, search).
        /// - Returns: Grouped and sorted transactions matching all active filters.
        private func filterTransactions() -> [String: [any Transaction]] {
            var filteredTransactions = transactionList
            
            // Filter by selected date range
            if selectedFilterOptions.contains(.date) {
                filteredTransactions = filteredTransactions.filter { transaction in
                    transaction.formattedDate >= startDate && transaction.formattedDate <= endDate
                }
            }
            
            // Filter by selected expense categories
            if selectedFilterOptions.contains(.category) {
                filteredTransactions = filteredTransactions.filter { transaction in
                    if let expense = transaction as? Expense {
                        return selectedCategories.contains(expense.category)
                    }
                    return true
                }
            }
            
            // Filter by selected income sources
            if selectedFilterOptions.contains(.source) {
                filteredTransactions = filteredTransactions.filter { transaction in
                    if let income = transaction as? Income {
                        return selectedSources.contains(income.source)
                    }
                    return true
                }
            }
            
            // Filter by selected amount range(s)
            if selectedFilterOptions.contains(.amount) {
                filteredTransactions = filteredTransactions.filter { transaction in
                    selectedAmountRanges.contains { $0.range.contains(abs(transaction.amount)) }
                }
            }
            
            // Filter by search text (case-insensitive)
            if !searchText.isEmpty {
                filteredTransactions = filteredTransactions.filter { transaction in
                    if let income = transaction as? Income {
                        return income.source.rawValue.localizedCaseInsensitiveContains(searchText)
                        || income.note.localizedCaseInsensitiveContains(searchText)
                    } else if let expense = transaction as? Expense {
                        return expense.name.localizedCaseInsensitiveContains(searchText)
                        || expense.note.localizedCaseInsensitiveContains(searchText)
                    }
                    return false
                }
            }
            
            // Group filtered transactions by month-year and sort descending
            return Dictionary(grouping: filteredTransactions) { transaction in
                transaction.formattedDate.formattedString(dateFormat: "MMMM yyyy")
            }
        }
    }
}

// MARK: - Array Extension

/// Extension to compute the total expense value from a list of transactions.
extension [Transaction] {
    /// Computes the total value of all expenses in the list.
    /// Ignores income transactions.
    var totalExpense: Double {
        reduce(0) { result, transaction in
            if transaction is Expense {
                return result + ((transaction as! Expense).amount)
            } else {
                return result
            }
        }
    }
}
