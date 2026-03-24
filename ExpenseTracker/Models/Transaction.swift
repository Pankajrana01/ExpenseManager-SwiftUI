//
//  Transaction.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 03/04/25.
//

import Foundation

/// A protocol that represents a financial transaction, such as an expense or income.
/// Conforming types must have a unique identifier, an amount, and a date.
protocol Transaction: Identifiable, Codable {
    /// A unique identifier for the transaction.
    var id: String { get }
    
    /// The monetary amount of the transaction.
    var amount: Double { get }
    
    /// The date of the transaction in string format.
    ///
    /// - Format: `"yyyy-MM-dd"` (Default format).
    var date: String { get }
    
    /// Any additional notes or remarks about the transaction.
    var note: String { get }

    /// A computed property that converts the string-based date into a `Date` object.
    var formattedDate: Date { get }
}

/// An extension that provides a default implementation for `formattedDate`.
extension Transaction {
    /// Converts the `date` string into a `Date` object using the default format.
    ///
    /// - Returns: A `Date` object representing the transaction date.
    var formattedDate: Date {
        date.toDate()
    }
}
