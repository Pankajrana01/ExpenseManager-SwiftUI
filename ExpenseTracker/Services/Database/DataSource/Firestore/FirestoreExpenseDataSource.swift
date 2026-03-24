//
//  FirestoreExpenseDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

/// A concrete implementation of `ExpenseDataSource` that uses Firestore as
/// the persistent backend for storing, reading, updating, and deleting expenses.
///
/// This class stores each user's expenses under their Firestore user document,
/// within a subcollection named "expenses".
final class FirestoreExpenseDataSource: ExpenseDataSource {
    
    /// Reference to the Firestore collection where expenses are stored for a specific user.
    private let collection: CollectionReference
    
    /// Initializes the data source with the Firestore collection reference scoped to a user.
    ///
    /// - Parameter userId: The unique identifier for the user whose expenses
    ///                     are to be accessed.
    init(userId: String) {
        let firestore = Firestore.firestore()
        self.collection = firestore
            .collection("users")
            .document(userId)
            .collection("expenses")
    }

    /// Fetches all expenses for the current user from Firestore.
    ///
    /// - Returns: An array of `DatabaseExpense` objects representing all stored expenses.
    /// - Throws: Propagates any Firestore errors or decoding failures.
    func readAll() async throws -> [DatabaseExpense] {
        var _expenses: [DatabaseExpense] = []
        let documents = try await collection.getDocuments().documents
        for document in documents {
            let expense = try document.data(as: DatabaseExpense.self)
            _expenses.append(expense)
        }
        return _expenses
    }
    
    /// Deletes all expenses for the current user from Firestore.
    ///
    /// - Throws: Propagates any Firestore errors during deletion.
    func deleteAll() async throws {
        let documents = try await collection.getDocuments().documents
        // Firestore batch deletes are recommended, but here deletes are done individually.
        documents.forEach { $0.reference.delete() }
    }
    
    /// Creates a new expense document in Firestore.
    ///
    /// - Parameter item: The `DatabaseExpense` to create.
    /// - Throws: `ExpenseTrackerError.invalidData` if the expense cannot be encoded,
    ///           or any Firestore errors during creation.
    func create(_ item: DatabaseExpense) async throws {
        if let data = try item.data() {
            try await collection.addDocument(data: data)
        } else {
            throw ExpenseTrackerError.invalidData
        }
    }
    
    /// Updates an existing expense document identified by its `id`.
    ///
    /// - Parameter item: The `DatabaseExpense` with updated data.
    /// - Throws: `ExpenseTrackerError.invalidData` if encoding fails,
    ///           or Firestore errors if update fails.
    ///
    /// - Note: Updates all documents matching the `id` field, which should be unique.
    func update(_ item: DatabaseExpense) async throws {
        let documents = try await collection
            .whereField("id", isEqualTo: item.id)
            .getDocuments()
            .documents
        if let data = try item.data() {
            documents.forEach { $0.reference.updateData(data) }
        } else {
            throw ExpenseTrackerError.invalidData
        }
    }
    
    /// Deletes an expense document identified by its `id`.
    ///
    /// - Parameter item: The `DatabaseExpense` to delete.
    /// - Throws: Firestore errors during deletion.
    ///
    /// - Note: Deletes all documents matching the `id` field, which should be unique.
    func delete(_ item: DatabaseExpense) async throws {
        let documents = try await collection
            .whereField("id", isEqualTo: item.id)
            .getDocuments()
            .documents
        documents.forEach { $0.reference.delete() }
    }
}

/// Converts a `DatabaseExpense` into a dictionary format suitable for Firestore.
extension DatabaseExpense {
    func data() throws -> [String: Any]? {
        let encoded = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any]
    }
}
