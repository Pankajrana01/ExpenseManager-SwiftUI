//
//  DashboardViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 02/04/25.
//

import Foundation

extension DashboardView {
    @Observable
    class ViewModel {
        // MARK: - Public Properties
        
        /// The list of expenses.
        private(set) var expenseList: [Expense] = []
        
        /// The list of incomes.
        private(set) var incomeList: [Income] = []
        
        /// The total amount of income recorded.
        var totalIncome: Double {
            incomeList.reduce(0) { $0 + $1.amount }
        }
        
        /// The total amount of expenses recorded.
        var totalExpense: Double {
            expenseList.reduce(0) { $0 + $1.amount }
        }
        
        /// The net balance available after expenses.
        var balance: Double {
            totalIncome - totalExpense
        }
        
        /// An array holding month-year strings used for display or selection (e.g., "May 2025").
        /// Initialized with the current month and year.
        var monthYears: [String] = [Date().formattedString(dateFormat: "MMMM yyyy")]

        /// Tracks the index of the currently selected month-year from the `monthYears` array.
        /// Defaults to `0`, meaning the first (and currently only) item is selected.
        var selectedMonthYear: Int = 0

        /// The current sorting option applied to the expenses.
        var sortingOption: SortingOption = .date
        
        /// The current ordering applied to sort the expenses.
        var isDescending: Bool = true
        
        /// A variable to control the visibility of the Add/Edit Expense and Income sheet.
        var presentedSheet: PresentedSheet? = nil
        
        /// A variable to control the visibility of the delete confirmation alert for
        /// an expense or income as well as error message.
        var alertType: AlertType? = nil
        
        var isLoading: Bool = false
                
        // MARK: - Private Properties
        
        /// The database manager that handles the database operations.
        let databaseManager: DatabaseManager
        
        /// Initializes the ViewModel with a given database manager.
        init(databaseManager: DatabaseManager) {
            self.databaseManager = databaseManager
        }
        
        // MARK: - Public Methods
        
        /// Fetches the expenses from the database.
        func fetchExpenses() async {
            do {
                let expenses = try await databaseManager.fetchExpenses()
                let filteredExpenses = expenses.filterByMonth(monthYears[selectedMonthYear])
                expenseList = filteredExpenses.sorted(by: .date, isDescending: true)
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
        }
        
        /// Fetches the incomes from the database.
        func fetchIncomes() async {
            do {
                let incomes = try await databaseManager.fetchIncomes()
                let filteredIncomes = incomes.filterByMonth(monthYears[selectedMonthYear])
                incomeList = filteredIncomes.sorted(by: .date, isDescending: true)
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
        }
        
        func prepareMonthYearSelection() async {
            do {
                let expenses = try await databaseManager.fetchExpenses()
                let monthYearSet = Set(expenses.map({ $0.formattedDate.formattedString(dateFormat: "MMMM yyyy") }))
                
                guard monthYearSet.isNotEmpty else { return }
                
                monthYears = monthYearSet.sorted { dateA, dateB in
                    return dateA.toDate(dateFormat: "MMMM yyyy") < dateB.toDate(dateFormat: "MMMM yyyy")
                }
                                
                selectedMonthYear = monthYears.count - 1
            } catch {
                print("Error preparing month year selection: \(error.localizedDescription)")
            }
        }
        
        /// Deletes an expense by its identifier.
        /// - Parameters:
        ///   - id: The identifier of the expense to be deleted.
        func deleteExpense(_ expense: Expense) async {
            do {
                _ = try await databaseManager.deleteExpense(expense)
                await fetchExpenses()
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
        }
        
        /// Deletes an income by its identifier.
        /// - Parameters:
        ///   - id: The identifier of the income to be deleted.
        func deleteIncome(_ income: Income) async {
            do {
                _ = try await databaseManager.deleteIncome(income)
                await fetchIncomes()
            } catch {
                alertType = .error(message: error.localizedDescription)
            }
        }
        
        /// Sort incomes by `SortingOption`.
        func sortExpenses() {
            expenseList = expenseList.sorted(by: sortingOption, isDescending: isDescending)
        }
        
        func syncData() async {
            await databaseManager.syncLocalWithRemote()
        }
    }
}
