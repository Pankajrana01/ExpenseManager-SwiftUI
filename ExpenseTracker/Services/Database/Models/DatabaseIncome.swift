//
//  DatabaseIncome.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 02/04/25.
//

import Foundation

/// A model representing an income record in the database.
struct DatabaseIncome: Codable {
    /// Unique identifier for the income record.
    let id: String
    
    /// The amount of income.
    let amount: Double
    
    /// The date of the income transaction in `String` format (e.g., `"2025-04-01"`).
    let date: String
    
    /// The source of the income (e.g., `"Salary"`, `"Freelance"`, `"Investment"`).
    let source: String
    
    /// Additional notes or details about the income.
    let note: String
    
    /// Initializes a new `DatabaseIncome` instance.
    /// - Parameters:
    ///   - id: A unique identifier for the income (default: `UUID().uuidString`).
    ///   - amount: The amount of income.
    ///   - date: The date of the income transaction.
    ///   - source: The source of the income.
    ///   - note: Additional details or comments about the income.
    init(id: String = UUID().uuidString, amount: Double, date: String, source: String, note: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.source = source
        self.note = note
    }
}

extension DatabaseIncome {
    static var sample1: DatabaseIncome {
        .init(amount: 10000.0, date: Date().formattedString(), source: Source.salary.rawValue, note: "")
    }
    static var sample2: DatabaseIncome {
        .init(amount: 5000.0, date: Date().byAdding(.day, value: 14).formattedString(), source: Source.rental.rawValue, note: "")
    }
    static var sample3: DatabaseIncome {
        .init(amount: 2000.0, date: Date().byAdding(.day, value: 19).formattedString(), source: Source.other.rawValue, note: "Freelancer work")
    }
    
    static var sample1_1: DatabaseIncome {
        .init(amount: 10000.0, date: Date().byAdding(.month, value: -1).formattedString(), source: Source.salary.rawValue, note: "")
    }
    static var sample2_1: DatabaseIncome {
        .init(amount: 5000.0, date: Date().byAdding(.month, value: -1).byAdding(.day, value: 14).formattedString(), source: Source.rental.rawValue, note: "")
    }
    static var sample3_1: DatabaseIncome {
        .init(amount: 4000.0, date: Date().byAdding(.month, value: -1).byAdding(.day, value: 19).formattedString(), source: Source.other.rawValue, note: "Freelancer work")
    }
}
