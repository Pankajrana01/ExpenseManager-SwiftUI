//
//  FirestoreUserDataSource.swift
//  ExpenseTracker
//
//  Created by Pankaj Rana on 20/05/25.
//

import FirebaseCore
import FirebaseFirestore
import Foundation

/// A Firestore-based implementation of `UserDataSource` that manages user details
/// stored in a Firestore subcollection "user_details" under each user's document.
///
/// Each user is expected to have a unique `id` and their data is encoded/decoded
/// using Codable to/from Firestore document format.
final class FirestoreUserDataSource: UserDataSource {
    
    /// Reference to the Firestore collection that holds user detail documents.
    private let collection: CollectionReference
    
    /// Initializes the data source scoped to a particular user.
    ///
    /// - Parameter userId: The unique identifier of the user.
    ///   The user's data is stored in:
    ///   `users/{userId}/user_details/`
    init(userId: String) {
        let firestore = Firestore.firestore()
        self.collection = firestore
            .collection("users")
            .document(userId)
            .collection("user_details")
    }
    
    /// Fetches the user details document for the current user.
    ///
    /// - Returns: A `DatabaseUser` object if found, otherwise `nil`.
    /// - Throws: Propagates Firestore or decoding errors.
    func read() async throws -> DatabaseUser? {
        let documents = try await collection.getDocuments().documents
        guard let document = documents.first else { return nil }
        return try document.data(as: DatabaseUser.self)
    }
    
    /// Creates a new user details document in Firestore.
    ///
    /// - Parameter item: The `DatabaseUser` object to create.
    /// - Throws: `ExpenseTrackerError.invalidData` if encoding fails,
    ///           or Firestore errors if the creation fails.
    func create(_ item: DatabaseUser) async throws {
        guard let data = try item.data() else {
            throw ExpenseTrackerError.invalidData
        }
        try await collection.addDocument(data: data)
    }
    
    /// Updates the user details document(s) matching the user `id`.
    ///
    /// - Parameter item: The `DatabaseUser` with updated data.
    /// - Throws: `ExpenseTrackerError.invalidData` if encoding fails,
    ///           or Firestore errors during update.
    ///
    /// - Note: If multiple documents with the same `id` exist (which should not happen),
    ///   all are updated.
    func update(_ item: DatabaseUser) async throws {
        let documents = try await collection
            .whereField("id", isEqualTo: item.id)
            .getDocuments()
            .documents
        guard let data = try item.data() else {
            throw ExpenseTrackerError.invalidData
        }
        documents.forEach { $0.reference.updateData(data) }
    }
    
    /// Deletes the user details document(s) matching the user `id`.
    ///
    /// - Parameter item: The `DatabaseUser` to delete.
    /// - Throws: Firestore errors during deletion.
    ///
    /// - Note: Deletes all documents with the matching `id`.
    func delete(_ item: DatabaseUser) async throws {
        let documents = try await collection
            .whereField("id", isEqualTo: item.id)
            .getDocuments()
            .documents
        documents.forEach { $0.reference.delete() }
    }
}

extension DatabaseUser {
    /// Converts the `DatabaseUser` instance into a dictionary suitable for Firestore storage.
    ///
    /// - Returns: A `[String: Any]` dictionary representation of the user.
    /// - Throws: Any encoding or serialization errors.
    func data() throws -> [String: Any]? {
        let encoded = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: encoded, options: []) as? [String: Any]
    }
}
