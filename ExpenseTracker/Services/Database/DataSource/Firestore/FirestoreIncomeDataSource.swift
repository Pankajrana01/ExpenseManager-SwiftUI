//
//  FirestoreIncomeDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

/// A concrete implementation of `IncomeDataSource` that uses Firestore as
/// the persistent backend for storing, reading, updating, and deleting income records.
///
/// Each user's incomes are stored under their Firestore user document,
/// within a subcollection named "incomes".
final class FirestoreIncomeDataSource: IncomeDataSource {
    
    /// Reference to the Firestore collection where incomes are stored for a specific user.
    private let collection: CollectionReference
    
    /// Initializes the data source with the Firestore collection reference scoped to a user.
    ///
    /// - Parameter userId: The unique identifier for the user whose incomes
    ///                     are to be accessed.
    init(userId: String) {
        let firestore = Firestore.firestore()
        self.collection = firestore
            .collection("users")
            .document(userId)
            .collection("incomes")
    }
    
    /// Fetches all income records for the current user from Firestore.
    ///
    /// - Returns: An array of `DatabaseIncome` objects representing all stored incomes.
    /// - Throws: Propagates any Firestore errors or decoding failures.
    func readAll() async throws -> [DatabaseIncome] {
        var _incomes: [DatabaseIncome] = []
        let documents = try await collection.getDocuments().documents
        for document in documents {
            let income = try document.data(as: DatabaseIncome.self)
            _incomes.append(income)
        }
        return _incomes
    }
    
    /// Deletes all income records for the current user from Firestore.
    ///
    /// - Throws: Propagates any Firestore errors during deletion.
    func deleteAll() async throws {
        let documents = try await collection.getDocuments().documents
        // Note: Batch deletion is recommended for efficiency.
        documents.forEach { $0.reference.delete() }
    }
    
    /// Creates a new income document in Firestore.
    ///
    /// - Parameter item: The `DatabaseIncome` to create.
    /// - Throws: `ExpenseTrackerError.invalidData` if the income cannot be encoded,
    ///           or any Firestore errors during creation.
    func create(_ item: DatabaseIncome) async throws {
        if let data = try item.data() {
            try await collection.addDocument(data: data)
        } else {
            throw ExpenseTrackerError.invalidData
        }
    }
    
    /// Updates an existing income document identified by its `id`.
    ///
    /// - Parameter item: The `DatabaseIncome` with updated data.
    /// - Throws: `ExpenseTrackerError.invalidData` if encoding fails,
    ///           or Firestore errors if update fails.
    ///
    /// - Note: Updates all documents matching the `id` field, which should be unique.
    func update(_ item: DatabaseIncome) async throws {
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
    
    /// Deletes an income document identified by its `id`.
    ///
    /// - Parameter item: The `DatabaseIncome` to delete.
    /// - Throws: Firestore errors during deletion.
    ///
    /// - Note: Deletes all documents matching the `id` field, which should be unique.
    func delete(_ item: DatabaseIncome) async throws {
        let documents = try await collection
            .whereField("id", isEqualTo: item.id)
            .getDocuments()
            .documents
        documents.forEach { $0.reference.delete() }
    }
}

/// Converts a `DatabaseIncome` into a dictionary format suitable for Firestore.
extension DatabaseIncome {
    func data() throws -> [String: Any]? {
        let encoded = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any]
    }
}
