//
//  DatabaseExpense.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 01/04/25.
//

import Foundation

/// A model representing an expense record stored in the database.
struct DatabaseExpense: Codable {
    
    /// Unique identifier for the expense.
    let id: String
    
    /// The name or description of the expense.
    let name: String
    
    /// The amount spent.
    let amount: Double
    
    /// The date of the expense in `yyyy-MM-dd` format.
    let date: String
    
    /// The category of the expense.
    let category: String
    
    /// Additional notes or details about the expense.
    let note: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case date
        case category = "type"
        case note
    }
    
    /// Initializes a new expense entry.
    /// - Parameters:
    ///   - id: The unique identifier for the expense. Defaults to a new UUID string.
    ///   - name: The name or description of the expense.
    ///   - amount: The amount spent.
    ///   - date: The date of the expense in `yyyy-MM-dd` format.
    ///   - category: The category of expense.
    ///   - note: Additional details or comments about the expense.
    init(id: String = UUID().uuidString, name: String, amount: Double, date: String, category: String, note: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
    }
}


extension DatabaseExpense {
    static var sample1: DatabaseExpense {
        .init(name: "Groceries", amount: 2100.50, date: Date().formattedString(), category: "Food", note: "")
    }
    static var sample2: DatabaseExpense {
        .init(name: "Movie", amount: 1000.50, date: Date().byAdding(.day, value: 4).formattedString(), category: "Entertainment", note: "The Dark Knight Rises")
    }
    static var sample3: DatabaseExpense {
        .init(name: "Cab", amount: 500.00, date: Date().byAdding(.day, value: 5).formattedString(), category: "Travel", note: "To office")
    }
    static var sample4: DatabaseExpense {
        .init(name: "Coffee", amount: 12.50, date: Date().byAdding(.day, value: 9).formattedString(), category: "Food", note: "1 cup")
    }
    
    static var sample1_1: DatabaseExpense {
        .init(name: "Groceries", amount: 2000.50, date: Date().byAdding(.month, value: -1).formattedString(), category: "Food", note: "")
    }
    static var sample2_1: DatabaseExpense {
        .init(name: "Movie", amount: 1000.50, date: Date().byAdding(.month, value: -1).byAdding(.day, value: 4).formattedString(), category: "Entertainment", note: "The Dark Knight")
    }
    static var sample3_1: DatabaseExpense {
        .init(name: "Cab", amount: 1500.00, date: Date().byAdding(.month, value: -1).byAdding(.day, value: 5).formattedString(), category: "Travel", note: "To outstation")
    }
    static var sample4_1: DatabaseExpense {
        .init(name: "Coffee", amount: 50, date: Date().byAdding(.month, value: -1).byAdding(.day, value: 9).formattedString(), category: "Food", note: "4 cups")
    }
}
