//
//  ExpenseTrackerError.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 01/04/25.
//

import Foundation

/// An enumeration representing the possible errors that can occur in the expense tracker system.
///
/// This enum conforms to the `Error` protocol and is used to handle different error scenarios
/// that can arise during operations such as date parsing, data retrieval, or invalid inputs.
///
/// Example usage:
/// ```swift
/// if let expense = expenseData {
///     // Process expense data
/// } else {
///     throw ExpenseTrackerError.dataNotFound
/// }
/// ```
enum ExpenseTrackerError: Error {
    
    /// Indicates that the provided date format is invalid.
    case invalidDateFormat
    
    /// Indicates that the provided year is invalid (e.g., cannot be extracted from the date).
    case invalidYear
    
    /// Indicates that the provided month is invalid (e.g., cannot be extracted from the date).
    case invalidMonth
    
    /// Indicates that the requested data could not be found.
    case dataNotFound
    
    /// Indicates that the data is invalid.
    case invalidData
}
