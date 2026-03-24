//
//  InsightsViewModel.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 04/04/25.
//

import Foundation

extension InsightsView {
    
    /// The ViewModel for the `InsightsView`, responsible for fetching and transforming
    /// income and expense data into chart-friendly formats.
    @Observable
    class ViewModel {
        
        // MARK: - Public Properties
        
        /// A list of aggregated chart items for current month's expenses.
        private(set) var expenseList: [InsightsChartItem] = []
        
        /// A list of aggregated chart items for current month's incomes.
        private(set) var incomeList: [InsightsChartItem] = []
                
        /// An array holding month-year strings used for display or selection (e.g., "May 2025").
        /// Initialized with the current month and year.
        var monthYears: [String] = [Date().formattedString(dateFormat: "MMMM yyyy")]

        /// Tracks the index of the currently selected month-year from the `monthYears` array.
        /// Defaults to `0`, meaning the first (and currently only) item is selected.
        var selectedMonthYear: Int = 0

        /// Determines whether an error alert should be shown.
        var showError: Bool = false
        
        /// The error message to show in case of a failure.
        var errorMessage: String = ""
        
        /// Controls the presentation of the Add Expense sheet.
        var showAddExpense: Bool = false
        
        /// Controls the presentation of the Add Income sheet.
        var showAddIncome: Bool = false
                
        /// The database manager responsible for fetching income and expense data.
        let databaseManager: DatabaseManager
        
        // MARK: - Initialization
        
        /// Initializes the ViewModel with a given database manager.
        /// - Parameter databaseManager: The data provider for incomes and expenses.
        init(databaseManager: DatabaseManager) {
            self.databaseManager = databaseManager
        }
        
        // MARK: - Public Methods
        
        /// Fetches income records from the database, filters them by the current month,
        /// and groups them by `Source` to prepare chart data.
        func fetchIncomes() async {
            do {
                let incomes = try await databaseManager.fetchIncomes()
                incomeList = [] // Reset list before adding fresh items
                
                let filteredIncomes = incomes.filterByMonth(monthYears[selectedMonthYear])
                
                // Group and sum by source
                Source.allCases.forEach { source in
                    let incomeBySource = filteredIncomes.filter { $0.source == source }
                    if !incomeBySource.isEmpty {
                        let total = incomeBySource.reduce(0) { $0 + $1.amount }
                        self.incomeList.append(.init(amount: total, source: source))
                    }
                }
            } catch {
                showError = true
                errorMessage = error.localizedDescription
            }
        }
        
        /// Fetches expense records from the database, filters them by the current month,
        /// and groups them by `Category` to prepare chart data.
        func fetchExpenses() async {
            do {
                let expenses = try await databaseManager.fetchExpenses()
                expenseList = [] // Reset list before adding fresh items
                
                let filteredExpenses = expenses.filterByMonth(monthYears[selectedMonthYear])
                
                // Group and sum by category
                Category.allCases.forEach { category in
                    let expenseByCategory = filteredExpenses.filter { $0.category == category }
                    if !expenseByCategory.isEmpty {
                        let total = expenseByCategory.reduce(0) { $0 + $1.amount }
                        self.expenseList.append(.init(amount: total, category: category))
                    }
                }
            } catch {
                showError = true
                errorMessage = error.localizedDescription
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
    }
}
