//
//  Income.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 28/05/25.
//

import Foundation

/// A model representing an income entry in the income tracker.
///
/// The `Income` struct is used to store information about different sources of income, including the amount received,
/// the category of income (`Source`), and the date of receipt.
///
/// - Conforms to `Identifiable` to allow unique identification within lists.
/// - Conforms to `Codable` for easy encoding/decoding when storing or retrieving data.
struct Income: Transaction {
    /// Unique identifier for the income entry.
    let id: String
    
    /// The amount of income received.
    let amount: Double
    
    /// The stored source type as a string.
    private let _source: String
    /// The source of the income (e.g., Salary, Business, Interest, etc.)., converted from `_source`,
    /// defaults to `.other` if an invalid type is encountered.
    var source: Source {
        Source(rawValue: _source) ?? .other
    }
    
    /// The stored date in string format.
    let date: String
    
    /// Any additional notes or remarks about the income.
    let note: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case _source = "source"
        case date
        case note
    }
    
    /// Initializes a new `Income` instance.
    /// - Parameters:
    ///   - id: A unique identifier for the income (default: `UUID().uuidString`).
    ///   - amount: The amount of income received.
    ///   - source: The category of the income.
    ///   - date: The date when the income was received.
    ///   - note: Additional notes about the income.
    init(id: String, amount: Double, source: Source, date: Date, note: String) {
        self.id = id
        self.amount = amount
        self._source = source.rawValue
        self.date = date.formattedString()
        self.note = note
    }
}

extension Income {
    static var sample: Income {
        .init(
            id: UUID().uuidString,
            amount: 10000.0,
            source: .salary,
            date: Date(),
            note: ""
        )
    }
}

extension [Income] {
    
    /// Sorts the array of `Income` objects based on a selected `SortingOption` and `Ordering`.
    ///
    /// - Parameters:
    ///   - sortingOption: The option by which to sort the incomes (e.g., date, amount).
    ///   - isDescending: A Boolean value indicating the order direction. `true` for descending, `false` for ascending.
    ///
    /// - Returns: A sorted array of `Income` items.
    func sorted(by sortingOption: SortingOption, isDescending: Bool) -> [Income] {
        switch (sortingOption, isDescending) {
        case (.date, true):
            // Sort by newest date first
            return self.sorted { $0.formattedDate > $1.formattedDate }
            
        case (.date, false):
            // Sort by oldest date first
            return self.sorted { $0.formattedDate < $1.formattedDate }
            
        case (.amount, true):
            // Sort by highest income amount first
            return self.sorted { $0.amount > $1.amount }
            
        case (.amount, false):
            // Sort by lowest income amount first
            return self.sorted { $0.amount < $1.amount }
            
        default:
            // Sorting by name is not applicable for Income, return as-is
            return self
        }
    }
    
    /// Filters the income entries to include only those that were received in the current month and year.
    ///
    /// - Parameter month: A custom date format string (default is "MMMM yyyy"). Represent the incomes belogs to the month.
    ///
    /// - Returns: An array of `Income` objects that belong to the current calendar month.
    ///
    /// - Note: The date is formatted as "MMMM yyyy" (e.g., "April 2025") to ensure a match based on both month and year.
    func filterByMonth(_ month: String) -> [Income] {
        return self.filter {
            $0.formattedDate
                .formattedString(dateFormat: "MMMM yyyy")
                .localizedCaseInsensitiveContains(month)
        }
    }
}
