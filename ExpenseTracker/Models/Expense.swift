//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/05/25.
//

import Foundation

/// A structure representing an individual expense entry.
///
/// Conforms to `Identifiable` (for use in SwiftUI) and `Codable` (for easy encoding and decoding).
///
/// Example usage:
/// ```swift
/// let expense = Expense(id: UUID().uuidString, name: "Lunch", amount: 250.0, date: Date(), category: .food, note: "Had lunch at a restaurant")
/// ```
struct Expense: Transaction {
    /// A unique identifier for the expense.
    let id: String
    /// The name or description of the expense.
    let name: String
    /// The amount spent on the expense.
    let amount: Double
    /// The stored date in string format.
    let date: String
    
    /// The stored expense category as a string.
    private let _category: String
    /// The expense category, converted from `_category`, defaults to `.other` if an invalid type is encountered.
    var category: Category {
        Category(rawValue: _category) ?? .other
    }
    
    /// Any additional notes or remarks about the expense.
    let note: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case date
        case _category = "category"
        case note
    }
    
    /// Initializes a new `Expense` instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the expense.
    ///   - name: The name or description of the expense.
    ///   - amount: The amount spent.
    ///   - date: The date of the expense.
    ///   - category: The category of the expense.
    ///   - note: Additional notes about the expense.
    init(id: String, name: String, amount: Double, date: Date, category: Category, note: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date.formattedString()
        self._category = category.rawValue
        self.note = note
    }
}

extension Expense {
    static var sample: Expense {
        .init(
            id: UUID().uuidString,
            name: "Groceries",
            amount: 100.0,
            date: Date(),
            category: .food,
            note: "Weekly shopping"
        )
    }
}

extension [Expense] {
    
    /// Sorts the array of `Expense` items based on the specified sorting option and order.
    ///
    /// - Parameters:
    ///   - sortingOption: The criterion by which the expenses should be sorted (date, amount, or name).
    ///   - isDescending: A Boolean value indicating the order direction. `true` for descending, `false` for ascending.
    ///
    /// - Returns: A sorted array of `Expense` items.
    func sorted(by sortingOption: SortingOption, isDescending: Bool) -> [Expense] {
        switch (sortingOption, isDescending) {
            
        case (.date, true):
            // Sort by date — newest first
            return self.sorted { $0.formattedDate > $1.formattedDate }
            
        case (.date, false):
            // Sort by date — oldest first
            return self.sorted { $0.formattedDate < $1.formattedDate }
            
        case (.amount, true):
            // Sort by amount — highest first
            return self.sorted { $0.amount > $1.amount }
            
        case (.amount, false):
            // Sort by amount — lowest first
            return self.sorted { $0.amount < $1.amount }
            
        case (.name, true):
            // Sort by name — reverse alphabetical order (Z to A)
            return self.sorted { $0.name > $1.name }
            
        case (.name, false):
            // Sort by name — alphabetical order (A to Z)
            return self.sorted { $0.name < $1.name }
        }
    }
    
    /// Filters the array of `Expense` objects to only include those that belong to the current month and year.
    ///
    /// - Parameter month: A custom date format string (default is "MMMM yyyy"). Represent the expenses belogs to the month.
    ///
    /// - Returns: A new array of `Expense` objects from the current calendar month.
    ///
    /// - Note: Uses the "MMMM yyyy" format to compare month and year (e.g., "April 2025").
    func filterByMonth(_ month: String) -> [Expense] {
        return self.filter {
            $0.formattedDate
                .formattedString(dateFormat: "MMMM yyyy")
                .localizedCaseInsensitiveContains(month)
        }
    }
}
